require 'minitest/autorun'

require_relative '../op_loader'

class LoaderTest < Minitest::Test
  # Loads a plan given as a hash instead of an operation file.
  class PlanLoader < OpLoader
    private

    def load_file(file, dir = :operations)
      file.is_a?(Hash) ? file.symbolize_keys! : super
    end
  end

  def test_action_id_reused_across_types_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 }],
                           'PhotoSurveillanceAction' => [{ 'id' => 1, 'duration' => 5 }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'duplicate action id: 1', error.message
  end

  def test_asset_id_reused_across_types_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 }, { 'id' => 2, 'duration' => 5 }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1] }],
                          'Hummingbird' => [{ 'id' => 1, 'actions' => [2] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'duplicate asset id: 1', error.message
  end

  def test_lidar_action_owned_by_an_asset_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 }],
                           'LidarAction' => [{ 'id' => 2, 'interval' => 5, 'concurrencies' => [1] }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1, 2] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'asset 1 cannot own action 2', error.message
  end

  def test_concurrency_with_a_non_hover_action_is_rejected
    plan = { 'Action' => { 'TraversePathSegmentAction' => [{ 'id' => 1, 'duration' => 5 }],
                           'LidarAction' => [{ 'id' => 2, 'interval' => 5, 'concurrencies' => [1] }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'action 1 takes no concurrencies', error.message
  end

  def test_precondition_on_a_lidar_action_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 },
                                             { 'id' => 3, 'duration' => 5, 'preconditions' => [2] }],
                           'LidarAction' => [{ 'id' => 2, 'interval' => 5, 'concurrencies' => [1] }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1, 3] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'action 2 cannot be a precondition', error.message
  end

  def test_action_owned_by_two_assets_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1] }],
                          'Hummingbird' => [{ 'id' => 2, 'actions' => [1] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'action 1 belongs to assets 1 and 2', error.message
  end

  def test_action_owned_by_no_asset_is_rejected
    plan = { 'Action' => { 'HoverAction' => [{ 'id' => 1, 'duration' => 5 }, { 'id' => 2, 'duration' => 5 }] },
             'Asset' => { 'ARDrone' => [{ 'id' => 1, 'actions' => [1] }] } }

    error = assert_raises(ArgumentError) { PlanLoader.new(plan) }
    assert_equal 'action 2 belongs to no asset', error.message
  end
end
