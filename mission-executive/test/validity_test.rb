require 'minitest/autorun'
require 'open3'

class ValidityTest < Minitest::Test
  FILE = '../prolog-kb/existential_quantification_rules_test.pl'.freeze

  # A "?- <goal>." query holds unless its line ends in "% false"; swipl
  # reports each query that does not hold as a warning naming its line.
  def test_validity_queries_match_the_annotations
    annotated = File.readlines(FILE).each_with_index.select { |line, _index| line.match?(/^\?- .*% false$/) }
    _output, warnings, status = Open3.capture3('swipl', '--on-error=status', '-q', '-s', FILE, '-t', 'halt')
    assert_predicate status, :success?

    assert_equal annotated.map { |_line, index| index + 1 }, warnings.scan(/^Warning: .*:(\d+):$/).flatten.map(&:to_i)
  end
end
