#!/usr/bin/env ruby

require_relative 'template_util'
require_relative 'util'

class Asset; attr_accessor :raf, :vulnerability end
class KineticAction < Action; attr_accessor :incursion end

class SensorAction < Action
  attr_reader :id

  defensive_copy :siblings

  def siblings=(siblings)
    @siblings = siblings.collect(&:to_s)
  end
end

class ThreatLoader < ClassLoader
  def initialize(operation)
    super(operation)
    load(:actions, :incursion, :siblings)
    load(:assets, :raf, :vulnerability)
  end
end

module SurvivabilityTemplate
  @command = lambda do |params, action|
    newline = "\n#{"\s" * 2}"
    temp = "#{params[:action]} #{params[:guard1]} -> #{params[:update]};#{newline}"
    temp += "#{params[:action]} #{params[:guard2]} -> true;"
    temp += newline unless action == @asset.kinetic_actions.last
    temp
  end

  def self.generate(asset)
    return if asset.vulnerability.nil?

    @asset = asset
    generate_formulas
    generate_kinetic_action_modules(&@command)
    generate_sensor_action_modules(&@command) unless asset.sensor_actions.empty?
    generate_properties
  end

  def self.generate_formulas
    durations = String.new

    @asset.kinetic_actions.each do |action|
      next if action.incursion.nil?

      action.incursion.each_pair { |key, value| puts "const int #{key}#{action.id} = #{value};\n" }
      start = "start#{action.id}"
      finish = "finish#{action.id}"
      duration = "duration#{action.id}"

      puts %(
         formula actn#{action.id}_tai = d#{action.id}>#{finish} & d#{action.id}<=#{start};
         formula #{duration} = #{start} - #{finish};
         )

      durations += durations.empty? ? duration : " + #{duration}"
    end

    sad = @asset.sensor_actions.empty? ? 0 : "sad#{@asset.id}"

    puts %(
formula tkad#{@asset.id} = #{durations};
formula raf#{@asset.id} = #{sad} / tkad#{@asset.id};
)
  end

  def self.generate_kinetic_action_modules
    commands = String.new

    @asset.kinetic_actions.each do |action|
      next if action.incursion.nil?

      params = {
        action: "[actn#{action.id}]",
        guard1: "!a#{@asset.id}d & actn#{action.id}_tai",
        guard2: " a#{@asset.id}d | !actn#{action.id}_tai",
        update: "#{1 - @asset.vulnerability}:(a#{@asset.id}d'=false) + " \
                "#{@asset.vulnerability}:(a#{@asset.id}d'=true)"
      }

      commands += yield(params, action)
    end

    puts %(
module #{@asset.class}#{@asset.id}_Survivability
  a#{@asset.id}d : bool init false;
  #{commands}
endmodule
)
  end

  def self.generate_sensor_action_modules
    commands = String.new

    @asset.kinetic_actions.each do |action|
      siblings = String.new

      @asset.sensor_actions.each do |sensor_action|
        if sensor_action.siblings.include?(action.id)
          siblings += (siblings.empty? ? 'r' : ' | r') + sensor_action.id
        end
      end

      next if siblings.empty?

      params = {
        action: "[actn#{action.id}]",
        guard1: " actn#{action.id}_tai & (#{siblings}) & sad#{@asset.id}<tkad#{@asset.id}",
        guard2: "!actn#{action.id}_tai | !(#{siblings})",
        update: "(sad#{@asset.id}'=sad#{@asset.id}+1)"
      }

      commands += yield(params, action)
    end

    puts %(
module SensorActionCounter#{@asset.id}
  sad#{@asset.id} : [0..tkad#{@asset.id}] init 0;
  #{commands}
endmodule
)
  end

  def self.generate_properties
    puts "P=? [ F !a#{@asset.id}d & raf#{@asset.id}>#{@asset.raf} ]"
  end
end

execute do |operation|
  puts('=' * 50)
  puts "survivability constructs for #{operation}..."
  puts('-' * 50)
  ThreatLoader.new(operation).assets.each { |asset| SurvivabilityTemplate.generate(asset) }
end
