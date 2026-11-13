require 'minitest/autorun'
require 'open3'

class PlanTest < Minitest::Test
  def test_every_plan_matches_the_schema
    plans = Dir['operations/operation_*.yaml']
    output, status = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', *plans)
    assert_predicate status, :success?

    # kwalify exits 0 for a plan that breaks the schema
    assert_equal plans.map { |plan| "#{plan}#0: valid.\n" }, output.lines
  end
end
