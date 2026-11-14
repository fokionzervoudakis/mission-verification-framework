require 'minitest/autorun'
require 'open3'
require 'yaml'

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
  end

  private

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

          name = type.gsub(/(?<=[a-z])(?=[A-Z])/, '_').downcase
          ["#{name}_#{kind == 'Asset' ? index + 1 : element['id']}", element['type'].tr('_', ' '), true]
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
