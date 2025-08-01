# frozen_string_literal: true

require_relative "lib/neucore/version"

Gem::Specification.new do |spec|
  spec.name = "neucore"
  spec.version = Neucore::VERSION
  spec.authors = ["Chen Zeyu"]
  spec.email = ["zeyufly@gmail.com"]

  spec.summary = "Core utils of Neutron, including auth & admin users"
  spec.description = "Core utils of Neutron, including auth & admin users"
  spec.homepage = "https://neutron.sg"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://github.com"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = ""
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt"
  spec.add_dependency "cancancan"
  spec.add_dependency "paranoia"
  spec.add_dependency "paper_trail"
  spec.add_dependency "faraday"
  spec.add_dependency "devise"
  spec.add_dependency "aws-sdk-cognitoidentityprovider"
  spec.add_dependency "faraday-multipart"
  spec.add_dependency "ransack", "~> 4.2"
  # spec.add_dependency "mobility"
  # spec.add_dependency "mobility-ransack"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
