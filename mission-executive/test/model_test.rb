require 'minitest/autorun'
require 'yaml'
require_relative 'prism_source'

# The hand-written constants of each model against the plan they stand for.
class ModelTest < Minitest::Test
  include PrismSource

  ENDURANCES = YAML.safe_load_file('operations/asset_data.yaml').transform_values { |asset| asset.fetch('endurance') }

  # Preconditions a model enforces without a guard: the shared step cannot
  # fire until the leading action is over.
  UNGUARDED = %w[operation_2g operation_2h operation_2i].to_h { |operation| [operation, { 4 => [1] }] }.freeze

  Dir['operations/operation_*.yaml'].each do |file|
    operation = File.basename(file, '.yaml')

    define_method("test_#{operation}_action_guards_match_the_plan") do
      plan = YAML.safe_load_file(file)
      model = expand(File.read(Dir["../models/*/#{operation}.pm"].fetch(0)))

      plan.fetch('Action').values.flatten.select { |action| action.key?('duration') }.each do |action|
        guards = guards(model, action['id'])

        refute_empty guards
        guards.each { |guard| assert_equal planned_guard(plan, action, UNGUARDED.fetch(operation, {})), guard }
      end
    end

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

  def test_points_of_failure_are_on_the_same_actions
    Dir['operations/operation_*.yaml'].each do |file|
      operation = File.basename(file, '.yaml')
      model = File.read(Dir["../models/*/#{operation}.pm"].fetch(0))
      marked = model.scan(/^const int max_d(\d+)\b.*point of failure/).flatten.map(&:to_i)

      assert_equal failure_points(File.read(file)), marked, operation
    end
  end

  # just verify writes one row per property; a property changed since the last
  # run shows up here. A changed model does not.
  def test_prism_results_cover_the_properties_of_every_model
    properties = Dir['../models/*/*.pctl'].flat_map do |pctl|
      File.readlines(pctl, chomp: true).map { |property| [File.basename(pctl, '.pctl'), property] }
    end
    rows = File.read('../data/model-results.csv').scan(/^(\w+),"(.*?)",/)

    assert_empty (properties - rows) + (rows - properties)
  end

  private

  # The guard, as sorted conjuncts, of each command that counts an action down.
  def guards(model, id)
    model.scan(/^ *\[\w*\] *(.*?) *-> *\(d#{id}'=d#{id}-1\)/).flatten.map { |guard| guard.split(/ *& */).sort }
  end

  # The guard a plan calls for: the action's preconditions are over, the
  # action is not, and its owner has endurance left.
  def planned_guard(plan, action, unguarded)
    id = action['id']
    owner = plan.fetch('Asset').values.flatten.find { |asset| asset.fetch('actions', []).include?(id) }
    preconditions = action.fetch('preconditions', []) - unguarded.fetch(id, [])

    [*preconditions.map { |precondition| "d#{precondition}=0" }, "d#{id}>0", "e#{owner.fetch('id')}>0"].sort
  end

  # The ids of the actions a plan marks as a point of failure. The mark is a
  # YAML comment, so the plan is read as text.
  def failure_points(plan)
    id = nil
    plan.each_line.filter_map do |line|
      id = line[/- id: (\d+)/, 1]&.to_i || id
      id if line.include?('point of failure')
    end
  end

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
