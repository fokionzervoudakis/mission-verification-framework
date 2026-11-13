def execute
  operation = ARGV[0].eql?('filter') ? ARGV[1] : ARGV[0]
  if operation.nil?
    path = 'operations/operation_*'
    Dir[path].each do |file|
      yield File.basename(file, '.yaml')
    end
  else
    operation = File.basename(operation, '.yaml')
    abort "unknown operation: #{operation}" unless File.exist?("operations/#{operation}.yaml")
    yield operation
  end
end
