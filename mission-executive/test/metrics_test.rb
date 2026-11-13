require 'minitest/autorun'
require 'tempfile'

class MetricsTest < Minitest::Test
  def test_mission_metrics_csv_is_up_to_date
    Tempfile.create('mission-metrics') do |file|
      assert system('../parser/metrics.rb', file.path)

      assert_equal File.read('../data/mission-metrics.csv'), file.read
    end
  end
end
