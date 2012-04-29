require File.expand_path('../lib/opens3/version', __FILE__)
path = File.expand_path('../', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'OpenS3'
  s.version     = OpenS3::Version
  s.summary     = 'A storage server'
  s.description = s.summary

  s.authors  = ['Pablo Merino', 'Squeeks']
  s.email    = ['pablo.perso1995@gmail.com', 'privacymyass@gmail.com']
  s.homepage = 'https://github.com/pablo-merino/opens3'

  s.has_rdoc    = 'yard'
  s.files       = `cd #{path}; git ls-files`.split("\n").sort
  s.executables = `ls bin/*`.split("\n").map{ |f| File.basename(f) }
  
  s.add_dependency 'json'
  s.add_dependency 'yaml'
  s.add_dependency 'digest'
  s.add_dependency 'rack'
  s.add_dependency 'trollop'

  s.add_development_dependency('rake' , ['~> 0.9.2'])
  s.add_development_dependency('yard' , ['~> 0.7.2'])

  s.rubyforge_project = 'nowarning'

end
