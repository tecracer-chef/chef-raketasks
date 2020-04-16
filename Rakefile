# Rakefile for creating a gem file locally and for publishing this gem itself
require 'rake'
require 'rake/tasklib'
require 'bundler/gem_tasks'
require 'rubygems/package_task'

include Rake::DSL if defined? Rake::DSL

class Package < ::Rake::TaskLib
  desc 'Build the gem file'
  task :build do
    Dir.chdir(Rake.application.original_dir)

    CLEAN.include('pkg/*')

    filename = Dir.glob('*.gemspec')
    raise! 'No gemspec found, pack:gem aborted!' if filename.nil? || filename.empty?

    gemspec = Kernel.eval(File.read(filename.first))
    Gem::PackageTask.new(gemspec) do |t|
      t.name = gemspec.name
      t.version = gemspec.version
      t.package_dir = 'pkg'
      t.package_files = gemspec.files
    end
    Rake::Task['build'].invoke
  end

  desc 'Build and install'
  task :install do
    Rake::Task['install:local'].invoke
  end
end
