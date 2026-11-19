require 'minitest/autorun'
require 'open3'
require 'tempfile'
require 'yaml'

class PlanTest < Minitest::Test
  def test_every_plan_matches_the_schema
    plans = Dir['operations/operation_*.yaml']
    output, status = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', *plans)
    assert_predicate status, :success?

    # kwalify exits 0 for a plan that breaks the schema
    assert_equal plans.map { |plan| "#{plan}#0: valid.\n" }, output.lines
  end

  # An action with no duration never completes; a zero interval divides by zero.
  { 'duration: 30' => 'duration: 0', 'interval: 5' => 'interval: 0' }.each_pair do |valid, invalid|
    define_method("test_#{invalid.delete(':').tr(' ', '_')}_breaks_the_schema") do
      Tempfile.create(%w[plan .yaml]) do |file|
        file.write(File.read('operations/operation_5a.yaml').sub(valid, invalid))
        file.flush
        output, = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', file.path)

        assert_match(/#0: INVALID\n.*too small/, output)
      end
    end
  end

  # A plan may give an asset its own endurance, up to the limit of its type.
  # An asset with no endurance never runs out of it.
  { 'endurance: 100' => /#0: valid\.\n/,
    'endurance: 121' => /#0: INVALID\n.*too large/,
    'endurance: 0' => /#0: INVALID\n.*too small/ }.each_pair do |endurance, result|
    define_method("test_asset_#{endurance.delete(':').tr(' ', '_')}_is_checked_by_the_schema") do
      Tempfile.create(%w[plan .yaml]) do |file|
        plan = File.read('operations/operation_5a.yaml')
        file.write(plan.sub("    - id: 1\n      actions:", "    - id: 1\n      #{endurance}\n      actions:"))
        file.flush
        output, = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', file.path)

        assert_match(result, output)
      end
    end
  end

  # The ontology sets the endurance limit of each asset type; the defaults
  # and the schema repeat it.
  def test_endurance_limits_match_the_ontology
    ontology = File.read('../ontology/complex_missions.owl')
    schema = YAML.safe_load_file('operations/schema.yaml').dig('mapping', 'Asset', 'mapping')

    YAML.safe_load_file('operations/asset_data.yaml').each_pair do |type, asset|
      restriction = %r{<Class IRI="##{type}"/>\s*<DataSomeValuesFrom>\s*<DataProperty IRI="#hasEnduranceInSeconds"/>}
      limit = ontology[/#{restriction}.*?<Literal[^>]*>(\d+)/m, 1]

      assert_equal limit.to_i, asset.fetch('endurance')
      assert_equal limit.to_i, schema.dig(type, 'sequence', 0, 'mapping', 'endurance', 'range', 'max')
    end
  end

  # The ontology properties that repeat a plan, by the plan key they repeat.
  PROPERTIES = { 'actions' => 'hasAction', 'preconditions' => 'hasPrecondition',
                 'concurrencies' => 'isConcurrentWith' }.freeze

  # The ontology of a mission names each asset and action after its type and
  # id in the plan. Some ontology files have no plan of their own.
  Dir['../ontology/operation_*.owl'].each do |file|
    operation = File.basename(file, '.owl')
    next unless File.exist?("operations/#{operation}.yaml")

    define_method("test_#{operation}_ontology_matches_the_plan") do
      assert_equal plan_facts(operation).sort, ontology_facts(operation).sort
    end
  end

  private

  def plan_facts(operation)
    plan = YAML.safe_load_file("operations/#{operation}.yaml")
    named = ->(types) { types.flat_map { |type, items| items.map { |item| ["#{type}#{item.fetch('id')}", item] } } }
    actions = named[plan.fetch('Action')].to_h { |name, action| [action.fetch('id'), name] }

    (named[plan.fetch('Action')] + named[plan.fetch('Asset')]).flat_map do |name, item|
      [name] + PROPERTIES.flat_map do |key, property|
        item.fetch(key, []).map { |id| "#{property} #{name} #{actions.fetch(id)}" }
      end
    end
  end

  # A mission ontology adds to the ones it imports.
  def ontology_facts(operation)
    source = File.read("../ontology/#{operation}.owl")
    schema = YAML.safe_load_file('operations/schema.yaml').fetch('mapping')
    types = schema.values.flat_map { |kind| kind.fetch('mapping').keys }
    individual = '<NamedIndividual IRI="[^"]*#(\w+)"/>'
    individuals = source.scan(%r{<Class IRI="[^"]*#(\w+)"/>\s*#{individual}})
    assertions = source.scan(%r{<ObjectProperty IRI="[^"]*#(\w+)"/>\s*#{individual}\s*#{individual}})

    individuals.filter_map { |type, name| name if types.include?(type) } +
      assertions.filter_map { |assertion| assertion.join(' ') if PROPERTIES.value?(assertion.first) } +
      source.scan(%r{<Import>.*/(operation_\w+)\.owl</Import>}).flatten.flat_map { |import| ontology_facts(import) }
  end
end
