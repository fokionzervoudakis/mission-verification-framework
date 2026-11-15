require 'minitest/autorun'
require 'open3'
require 'yaml'

require_relative '../action'

class ClassifierTest < Minitest::Test
  Dir['../prolog-kb/operation_*.pl'].each do |file|
    operation = File.basename(file, '.pl')

    define_method("test_#{operation}_classifications_match_the_annotations") do
      assert_equal annotated(File.read(file)), classified(classify(file))
    end

    define_method("test_#{operation}_classification_file_is_confirmed") do
      refute_empty assigned(operation)

      assert_empty assigned(operation) - classified(classify(file))
    end

    define_method("test_#{operation}_facts_match_the_plan") do
      facts = File.read(file).scan(/^(\w+)\(([\w, ]+)\)\.$/).map { |fact, terms| [fact, *terms.split(', ')] }

      assert_equal planned(operation).sort, facts.sort
    end
  end

  private

  # The facts a plan calls for: its assets, its kinetic actions, who owns
  # them and what they wait for.
  def planned(operation)
    plan = YAML.safe_load_file("operations/#{operation}.yaml")
    kinetic = plan.fetch('Action').select { |type, _actions| Object.const_get(type) < KineticAction }
    names = kinetic.flat_map { |type, actions| actions.map { |action| [action['id'], term(type, action['id'])] } }.to_h

    action_facts(kinetic.values.flatten, names) + asset_facts(plan.fetch('Asset'), names)
  end

  def action_facts(actions, names)
    actions.flat_map do |action|
      name = names.fetch(action['id'])
      waits = action.fetch('preconditions', []).map { |id| ['has_precondition', name, names.fetch(id)] }
      [['kinetic_action', name]] + waits
    end
  end

  def asset_facts(assets, names)
    assets.flat_map do |type, list|
      list.each_with_index.flat_map do |asset, index|
        owned = names.values_at(*asset.fetch('actions')).compact
        [['asset', term(type, index + 1)]] + owned.map { |action| ['has_action', term(type, index + 1), action] }
      end
    end
  end

  # The name the knowledge base gives an element of a plan.
  def term(type, number)
    "#{type.gsub(/(?<=[a-z])(?=[A-Z])/, '_').downcase}_#{number}"
  end

  def classify(file)
    output, status = Open3.capture2('swipl', '--on-error=status', '-q', '-s', file, '-t', 'halt')
    assert_predicate status, :success?

    output
  end

  # The outcome the classification file expects for each element, under the
  # name the knowledge base uses: actions are numbered by id, assets within
  # their type.
  def assigned(operation)
    YAML.safe_load_file("classifications/#{operation}.yaml").flat_map do |kind, types|
      types.flat_map do |type, elements|
        elements.each_with_index.filter_map do |element, index|
          next unless element['type']

          [term(type, kind == 'Asset' ? index + 1 : element['id']), element['type'].tr('_', ' '), true]
        end
      end
    end
  end

  # The outcome each "?- check_<class>(<element>)." query is annotated with:
  # the element is in the class unless the line ends in "% false".
  def annotated(source)
    source.scan(/^\?- check_(\w+)\((\w+)\)\.(.*)$/).map do |classification, element, annotation|
      [element, classification.tr('_', ' '), !annotation.include?('% false')]
    end
  end

  # The outcome the classifier printed for each query.
  def classified(output)
    results = output.gsub(/\e\[\d+m/, '').scan(/^(Success|Warning): (\w+) is (?:not )?an? (.+)$/)
    results.map { |result, element, classification| [element, classification, result == 'Success'] }
  end
end
