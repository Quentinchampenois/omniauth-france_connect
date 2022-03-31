# frozen_string_literal: true

require_relative "lib/omniauth/france_connect/version"

Gem::Specification.new do |spec|
  spec.name = "omniauth-france_connect"
  spec.version = Omniauth::FranceConnect::VERSION
  spec.authors = ["quentinchampenois"]
  spec.email = ["26109239+Quentinchampenois@users.noreply.github.com"]

  spec.summary = "Omniauth strategy for France Connect"
  spec.description = "Connect France Connect SSO using a omniauth strategy"
  spec.homepage = "https://github.com/OpenSourcePolitics/omniauth-france_connect"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/OpenSourcePolitics/omniauth-france_connect"
  spec.metadata["changelog_uri"] = "https://github.com/OpenSourcePolitics/omniauth-france_connect/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth_openid_connect", "~> 0.4.0"
  spec.add_development_dependency "bundler", "~> 2.3.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "1.23"
  spec.add_development_dependency "rubocop-rspec"
end
