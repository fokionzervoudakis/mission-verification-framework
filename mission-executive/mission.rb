#!/usr/bin/env ruby

require_relative 'util'
require_relative 'op_loader'

module Mission
  def self.execute(assets)
    until assets.empty?
      assets.each do |asset|
        asset.execute
        assets.delete(asset) if asset.completed?
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
