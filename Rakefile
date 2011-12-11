require 'rubygems'
require 'rake'
require 'pathname'
require 'fileutils'

Dir.glob(File.join("vendor", "gems", "*", "lib")).each do |lib|
  $LOAD_PATH.unshift(File.expand_path(lib))
end

begin
  require "vlad"
  Vlad.load :scm => :git
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

desc "Generate the documentation in a flat format for later PDF generation"
task :generate_pdf do
  require 'yaml'
  system("rm -rf pdf_source")
  system("cp -rf source pdf_source")
  system("cp -rf pdf_mask/* pdf_source") # Copy in and/or overwrite differing files
  # The point being, this way we don't have to maintain separate copies of the actual source files, and it's clear which things are actually different for the PDF version of the page.
  Dir.chdir("pdf_source")
  system("../vendor/gems/jekyll-0.7.0/bin/jekyll --kramdown ../pdf_output")
  Rake::Task['references:symlink:for_pdf'].invoke
  Dir.chdir("../pdf_output")
  pdf_targets = YAML.load(File.open("../pdf_mask/pdf_targets.yaml"))
  pdf_targets.each do |target, pages|
    system("cat #{pages.join(' ')} > #{target}")
  end
#   system("cat `cat ../pdf_source/page_order.txt` > rebuilt_index.html")
#   system("mv index.html original_index.html")
#   system("mv rebuilt_index.html index.html")
  puts "Remember to run rake serve_pdf"
  puts "Remember to run rake compile_pdf (while serving on localhost:9292)"
  Dir.chdir("..")
end

desc "Serve generated flat-for-PDF output on port 9292"
task :serve_pdf do
  system("rackup config_pdf.ru")
end

desc "Use a series of wkhtmltopdf commands to compile PDF targets"
task :compile_pdf do
  require 'yaml'
  fail("wkhtmltopdf doesn't appear to be installed") unless File.executable?(%x{which wkhtmltopdf}.chomp)
  pdf_targets = YAML.load(File.open("pdf_mask/pdf_targets.yaml"))
  pdf_targets.keys.each do |target|
    puts "Generating #{target}..."
    system(%Q^wkhtmltopdf --margin-bottom 17mm --margin-top 17mm --margin-left 15mm --footer-left "[doctitle] • [section]" --footer-right "[page]/[topage]" --footer-line --footer-font-name "Lucida Grande" --footer-font-size 10 --footer-spacing 2 cover http://localhost:9292/cover_#{target} http://localhost:9292/#{target} #{target.gsub('.html', '')}.pdf^)
  end
end

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
  sh "tar -czf puppetdocs-latest.tar.gz *"
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
    headerstring = "---\nlayout: default\ntitle: puppet #{app} Manual Page\n---\n\npuppet #{app} Manual Page\n======\n\n"
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

    desc "Symlink the latest & stable directories when generating a flat page for PDFing"
    task :for_pdf do
      require 'puppet_docs'
      PuppetDocs::Reference.special_versions.each do |name, (version, source)|
        Dir.chdir '../pdf_output/references' do
          FileUtils.ln_sf version.to_s, name.to_s
        end
      end

    end

  end

  desc "Symlink the latest & stable directories"
  task :symlink do
    require 'puppet_docs'
    PuppetDocs::Reference.special_versions.each do |name, (version, source)|
      Dir.chdir '../output/references' do
        FileUtils.ln_sf version.to_s, name.to_s
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

task :deploy do
  sh "rake mirror0 vlad:build"
  sh "rake mirror0 vlad:release"
  sh "rake mirror1 vlad:release"
  sh "rake mirror2 vlad:release"
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "puppet-docs"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
