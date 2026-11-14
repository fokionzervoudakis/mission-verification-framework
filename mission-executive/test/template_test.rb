require 'minitest/autorun'
require 'open3'

class TemplateTest < Minitest::Test
  # Operations whose assets carry a vulnerability, and so get survivability constructs.
  OPERATIONS = %w[operation_4b operation_4c operation_4d operation_4e operation_4f operation_A].freeze

  OPERATIONS.each do |operation|
    define_method("test_#{operation}_survivability_commands_match_the_model") do
      assert_commands_in_model './survivability_template.rb', operation
    end

    define_method("test_#{operation}_survivability_property_matches_the_model") do
      assert_properties_in_model './survivability_template.rb', operation
    end
  end

  # Model conjuncts no template generates: the series 3 sensor actions and
  # the lidar properties of operation_5b.
  UNGENERATED = {
    %w[3a 3b 3c 3d] => ['d2=0'],
    %w[3e 3f 3g 3h 3i 3j] => ['d3=0'],
    %w[3k 3l 3m 3n 3o 3p 3q 3r] => ['d4=0'],
    %w[5b] => ['nse4', 'spd1=0', '!mod(d1, ci4)=0', 'nse5', 'spd2=0', '!mod(d3, ci5)=0']
  }.flat_map { |ids, conjuncts| ids.map { |id| ["operation_#{id}", conjuncts] } }.to_h.freeze

  Dir['operations/operation_*.yaml'].each do |file|
    operation = File.basename(file, '.yaml')

    define_method("test_#{operation}_model_property_is_generated") do
      templates = ['./property_template.rb', *('./survivability_template.rb' if OPERATIONS.include?(operation))]
      generated = templates.flat_map { |template| conjuncts(generate(template, operation)) }

      assert_equal UNGENERATED.fetch(operation, []), model_conjuncts(operation) - generated
    end

    define_method("test_#{operation}_asset_commands_match_the_model") do
      assert_commands_in_model './asset_template.rb', operation
    end

    define_method("test_#{operation}_property_matches_the_model") do
      assert_properties_in_model './property_template.rb', operation
    end
  end

  private

  def assert_commands_in_model(template, operation)
    model = commands(expand(File.read(Dir["../models/*/#{operation}.pm"].fetch(0))))

    assert_empty commands(generate(template, operation)) - model
  end

  def assert_properties_in_model(template, operation)
    generated = conjuncts(generate(template, operation))
    refute_empty generated

    assert_empty generated - model_conjuncts(operation)
  end

  def model_conjuncts(operation)
    conjuncts(File.read(Dir["../models/*/#{operation}.pctl"].fetch(0)))
  end

  def generate(template, operation)
    generated, status = Open3.capture2(template, operation)
    assert_predicate status, :success?

    generated
  end

  # PRISM source with each renamed module ("module B = A[x=y] endmodule")
  # written out; A may itself be a renamed module declared earlier.
  def expand(source)
    renamed = /^module (?<name>\w+) = (?<base>\w+)\[(?<renames>.*?)\] endmodule/

    while (match = source.match(renamed))
      renames = match[:renames].split(',').to_h { |rename| rename.strip.split('=') }
      body = source[/^module #{match[:base]}$(.*?^endmodule)/m, 1]
      source = source.sub(renamed) { "module #{match[:name]}#{body.gsub(/\w+/) { |word| renames.fetch(word, word) }}" }
    end

    source
  end

  # The guarded commands in PRISM source, without comments, alignment or
  # parentheses around a lone variable.
  def commands(source)
    source.lines.map { |line| line.sub(%r{//.*}, '').gsub(/\((\w+)\)/, '\\1').squeeze(' ').strip }.grep(/\A\[/)
  end

  # The conjuncts of the "P=? [ F a & b ]" properties in PRISM source.
  def conjuncts(source)
    source.scan(/^P=\? \[ F (.*) \]$/).flatten.flat_map { |property| property.split(' & ') }
  end
end
