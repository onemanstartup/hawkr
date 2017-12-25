lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hawkr/version'

Gem::Specification.new do |spec|
  spec.name          = 'hawkr'
  spec.version       = Hawkr::VERSION
  spec.authors       = ['Kato Nakamura']
  spec.email         = ['doesnt@matter.com']

  spec.summary       = 'Hawks for crypto exchanges'
  spec.description   = 'Finds ands saves current prices of cryptocuttencies'
  spec.homepage      = nil

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rom', '~> 4.1.1'
  spec.add_dependency 'rom-sql', '~> 2.3.0'
  spec.add_dependency 'pg'
  spec.add_dependency 'roda'
  spec.add_dependency 'puma'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'representable'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'faraday'
  spec.add_dependency 'websocket-eventmachine-client'
  spec.add_dependency 'sentry-raven'
  spec.add_dependency 'wamp_client'

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'mutant-rspec', '~> 0.8.14'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop-rspec'
end
