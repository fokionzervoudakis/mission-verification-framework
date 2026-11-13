require 'minitest/autorun'

require_relative '../mission'

class MissionTest < Minitest::Test
  # Stands in for a concurrent action, counting how often it is driven.
  class Concurrency
    attr_reader :executions

    def initialize
      @executions = 0
    end

    def execute
      @executions += 1
    end
  end

  def setup
    ARDrone.endurance = 70
    Hummingbird.endurance = 120
  end

  # operation_1d
  def test_sequential_actions_complete_when_they_exactly_fit_the_endurance
    first, second = fly(ARDrone, 40, 30)

    assert_predicate first, :completed?
    assert_predicate second, :completed?
  end

  # operation_1e
  def test_dependent_action_fails_when_its_precondition_overruns
    first, second = fly(ARDrone, 41, 30)

    assert_predicate first, :completed?
    refute_predicate second, :completed?
  end

  # operation_1f
  def test_dependent_action_fails_when_it_overruns_the_endurance
    first, second = fly(ARDrone, 40, 31)

    assert_predicate first, :completed?
    refute_predicate second, :completed?
  end

  def test_action_waits_for_every_precondition
    action = Action.new(3, 1)
    preconditions = [Action.new(1, 1), Action.new(2, 1)]
    preconditions.each { |precondition| action.add_precondition(precondition) }

    preconditions.first.execute
    action.execute
    refute_predicate action, :completed?

    preconditions.last.execute
    action.execute
    assert_predicate action, :completed?
  end

  def test_completed_action_releases_every_dependent
    precondition = Action.new(1, 1)
    dependents = [Action.new(2, 1), Action.new(3, 1), Action.new(4, 1)]
    dependents.each { |dependent| dependent.add_precondition(precondition) }

    precondition.execute
    dependents.each(&:execute)

    dependents.each { |dependent| assert_predicate dependent, :completed? }
  end

  def test_hover_action_drives_its_concurrencies_only_once_it_is_ready
    precondition = Action.new(1, 1)
    hover = HoverAction.new(2, 3)
    hover.add_precondition(precondition)
    concurrency = Concurrency.new
    hover.add_concurrency(concurrency)

    hover.execute
    assert_equal 0, concurrency.executions

    precondition.execute
    3.times { hover.execute }

    assert_equal 3, concurrency.executions
  end

  private

  # Flies a single asset whose two actions run one after the other.
  def fly(asset_class, first_duration, second_duration)
    first = HoverAction.new(1, first_duration)
    second = HoverAction.new(2, second_duration)
    second.add_precondition(first)

    asset = asset_class.new(1)
    [first, second].each { |action| asset.add_action(action) }
    Mission.execute([asset])

    [first, second]
  end
end
