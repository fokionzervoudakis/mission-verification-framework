require 'minitest/autorun'
require 'open3'

require_relative '../mission'

# The executive against the model states that just states writes to
# data/model-states/.
class ComparisonTest < Minitest::Test
  # The end states of a model: those with no step to another state.
  def self.end_states(sta)
    variables, *states = File.readlines(sta).drop(1).map { |line| line[/\((.*)\)/, 1].split(',') }
    steps = File.readlines(sta.sub('.sta', '.tra')).drop(2).map { |line| line.split.first(2) }
    moving = steps.reject { |from, to| from == to }.map { |from, _to| from.to_i }

    states.reject.with_index { |_state, index| moving.include?(index) }.map { |state| variables.zip(state).to_h }
  end

  # The actions a model leaves unfinished: those with duration left in an end
  # state.
  def self.unfinished(sta)
    end_states(sta).map do |state|
      durations = state.select { |name, value| name.match?(/^d\d+$/) && value.to_i.positive? }
      durations.keys.map { |name| name.delete('d').to_i }
    end.uniq
  end

  Dir['../data/model-states/*.sta'].each do |sta|
    operation = File.basename(sta, '.sta')

    define_method("test_#{operation}_leaves_the_same_actions_unfinished_as_the_model") do
      loader = OpLoader.new(operation)
      Mission.execute(loader.assets)

      assert_equal [loader.unfinished], self.class.unfinished(sta)
    end
  end

  def test_every_plan_has_model_states
    plans = Dir['operations/operation_*.yaml'].map { |file| File.basename(file, '.yaml') }

    assert_equal plans.sort, Dir['../data/model-states/*.sta'].map { |sta| File.basename(sta, '.sta') }.sort
  end

  def test_comparison_table_is_up_to_date
    output, = Open3.capture2('./mission.rb')
    executive = table.to_h { |row| row.values_at(0, 4) }
    disagreeing = table.select { |row| row[5] == 'no' }.map(&:first)

    assert_equal output.scan(/executing (\w+)\.\.\.\n  (.*)/).to_h, executive
    assert_empty disagreeing
  end

  # The table is edited by hand; its other columns come from the plans and
  # from the first property of each model in data/model-results.csv.
  def test_comparison_table_matches_the_plans_and_prism_results
    results = File.read('../data/model-results.csv').scan(/^(\w+),".*?",([\d.]+),([\d.]*),/).uniq(&:first)
    expected = results.map do |operation, succeeds, complete|
      mark = File.read("operations/#{operation}.yaml").include?('point of failure') ? 'point of failure' : ''
      [operation, mark, succeeds.to_f.round(4).to_s, complete.to_f.round(4).to_s]
    end

    assert_equal(expected, table.map { |row| row.first(4) })
    table.each do |row|
      assert_equal (row[3] == '1.0') == (row[4] == 'all actions completed') ? 'yes' : 'no', row[5], row[0]
    end
  end

  private

  # The cells of each plan's row in data/model-comparison.md.
  def table
    rows = File.readlines('../data/model-comparison.md').grep(/^\| operation_/)
    rows.map { |row| row.split('|').map(&:strip).drop(1) }
  end
end
