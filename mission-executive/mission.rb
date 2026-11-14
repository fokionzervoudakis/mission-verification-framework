#!/usr/bin/env ruby

require_relative 'util'
require_relative 'op_loader'

module Mission
  def self.execute(assets)
    until assets.empty?
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
