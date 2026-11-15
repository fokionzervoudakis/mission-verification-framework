#!/usr/bin/env ruby

require_relative 'util'
require_relative 'op_loader'

module Mission
  def self.execute(assets)
    # An asset that has not started can only be waiting on one that has.
    until assets.none? { |asset| asset.started? }
      assets.each do |asset|
        asset.execute
      end

      # Every asset must work before any asset finishes the tick, so this
      # loop cannot be merged with the one above.
      assets.each do |asset| # rubocop:disable Style/CombinableLoops
        asset.finish_tick
      end

      assets.delete_if do |asset|
        asset.completed?
      end

      # The kinetic actions of an asset run without a break, so a mission
      # fails as soon as an asset in flight has to wait for another asset.
      break if assets.any? { |asset| asset.stalled? }
    end
  end
end

if $PROGRAM_NAME == __FILE__
  execute do |operation|
    puts "executing #{operation}..."
    loader = OpLoader.new(operation)
    Mission.execute(loader.assets)
    unfinished = loader.unfinished
    puts unfinished.empty? ? '  all actions completed' : "  unfinished actions: #{unfinished.join(', ')}"
  end
end
