class Asset
  class << self; attr_accessor :endurance end

  attr_reader :endurance

  # A plan may give an asset its own endurance; otherwise its type decides.
  def initialize(id, endurance = nil)
    @id = id.to_s
    @endurance = endurance || self.class.endurance
    @actions = []
  end

  def add_action(action)
    @actions.push(action)
  end

  def execute
    # A sensor action only works while a kinetic action of its asset runs.
    flying = @actions.any? do |action|
      action.is_a?(KineticAction) && action.ready?
    end

    @actions.each do |action|
      action.execute if flying || !action.is_a?(SensorAction)
    end
    @endurance -= 1 if started?
  end

  # An asset uses no endurance until one of its actions can run. A sensor
  # action cannot run on its own, so it does not start its asset.
  def started?
    @started ||= @actions.any? do |action|
      !action.is_a?(SensorAction) && action.ready?
    end
  end

  # An asset that has started cannot wait: one of its actions must be able to run.
  def stalled?
    started? && @actions.none? do |action|
      action.ready?
    end
  end

  def finish_tick
    @actions.each do |action|
      action.notify if action.completed?
    end

    @actions.delete_if do |action|
      action.completed?
    end
  end

  def completed?
    @endurance.zero? || @actions.empty?
  end
end

class ARDrone < Asset; end

class Hummingbird < Asset; end
