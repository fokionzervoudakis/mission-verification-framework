require_relative 'subject'

class LidarAction
  include Subject

  def initialize(id, interval)
    super()
    @id = id
    @interval = interval
    @readings = 0
    @timestep = 0
  end

  def execute
    @readings += 1 if (@timestep % @interval).zero?
    @timestep += 1
  end
end
