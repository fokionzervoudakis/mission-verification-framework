require 'minitest/autorun'
require 'open3'

class TemplateTest < Minitest::Test
  # Operations whose assets carry a vulnerability, and so get survivability constructs.
  OPERATIONS = %w[operation_4b operation_4c operation_4d operation_4e operation_4f operation_A].freeze

  OPERATIONS.each do |operation|
    define_method("test_#{operation}_survivability_commands_match_the_model") do
      assert_commands_in_model './survivability_template.rb', operation
    end
  end

  Dir['operations/operation_*.yaml'].each do |file|
    operation = File.basename(file, '.yaml')

    define_method("test_#{operation}_asset_commands_match_the_model") do
      assert_commands_in_model './asset_template.rb', operation
    end
  end

  private

  def assert_commands_in_model(template, operation)
    generated, status = Open3.capture2(template, operation)
    assert_predicate status, :success?

    model = commands(expand(File.read(Dir["../models/*/#{operation}.pm"].fetch(0))))

    assert_empty commands(generated) - model
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
end
