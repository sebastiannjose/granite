Gem::Specification.new do |s|
  s.name        = 'granite'
  s.version     = '0.7.0'
  s.homepage    = 'https://github.com/toptal/granite'
  s.authors     = ['Arkadiy Zabazhanov & friends']
  s.summary     = 'Another business actions architecture for Rails apps'
  s.files       = `git ls-files`.split("\n").grep(/\A(app|lib|LICENSE)/)
  s.license     = 'MIT'

  s.add_runtime_dependency 'actionpack', '~> 5.1'
  s.add_runtime_dependency 'active_data', '~> 1.1.0'
  s.add_runtime_dependency 'activesupport', '~>5.1'
  s.add_runtime_dependency 'memoist', '~> 0.16'

  s.add_development_dependency 'activerecord', '~> 5.0'
  s.add_development_dependency 'capybara', '~> 2.18'
  s.add_development_dependency 'fuubar', '~> 2.0'
  s.add_development_dependency 'pg', '< 1'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1.1'
  s.add_development_dependency 'rspec-its', '~> 1.2 '
  s.add_development_dependency 'rspec-rails', '~> 3.6'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.2'
  s.add_development_dependency 'rubocop', '~> 0.52'
  s.add_development_dependency 'rubocop-rspec', '~> 1.22'
  s.add_development_dependency 'simplecov', '~> 0.15'
end
