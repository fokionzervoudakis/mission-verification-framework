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

  def test_idle_sensor_action_does_not_start_its_asset
    type = Class.new(Asset) { self.endurance = 10 }
    actions = [TraversePathSegmentAction.new(1, 8), TraversePathSegmentAction.new(2, 5)]
    actions.last.add_precondition(actions.first)
    assets = actions.map { |action| type.new(1).tap { |asset| asset.add_action(action) } }
    assets.last.add_action(PhotoSurveillanceAction.new(3, 2))

    Mission.execute(assets)

    actions.each { |action| assert_predicate action, :completed? }
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

  def test_idle_sensor_action_does_not_hide_a_wait
    type = Class.new(Asset) { self.endurance = 20 }
    actions = [TraversePathSegmentAction.new(1, 8), TraversePathSegmentAction.new(2, 2),
               TraversePathSegmentAction.new(3, 2)]
    actions.last.add_precondition(actions.first)
    assets = [type.new(1), type.new(2)]
    assets.first.add_action(actions.first)
    [*actions.last(2), PhotoSurveillanceAction.new(4, 15)].each { |action| assets.last.add_action(action) }

    Mission.execute(assets)

    assert_equal [false, true, false], actions.map(&:completed?)
  end

  def test_asset_with_only_a_sensor_action_left_does_not_end_the_mission
    type = Class.new(Asset) { self.endurance = 9 }
    actions = [TraversePathSegmentAction.new(1, 5), TraversePathSegmentAction.new(2, 1)]
    assets = actions.map { |action| type.new(1).tap { |asset| asset.add_action(action) } }
    assets.last.add_action(PhotoSurveillanceAction.new(3, 3))

    Mission.execute(assets)

    actions.each { |action| assert_predicate action, :completed? }
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
