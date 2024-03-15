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

execute do |operation|
  puts "executing #{operation}..."
  Mission.execute(OpLoader.new(operation).assets)
end
