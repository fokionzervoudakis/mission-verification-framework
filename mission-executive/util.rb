def execute
  argv0 = ARGV[0]
  argv1 = ARGV[1]
  if argv0.nil? && argv1.nil?
    path = 'operations/operation_*'
    Dir[path].each do |file|
      yield File.basename(file, '.yaml')
    end
  else
    filename = argv0.eql?('filter') ? argv1 : argv0
    path = "operations/#{filename}"
    yield File.basename(path, '.yaml')
  end
end
