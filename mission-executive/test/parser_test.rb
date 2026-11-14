require 'minitest/autorun'
require 'tmpdir'

require_relative '../../parser/parser'

class ParserTest < Minitest::Test
  def test_yaml_tokens_exclude_comment_text
    plan = <<~YAML
      Action:
        HoverAction:
          - id: 1
            duration: 40 # point of failure
            preconditions: [2, 3]
    YAML

    assert_equal "plan.yaml,loc=5,tokens=19\n", count(:yaml, plan)
  end

  def test_pctl_tokens
    assert_equal "plan.pctl,loc=1,tokens=13\n", count(:pctl, "P=? [ F d1=0 & d2=0 ]\n")
  end

  def test_dtmc_tokens_exclude_comment_text
    model = <<~PRISM
      dtmc

      const int e1 = 120; // endurance

      module asset1
        d1 : [0..40] init 40;
        [asst1] d1>0 -> (d1'=d1-1);
      endmodule
    PRISM

    assert_equal "plan.pm,loc=8,tokens=36\n", count(:pm, model)
  end

  private

  # The line the parser prints for source saved as plan.<extension>.
  def count(extension, source)
    Dir.mktmpdir do |dir|
      File.write("#{dir}/plan.#{extension}", source)
      # count_tokens reads token tables held by the top-level object
      capture_io { TOPLEVEL_BINDING.receiver.send(:count_tokens, "#{dir}/plan.", extension) }.first
    end
  end
end
