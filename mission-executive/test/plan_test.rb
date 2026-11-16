require 'minitest/autorun'
require 'open3'
require 'tempfile'
require 'yaml'

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

  # A plan may give an asset its own endurance, up to the limit of its type.
  # An asset with no endurance never runs out of it.
  { 'endurance: 100' => /#0: valid\.\n/,
    'endurance: 121' => /#0: INVALID\n.*too large/,
    'endurance: 0' => /#0: INVALID\n.*too small/ }.each_pair do |endurance, result|
    define_method("test_asset_#{endurance.delete(':').tr(' ', '_')}_is_checked_by_the_schema") do
      Tempfile.create(%w[plan .yaml]) do |file|
        plan = File.read('operations/operation_5a.yaml')
        file.write(plan.sub("    - id: 1\n      actions:", "    - id: 1\n      #{endurance}\n      actions:"))
        file.flush
        output, = Open3.capture2('bundle', 'exec', 'kwalify', '-lf', 'operations/schema.yaml', file.path)

        assert_match(result, output)
      end
    end
  end

  # The ontology sets the endurance limit of each asset type; the defaults
  # and the schema repeat it.
  def test_endurance_limits_match_the_ontology
    ontology = File.read('../ontology/complex_missions.owl')
    schema = YAML.safe_load_file('operations/schema.yaml').dig('mapping', 'Asset', 'mapping')

    YAML.safe_load_file('operations/asset_data.yaml').each_pair do |type, asset|
      restriction = %r{<Class IRI="##{type}"/>\s*<DataSomeValuesFrom>\s*<DataProperty IRI="#hasEnduranceInSeconds"/>}
      limit = ontology[/#{restriction}.*?<Literal[^>]*>(\d+)/m, 1]

      assert_equal limit.to_i, asset.fetch('endurance')
      assert_equal limit.to_i, schema.dig(type, 'sequence', 0, 'mapping', 'endurance', 'range', 'max')
    end
  end
end
