def execute
  operation = ARGV[0].eql?('filter') ? ARGV[1] : ARGV[0]
  path = 'operations/operation_*'
  if operation.nil?
    Dir[path].each do |file|
      yield File.basename(file, '.yaml')
    end
  else
    operation = File.basename(operation, '.yaml')
    abort "unknown operation: #{operation}" unless Dir[path].include?("operations/#{operation}.yaml")
    yield operation
  end
end
