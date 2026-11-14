#!/usr/bin/env ruby

# Runs PRISM on every model and writes the results to data/model-results.csv.

require 'open3'

ROOT = File.expand_path('..', __dir__)

# The property with only its "action finished" conditions, which leaves out
# whether an asset in a threat area survives and senses enough.
def finish(property)
  conditions = property[/F (.*) \]/, 1].split(' & ').grep(/\Ad\d+=0\z/)
  "P=? [ F #{conditions.join(' & ')} ]" unless conditions.empty?
end

rows = ['operation,property,mission succeeds,actions complete,deadlock']
Dir["#{ROOT}/models/*/*.pm"].sort_by { |model| File.basename(model) }.each do |model|
  properties = File.readlines(model.sub(/\.pm$/, '.pctl'), chomp: true)
  questions = (properties + properties.filter_map { |property| finish(property) }).uniq
  log, = Open3.capture2e(ENV.fetch('PRISM', 'prism'), model, '-pf', questions.join('; '))
  results = questions.zip(log.scan(/^Result: (\S+)/).flatten).to_h
  abort "#{model}: #{log[/^Error.*/]}" if results.value?(nil)

  deadlock = log.include?('Deadlocks detected') ? 'yes' : 'no'
  properties.each do |property|
    rows.push([File.basename(model, '.pm'), %("#{property}"), results[property], results[finish(property)],
               deadlock].join(','))
  end
end

File.write("#{ROOT}/data/model-results.csv", "#{rows.join("\n")}\n")
