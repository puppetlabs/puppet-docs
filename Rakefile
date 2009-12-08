require 'rubygems'
require 'rake'

dependencies = %w(maruku nokogiri erubis)

namespace :install do
  dependencies.each do |dep|
    desc "Install '#{dep}' dependency"
    task dep do
      sh "gem install #{dep} --no-rdoc --no-ri"
    end
  end
end

desc "Install dependencies"
task :install => dependencies.map { |d| "install:#{d}" }

desc "Generate the documentation"
task :generate do
  sh "bin/generate"
end

desc "Serve generated output on port 9292 (requires 'rack')"
task :serve do
  sh "rackup"
end

desc "Generate docs and serve locally"
task :run => [:generate, :serve]


require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "puppet-docs"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
