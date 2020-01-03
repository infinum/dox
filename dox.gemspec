lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dox/version'

Gem::Specification.new do |spec|
  spec.name          = 'dox'
  spec.version       = Dox::VERSION
  spec.authors       = ['Melita Kokot', 'Vedran Hrnčić']
  spec.email         = ['melita.kokot@gmail.com', 'vrabac266@gmail.com']

  spec.summary       = 'Generates API documentation for rspec in api blueprint format.'
  spec.homepage      = 'https://github.com/infinum/dox'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_runtime_dependency 'rails', '>= 4.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_runtime_dependency 'rspec-core'
end
