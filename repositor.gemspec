Gem::Specification.new do |s|
  s.name        = 'repositor'
  s.version     = '0.4.0'
  s.date        = '2016-03-24'
  s.summary     = "Implementation of Repository Pattern for Rails"
  s.description = "Create simple Repos for Rails Controllers"
  s.authors     = ["Volodya Sveredyuk"]
  s.email       = 'sveredyuk@gmail.com'
  s.homepage    = 'https://github.com/sveredyuk/repositor'
  s.license     = 'MIT'

  s.files = Dir["{lib}/**/*", "README.md"]

  # Dev gems
  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  s.add_development_dependency 'pry', '~> 0.10.3'

  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.6'
end
