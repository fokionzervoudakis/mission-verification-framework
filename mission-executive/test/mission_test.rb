require 'minitest/autorun'

require_relative '../mission'

OpLoader.attr_reader :actions

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

  # Actions each single-asset plan leaves unfinished when endurance runs out.
  UNFINISHED = {
    operation_1a: [], operation_1b: [], operation_1c: [1], operation_1d: [],
    operation_1e: [2], operation_1f: [2], operation_1g: []
  }.freeze

  UNFINISHED.each_pair do |operation, unfinished|
    define_method("test_#{operation}_leaves_actions_#{unfinished}_unfinished") do
      loader = OpLoader.new(operation)
      Mission.execute(loader.assets)

      assert_equal unfinished, loader.actions.reject { |_id, action| action.completed? }.keys
    end
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

  def test_filter_alone_selects_every_operation
    assert_equal operations, operations('filter')
  end

  def test_filter_with_an_operation_selects_only_that_operation
    assert_equal %w[operation_1a], operations('filter', 'operation_1a')
  end

  def test_unknown_operation_aborts_with_a_message
    _out, err = capture_io { assert_raises(SystemExit) { operations('nope') } }

    assert_equal "unknown operation: nope\n", err
  end

  def test_support_file_is_not_an_operation
    _out, err = capture_io { assert_raises(SystemExit) { operations('schema') } }

    assert_equal "unknown operation: schema\n", err
  end

  private

  # The operations the scripts would run for the given command-line arguments.
  def operations(*args)
    argv = ARGV.dup
    ARGV.replace(args)
    [].tap { |operations| execute { |operation| operations.push(operation) } }
  ensure
    ARGV.replace(argv)
  end
end
