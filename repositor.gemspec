Gem::Specification.new do |s|
  s.name        = 'repositor'
  s.version     = '0.3.0'
  s.date        = '2016-03-24'
  s.summary     = "Implementation of Repository Pattern for Rails"
  s.description = "Create simple Repos for Rails Controllers"
  s.authors     = ["Volodya Sveredyuk"]
  s.email       = 'sveredyuk@gmail.com'
  s.files       = ["lib/repositor.rb"]
  s.homepage    = 'https://github.com/sveredyuk/repositor'
  s.license     = 'MIT'

  # Dev gems
  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
end
