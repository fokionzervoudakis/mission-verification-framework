require 'minitest/autorun'
require 'open3'
require 'tempfile'

class PlanTest < Minitest::Test
  def test_every_plan_matches_the_schema
    plans = Dir['operations/operation_*.yaml']
    output, status = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', *plans)
    assert_predicate status, :success?

    # kwalify exits 0 for a plan that breaks the schema
    assert_equal plans.map { |plan| "#{plan}#0: valid.\n" }, output.lines
  end

  # An action with no duration never completes; a zero interval divides by zero.
  { 'duration: 30' => 'duration: 0', 'interval: 5' => 'interval: 0' }.each_pair do |valid, invalid|
    define_method("test_#{invalid.delete(':').tr(' ', '_')}_breaks_the_schema") do
      Tempfile.create(%w[plan .yaml]) do |file|
        file.write(File.read('operations/operation_5a.yaml').sub(valid, invalid))
        file.flush
        output, = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', file.path)

        assert_match(/#0: INVALID\n.*too small/, output)
      end
    end
  end
end
