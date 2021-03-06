# frozen_string_literal: true

require_relative "lib/epaper/version"

Gem::Specification.new do |spec|
  spec.name = "epaper"
  spec.version = Epaper::VERSION
  spec.authors = ["HeroProtagonist"]

  spec.summary = ""
  spec.description = ""
  # spec.homepage = ""
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions = ["ext/epaper/extconf.rb"]

  spec.add_dependency "rmagick", "~> 4.2.4"
  spec.add_dependency "octokit", "~> 4.22.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
