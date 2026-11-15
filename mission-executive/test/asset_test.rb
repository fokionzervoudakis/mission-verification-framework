require 'minitest/autorun'
require 'timeout'

require_relative '../mission'

class AssetTest < Minitest::Test
  def test_asset_spends_no_endurance_before_its_first_action_can_run
    run_pair(2, 2, 2).each { |action| assert_predicate action, :completed? }
  end

  def test_mission_ends_when_the_remaining_assets_can_never_start
    run_pair(1, 2, 1).each { |action| refute_predicate action, :completed? }
  end

  def test_sensor_action_stops_when_no_kinetic_action_runs
    asset = Class.new(Asset) { self.endurance = 3 }.new(1)
    hover = HoverAction.new(1, 1)
    photo = PhotoSurveillanceAction.new(2, 2)
    [hover, photo].each { |action| asset.add_action(action) }

    Mission.execute([asset])

    assert_predicate hover, :completed?
    refute_predicate photo, :completed?
  end

  def test_mission_ends_when_an_asset_in_flight_has_to_wait
    type = Class.new(Asset) { self.endurance = 9 }
    actions = [Action.new(1, 1), Action.new(2, 1), Action.new(3, 2)]
    actions[1].add_precondition(actions[2])
    assets = [type.new(1), type.new(2)]
    actions.first(2).each { |action| assets.first.add_action(action) }
    assets.last.add_action(actions.last)

    Mission.execute(assets)

    assert_equal [true, false, false], actions.map(&:completed?)
  end

  private

  # Runs two assets of the given endurance with one action each, the second
  # action waiting on the first, and returns the actions.
  def run_pair(endurance, first, second)
    actions = [Action.new(1, first), Action.new(2, second)]
    actions.last.add_precondition(actions.first)
    type = Class.new(Asset) { self.endurance = endurance }
    assets = actions.map { |action| type.new(1).tap { |asset| asset.add_action(action) } }
    Timeout.timeout(5) { Mission.execute(assets) }
    actions
  end
end
