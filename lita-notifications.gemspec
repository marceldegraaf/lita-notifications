Gem::Specification.new do |spec|
  spec.name          = "lita-notifications"
  spec.version       = "1.0.1"
  spec.authors       = ["Marcel de Graaf"]
  spec.email         = ["mail@marceldegraaf.net"]
  spec.description   = %q{Forward notifications from various third parties to Lita}
  spec.summary       = %q{Forward notifications to Lita}
  spec.homepage      = "https://github.com/marceldegraaf/lita-notifications"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 2.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.14"
end
