#!/usr/bin/env ruby

require_relative 'template_util'
require_relative 'util'

class Action; attr_accessor :asset end

class Asset
  alias original_add add_action

  def add_action(action)
    original_add(action)
    action.asset = self
  end

  def last
    @kinetic_actions.each { |action| return action if action.terminal? }
  end
end

class KineticAction < Action
  attr_reader :observers

  def terminal?
    @type.include?(:singleton) || @type.include?(:terminal)
  end
end

module AssetTemplate
  @primary_asset = lambda do |action|
    @asset ||=
      if action.asset.type == :primary_asset
        @asset = action.asset
      else
        action.asset.kinetic_actions.each do |kinetic_action|
          kinetic_action.observers.each do |observer|
            return @primary_asset[observer] if observer.is_kinetic_action?
          end
        end
      end
  end

  def self.generate(asset)
    commands = String.new

    asset.kinetic_actions.each do |kinetic_action|
      action = "[#{action_name kinetic_action}]"
      guard = "e#{asset.id}>0 & d#{kinetic_action.id}>0"
      update = "(e#{asset.id}'=e#{asset.id}-1)"
      commands += "#{action} #{guard} -> #{update};"
      commands += "\n#{"\s" * 2}" unless kinetic_action == asset.kinetic_actions.last
    end

    puts %(
module #{asset.class}#{asset.id}
  e#{asset.id} : [0..#{asset.class.endurance}] init #{asset.class.endurance};
  #{commands}
  [#{last_action_name asset.last}] e#{asset.id}=0 | d#{asset.last.id}=0 -> true;
endmodule
)
  end

  def self.action_name(action)
    case action.type
    when :default,
           :default_singleton,
           :default_terminal,
           :leading_subject,
           :default_observer,
           :terminal_observer
      "actn#{action.id}"
    when :terminal_constrained_observer
      "asst#{action.asset.id}"
    else
      "asst#{@primary_asset[action].id}"
    end
  end

  def self.last_action_name(action)
    case action.type
    when :terminal_constrained_observer
      "asst#{action.asset.id}"
    when :singleton_subject,
           :terminal_subject,
           :observer_and_singleton_subject,
           :observer_and_terminal_subject,
           :terminal_subject_constraint
      "asst#{@primary_asset[action].id}"
    end
  end
end

execute do |operation|
  puts('=' * 50)
  puts "asset modules for #{operation}..."
  puts('-' * 50)
  ClassLoader.new(operation).assets.each { |asset| AssetTemplate.generate asset }
end
