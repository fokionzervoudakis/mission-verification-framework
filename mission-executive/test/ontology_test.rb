require 'minitest/autorun'
require 'yaml'

# The ontology values that the classifications and models repeat.
class OntologyTest < Minitest::Test
  TACTICAL = File.read('../ontology/complex_tactical_missions.owl')
  TRAFFIC = File.read('../ontology/complex_traffic_surveillance_missions.owl')

  # The ontology sets the vulnerability and risk threshold of each level; the
  # classification of a tactical asset and its model repeat one level.
  def test_vulnerabilities_match_the_ontology
    levels = %w[Low High].map do |level|
      [value(TACTICAL, "#{level}Vulnerability"), value(TACTICAL, "#{level}RiskAcceptabilityFactor")]
    end

    Dir['classifications/operation_*.yaml'].each do |file|
      operation = File.basename(file, '.yaml')
      model = File.read(Dir["../models/*/#{operation}.pm"].fetch(0))
      properties = File.read(Dir["../models/*/#{operation}.pctl"].fetch(0))

      vulnerable_assets(file).each do |asset|
        id = asset.fetch('id')

        assert_includes levels, [asset['vulnerability'], asset['raf']], operation
        assert_equal [asset['vulnerability']], numbers(model, /([\d.]+):\(a#{id}d'=true\)/).uniq, operation
        assert_equal [asset['raf']], numbers(properties, /raf#{id}>([\d.]+)/), operation
      end
    end
  end

  # The probability of each move between speeds (0 minimum, 1 nominal, 2
  # nominal exceeded), by the ontology property that sets it.
  MOVES = { 'approachesMinimumSpeed' => [1, 0], 'exceedsMinimumSpeed' => [0, 1],
            'exceedsNominalSpeed' => [1, 2] }.freeze

  # The ontology sets the interval calibration factor and speed probabilities
  # of each freeway section; the operation_5b model repeats them.
  def test_freeway_sections_match_the_ontology
    model = File.read('../models/operation_5/operation_5b.pm')
    sections = model.scan(%r{^module FreewaySection(\d+) // (low|high) speed freeway section$})

    assert_equal 2, sections.size
    sections.each do |section, speed|
      level = speed.capitalize
      lidar = model[/mod\(d\d+, ci(\d+)\)=0 .* spd#{section}=2 ->/, 1]
      factor = numbers(model, /^const int icf#{lidar} = (\d+);/)

      assert_equal [value(TRAFFIC, "#{level}IntervalCalibrationFactor")], factor
      MOVES.each_pair do |property, (from, to)|
        probability = numbers(model, /spd#{section}=#{from} ->.*? ([\d.]+):\(spd#{section}'=#{to}\)/)

        assert_equal [restriction(TRAFFIC, "#{level}SpeedFreewaySection", property)], probability, property
      end
    end
  end

  private

  def vulnerable_assets(classification)
    YAML.safe_load_file(classification).fetch('Asset', {}).values.flatten.select { |asset| asset.key?('vulnerability') }
  end

  def numbers(source, pattern)
    source.scan(pattern).flatten.map(&:to_f)
  end

  # The value an ontology asserts for a named individual.
  def value(ontology, individual)
    ontology[%r{##{individual}"/>\s*<Literal[^>]*>([\d.]+)}, 1].to_f
  end

  # The bound an ontology sets on a data property of a class.
  def restriction(ontology, klass, property)
    restriction = %r{<Class IRI="##{klass}"/>\s*<DataSomeValuesFrom>\s*<DataProperty IRI="##{property}"/>}
    ontology[/#{restriction}.*?<Literal[^>]*>([\d.]+)/m, 1].to_f
  end
end
