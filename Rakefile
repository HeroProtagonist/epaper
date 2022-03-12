# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative "waveshare_fetcher"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

require "rake/extensiontask"

task build: :compile

GEMSPEC = Gem::Specification.load("epaper.gemspec")

Gem::PackageTask.new(GEMSPEC) do |pkg|
end

Rake::ExtensionTask.new("epaper", GEMSPEC) do |ext|
  ext.lib_dir = "lib/epaper"
end

task default: %i[clobber compile]

task :fetch_waveshare_files do
  WaveshareFetcher.new.call
end

task :clear_waveshare_files do
  WaveshareFetcher.new.clean
end
