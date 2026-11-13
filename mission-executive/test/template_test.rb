require 'minitest/autorun'
require 'open3'

class TemplateTest < Minitest::Test
  # Operations whose assets carry a vulnerability, and so get survivability constructs.
  OPERATIONS = %w[operation_4b operation_4c operation_4d operation_4e operation_4f operation_A].freeze

  OPERATIONS.each do |operation|
    define_method("test_#{operation}_survivability_commands_match_the_model") do
      generated, status = Open3.capture2('./survivability_template.rb', operation)
      assert_predicate status, :success?

      model = commands(File.read(Dir["../models/*/#{operation}.pm"].fetch(0)))

      assert_empty commands(generated) - model
    end
  end

  private

  # The guarded commands in PRISM source, without comments, alignment or
  # parentheses around a lone variable.
  def commands(source)
    source.lines.map { |line| line.sub(%r{//.*}, '').gsub(/\((\w+)\)/, '\\1').squeeze(' ').strip }.grep(/\A\[/)
  end
end
