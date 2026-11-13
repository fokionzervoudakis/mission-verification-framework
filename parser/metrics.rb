#!/usr/bin/env ruby

PATH = File.dirname(__FILE__)
RATIOS = [%i[pm_loc yaml_loc], %i[pm_tokens yaml_tokens], %i[prism_loc yaml_loc], %i[prism_tokens yaml_tokens]].freeze

def percent(value)
  format('%.1f%%', value.round(1))
end

def ratios(counts)
  RATIOS.map { |numerator, denominator| 100.0 * counts[numerator] / counts[denominator] }
end

def summary(label, rows)
  columns = rows.map { |counts| ratios(counts) }.transpose
  means = columns.map { |column| column.sum / column.size }
  deviations = columns.zip(means).map do |column, mean|
    Math.sqrt(column.sum { |value| (value - mean)**2 } / (column.size - 1))
  end
  [",,,,,,,#{label},mean ratio,#{means.map { |mean| percent(mean) }.join(',')}",
   ",,,,,,,,standard deviation,#{deviations.map { |deviation| percent(deviation) }.join(',')}"]
end

operations = Hash.new { |hash, operation| hash[operation] = {} }
`#{PATH}/parser.rb`.scan(/^(.+)\.(\w+),loc=(\d+),tokens=(\d+)$/) do |operation, extension, loc, tokens|
  operations[operation][:"#{extension}_loc"] = loc.to_i
  operations[operation][:"#{extension}_tokens"] = tokens.to_i
end
operations.each_value do |counts|
  counts[:prism_loc] = counts[:pm_loc] + counts[:pctl_loc]
  counts[:prism_tokens] = counts[:pm_tokens] + counts[:pctl_tokens]
end

lines = [',YAML,,DTMC,,PCTL,,PRISM,,DTMC-to-YAML ratio,,PRISM-to-YAML ratio,',
         'operation,LOC,tokens,LOC,tokens,LOC,tokens,LOC,tokens,LOC,tokens,LOC,tokens']
operations.each_pair do |operation, counts|
  sizes = %i[yaml pm pctl prism].flat_map { |type| [counts[:"#{type}_loc"], counts[:"#{type}_tokens"]] }
  lines.push([operation, *sizes, *ratios(counts).map { |ratio| percent(ratio) }].join(','))
end
spacer = ',' * 12
lines.push(spacer, *summary('all ops', operations.values))
# Tactical plans are the ones whose classification gives an asset a vulnerability.
tactical = operations.select do |operation, _counts|
  File.read("#{PATH}/../mission-executive/classifications/#{operation}.yaml").include?('vulnerability:')
end
lines.push(spacer, *summary('tactical ops', tactical.values))

File.write(ARGV.fetch(0, "#{PATH}/../data/mission-metrics.csv"), lines.join("\n"))
