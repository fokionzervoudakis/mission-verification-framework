require 'minitest/autorun'
require 'open3'

require_relative '../mission'

# The executive against the PRISM results that just verify writes to
# data/model-results.csv.
class ComparisonTest < Minitest::Test
  # The probability that the actions of each plan complete.
  COMPLETE = File.readlines('../data/model-results.csv').drop(1).each_with_object({}) do |line, complete|
    operation, probability = line.match(/^(\w+),".*",[\d.]+,([\d.]*),/).captures
    complete[operation] ||= probability.to_f
  end.freeze

  COMPLETE.each_pair do |operation, probability|
    define_method("test_#{operation}_agrees_with_the_model") do
      loader = OpLoader.new(operation)
      Mission.execute(loader.assets)

      assert_equal probability.positive?, loader.unfinished.empty?
    end
  end

  def test_comparison_table_is_up_to_date
    output, = Open3.capture2('./mission.rb')
    table = File.readlines('../data/model-comparison.md').grep(/^\| operation_/)
    rows = table.map { |row| row.split('|').map(&:strip) }
    executive = rows.to_h { |row| row.values_at(1, 5) }
    disagreeing = rows.select { |row| row[6] == 'no' }.map { |row| row[1] }

    assert_equal output.scan(/executing (\w+)\.\.\.\n  (.*)/).to_h, executive
    assert_empty disagreeing
  end
end
