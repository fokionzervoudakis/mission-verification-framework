require 'minitest/autorun'
require 'open3'

class ClassifierTest < Minitest::Test
  Dir['../prolog-kb/operation_*.pl'].each do |file|
    define_method("test_#{File.basename(file, '.pl')}_classifications_match_the_annotations") do
      output, status = Open3.capture2('swipl', '--on-error=status', '-q', '-s', file, '-t', 'halt')
      assert_predicate status, :success?

      assert_equal annotated(File.read(file)), classified(output)
    end
  end

  private

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
