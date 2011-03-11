require 'rubygems'
require 'rake'
require 'pathname'
require 'fileutils'

Dir.glob(File.join("vendor", "gems", "*", "lib")).each do |lib|
  $LOAD_PATH.unshift(File.expand_path(lib))
end

begin
  require "vlad"
  Vlad.load(:app => nil, :scm => "git")
rescue LoadError
  # do nothing
end

$LOAD_PATH.unshift File.expand_path('lib')

dependencies = %w(jekyll maruku rack versionomy kramdown)
references = %w(configuration function indirection metaparameter network report type)

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
  Dir.chdir("source")
  system("../vendor/gems/jekyll-0.7.0/bin/jekyll --kramdown ../output")
  Rake::Task['references:symlink'].invoke
  Dir.chdir("..")
end

desc "Serve generated output on port 9292"
task :serve do
  system("rackup")
end

desc "Generate docs and serve locally"
task :run => [:generate, :serve]

desc "Build documentation for a new Puppet version"
task :build => [ 'references:check_version', 'references:fetch_tags', 'references:stub', 'references:puppetdoc', 'references:update_manpages']

desc "Create tarball of documentation"
task :tarball do
  FileUtils.cd 'output'
  FileUtils.ln_sf 'files', 'guides/files'
  FileUtils.ln_sf 'files', 'guides/types/files'
  FileUtils.ln_sf 'files', 'guides/types/nagios/files'
  FileUtils.ln_sf 'files', 'guides/types/selinux/files'
  FileUtils.ln_sf 'files', 'guides/types/ssh/files'
  FileUtils.ln_sf 'files', 'references/files'
  sh "tar --ignore-failed-read -czf puppetdocs-latest.tar.gz *"
  FileUtils.mv 'puppetdocs-latest.tar.gz', '..'
  FileUtils.cd '..'
end

desc "Update the contents of source/man/{app}.markdown" # Note that the index must be built manually if new applications are added. Also, let's not ever have a `puppet index` command.
task :update_manpages do
  puppet = ENV['PUPPETDIR']
  applications  = Dir.glob(%Q{#{puppet}/lib/puppet/application/*})
  ronn = %x{which ronn}.chomp
  unless File.executable?(ronn) then fail("Ronn does not appear to be installed.") end
  applications.each do |app|
    app.gsub!( /^#{puppet}\/lib\/puppet\/application\/(.*?)\.rb/, '\1')
    headerstring = "---\nlayout: default\ntitle: puppet #{app} Manual Page\n---\n\n"
    manstring = %x{RUBYLIB=#{puppet}/lib:$RUBYLIB #{puppet}/bin/puppet #{app} --help | #{ronn} --pipe -f}
    File.open(%Q{./source/man/#{app}.markdown}, 'w') do |file|
      file.puts("#{headerstring}#{manstring}")
    end
  end

end

namespace :references do

  namespace :symlink do

    desc "Show the versions that will be symlinked"
    task :versions do
      require 'puppet_docs'
      PuppetDocs::Reference.special_versions.each do |name, (version, source)|
        puts "#{name}: #{version}"
      end
    end
        
  end

  desc "Symlink the latest & stable directories"
  task :symlink do
    require 'puppet_docs'
    PuppetDocs::Reference.special_versions.each do |name, (version, source)|
      Dir.chdir '../output/references' do
        ln_sf version.to_s, name.to_s
      end
    end
  end

  namespace :puppetdoc do
    
    references.each do |name|
      desc "Write references/VERSION/#{name}"
      task name => 'references:check_version' do
        require 'puppet_docs'
        PuppetDocs::Reference::Generator.new(ENV['VERSION'], name).generate
      end
    end

  end

  desc "Write all references for VERSION"
  task :puppetdoc => references.map { |r| "puppetdoc:#{r}" }

  namespace :index do
  
    desc "Generate a stub index for VERSION"
    task :stub => 'references:check_version' do
      filename = Pathname.new('source/references') + ENV['VERSION'] + 'index.markdown'
      filename.parent.mkpath
      filename.open('w') do |f|
        f.puts "---"
        f.puts "layout: default"
        f.puts "title: #{ENV['VERSION']} References"
        f.puts "---\n\n\n"
        f.puts "# #{ENV['VERSION']} References\n"
        f.puts "* * *\n\n"
        references.each do |name|
          f.puts "* [#{name.capitalize}](#{name}.html)"
        end
      end
      puts "Wrote #{filename}"
    end

  end

  task :check_version do
    abort "No VERSION given (must be a valid repo tag)" unless ENV['VERSION'] 
  end

  task :fetch_tags do
    Dir.chdir("vendor/puppet")
    sh "git fetch --tags"
    Dir.chdir("../..")
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "puppet-docs"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
