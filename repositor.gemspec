Gem::Specification.new do |s|
  s.name        = 'repositor'
  s.version     = '0.2.0'
  s.date        = '2016-03-24'
  s.summary     = "Implementation of RepoPattern"
  s.description = "Create simple Repos for easy controllers"
  s.authors     = ["Volodya Sveredyuk"]
  s.email       = 'sveredyuk@gmail.com'
  s.files       = ["lib/repositor.rb"]
  s.homepage    = 'https://github.com/sveredyuk/repositor'
  s.license     = 'MIT'

  # Dev gems
  s.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
end
