class Asset
  class << self; attr_accessor :endurance end

  def initialize(id)
    @id = id.to_s
    @endurance = self.class.endurance
    @actions = []
  end

  def add_action(action)
    @actions.push(action)
  end

  def execute
    @actions.each do |action|
      action.execute
      @actions.delete(action) if action.completed?
    end
    @endurance -= 1
  end

  def completed?
    @endurance.zero? || @actions.empty?
  end
end

class ARDrone < Asset; end

class Hummingbird < Asset; end
