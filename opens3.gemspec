require File.expand_path('../lib/opens3/version', __FILE__)
path = File.expand_path('../', __FILE__)

Gem::Specification.new do |s|
  s.name    = 'OpenS3'
  s.version = OpenS3::Version
  s.summary = 'A storage server'
  s.description = 'Build your own storage server'

  s.author   = 'Pablo Merino'
  s.email    = 'pablo.perso1995@gmail.cin'
  s.homepage = 'https://github.com/pablo-merino/opens3'

  s.files    = `cd #{path}; git ls-files`.split("\n").sort
  s.add_dependency 'json'
  s.add_dependency  'rack'
  s.add_dependency  'trollop'

  # Supress the warning about no rubyforge project
  s.rubyforge_project = 'nowarning'
  s.executables   = `ls bin/*`.split("\n").map{ |f| File.basename(f) }

end
