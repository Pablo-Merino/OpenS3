Gem::Specification.new do |s|
  s.name    = 'OpenS3'
  s.version = '0.1'
  s.summary = 'A storage server'
  s.description = 'Build your own storage server'

  s.author   = 'Pablo Merino'
  s.email    = 'pablo.perso1995@gmail.cin'
  s.homepage = 'https://github.com/pablo-merino/opens3'

  # Include everything in the lib folder
  s.files = Dir['lib/**/*']
  s.add_dependency 'json'
  s.add_dependency  'rack'
  s.add_dependency  'trollop'

  # Supress the warning about no rubyforge project
  s.rubyforge_project = 'nowarning'
  s.executables   = `ls bin/*`.split("\n").map{ |f| File.basename(f) }

end