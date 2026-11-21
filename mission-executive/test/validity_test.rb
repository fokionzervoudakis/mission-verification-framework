require 'minitest/autorun'
require 'open3'

class ValidityTest < Minitest::Test
  # A "?- <goal>." query holds unless its line ends in "% false"; swipl
  # reports each query that does not hold as a warning naming its line.
  %w[existential_quantification_rules_test existential_quantification_rules_valid_test].each do |name|
    define_method("test_#{name}_queries_match_the_annotations") do
      file = "../prolog-kb/#{name}.pl"
      annotated = File.readlines(file).each_with_index.select { |line, _index| line.match?(/^\?- .*% false$/) }
      _output, warnings, status = Open3.capture3('swipl', '--on-error=status', '-q', '-s', file, '-t', 'halt')
      assert_predicate status, :success?

      assert_equal annotated.map { |_line, index| index + 1 },
                   warnings.scan(/^Warning: .*:(\d+):$/).flatten.map(&:to_i)
    end
  end
end
