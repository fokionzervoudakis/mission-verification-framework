require_relative 'subject'
require_relative 'observer'
require_relative 'filter'

class Action
  extend Filter if ARGV[0].eql?('filter')

  include Subject
  include Observer

  def initialize(id, duration)
    super()
    @id = id.to_s
    @duration = duration
  end

  def add_precondition(action)
    add_subject(action)
  end

  def execute
    execute_naively if @subjects.empty?
  end

  def completed?
    @duration.zero?
  end

  private

  def execute_naively
    @duration -= 1
    notify if completed?
  end
end

class KineticAction < Action; end

class HoverAction < KineticAction
  def initialize(id, duration)
    super id, duration
    @concurrencies = []
  end

  def add_concurrency(action)
    @concurrencies.push(action)
  end

  def execute
    return unless @subjects.empty?

    @concurrencies.each(&:execute)
    execute_naively
  end
end

class SensorAction < Action; end

class PhotoSurveillanceAction < SensorAction; end

class TraversePathSegmentAction < KineticAction; end
