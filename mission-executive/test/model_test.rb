require 'minitest/autorun'
require 'yaml'

# The hand-written constants of each model against the plan they stand for.
class ModelTest < Minitest::Test
  ENDURANCES = YAML.safe_load_file('operations/asset_data.yaml').transform_values { |asset| asset.fetch('endurance') }

  Dir['operations/operation_*.yaml'].each do |file|
    operation = File.basename(file, '.yaml')

    define_method("test_#{operation}_model_constants_match_the_plan") do
      model = File.read(Dir["../models/*/#{operation}.pm"].fetch(0))
      constants = model.scan(/^const int ((?:max_[de]|i)\d+) *= *(\d+);/).to_h { |name, value| [name, value.to_i] }

      assert_equal planned(YAML.safe_load_file(file)).sort, constants.sort
    end

    define_method("test_#{operation}_shared_step_is_named_after_a_primary_asset") do
      steps = File.read(Dir["../models/*/#{operation}.pm"].fetch(0)).scan(/\[asst(\d+)\]/).flatten.uniq.map(&:to_i)
      primary = primary_assets(YAML.safe_load_file("classifications/#{operation}.yaml"))

      if primary.empty?
        assert_empty steps
      else
        assert_equal 1, steps.size
        assert_includes primary, steps.first
      end
    end
  end

  private

  # The constants a plan calls for: a duration or interval for each action
  # and an endurance for each asset.
  def planned(plan)
    actions = plan.fetch('Action').values.flatten.to_h do |action|
      action.key?('interval') ? ["i#{action['id']}", action['interval']] : ["max_d#{action['id']}", action['duration']]
    end
    assets = plan.fetch('Asset').flat_map do |type, list|
      list.map { |asset| ["max_e#{asset['id']}", asset.fetch('endurance', ENDURANCES.fetch(type))] }
    end

    actions.merge(assets.to_h)
  end

  def primary_assets(classification)
    assets = classification.fetch('Asset', {}).values.flatten
    assets.filter_map { |asset| asset['id'] if asset['type'] == 'primary_asset' }
  end
end
