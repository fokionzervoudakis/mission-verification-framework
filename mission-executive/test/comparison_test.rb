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
    table = File.readlines('../data/model-comparison.md').grep(/^\| operation_/)
    rows = table.map { |row| row.split('|').map(&:strip) }
    executive = rows.to_h { |row| row.values_at(1, 5) }
    disagreeing = rows.select { |row| row[6] == 'no' }.map { |row| row[1] }

    assert_equal output.scan(/executing (\w+)\.\.\.\n  (.*)/).to_h, executive
    assert_empty disagreeing
  end
end
