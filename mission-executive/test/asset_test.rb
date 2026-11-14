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
