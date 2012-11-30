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
references = %w(configuration function indirection metaparameter report type)

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
  system("rm -rf output")
  Dir.chdir("source")
  system("../vendor/gems/jekyll-0.11.2/bin/jekyll --kramdown ../output")
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
  system("rm -rf pdf_output")
  system("cp -rf source pdf_source")
  system("cp -rf pdf_mask/* pdf_source") # Copy in and/or overwrite differing files
  # The point being, this way we don't have to maintain separate copies of the actual source files, and it's clear which things are actually different for the PDF version of the page.
  Dir.chdir("pdf_source")
  system("../vendor/gems/jekyll-0.11.2/bin/jekyll --kramdown ../pdf_output")
  Rake::Task['references:symlink:for_pdf'].invoke
  Dir.chdir("../pdf_output")
  pdf_targets = YAML.load(File.open("../pdf_mask/pdf_targets.yaml"))
  pdf_targets.each do |target, pages|
    system("cat #{pages.join(' ')} > #{target}")
    if target == 'puppetdb1.html'
      content = File.read('puppetdb1.html')
      content.gsub!('-puppetdb-1-install_from_source-html-step-3-option-b-manually-create-a-keystore-and-truststore', '-puppetdb-1-install_from_source-html-step-3-option-b-manuallu-create-a-keystore-and-truststore')
      File.open('puppetdb1.html', "w") {|pdd1| pdd1.print(content)}
      # Yeah, so, I found the magic string that, when used as an element ID and then
      # linked to from elsewhere in the document, causes wkhtmltopdf to think an
      # unthinkable thought and corrupt the output file.
      # Your guess is as good as mine. #doomed #sorcery #wat
      # >:|
      # -NF
    end
  end
#   system("cat `cat ../pdf_source/page_order.txt` > rebuilt_index.html")
#   system("mv index.html original_index.html")
#   system("mv rebuilt_index.html index.html")
  puts "Remember to run rake serve_pdf"
  puts "Remember to run rake compile_pdf (while serving on localhost:9292)"
  Dir.chdir("..")
end

desc "Temporary task for debugging PDF compile failures"
task :reshuffle_pdf do
  require 'yaml'
  Dir.chdir("pdf_output")
  pdf_targets = YAML.load(File.open("../pdf_mask/pdf_targets.yaml"))
  pdf_targets.each do |target, pages|
    system("cat #{pages.join(' ')} > #{target}")
    if target == 'puppetdb1.html'
      content = File.read('puppetdb1.html')
      content.gsub!('-puppetdb-1-install_from_source-html-step-3-option-b-manually-create-a-keystore-and-truststore', '-puppetdb-1-install_from_source-html-step-3-option-b-manuallu-create-a-keystore-and-truststore')
      File.open('puppetdb1.html', "w") {|pdd1| pdd1.print(content)}
      # Yeah, so, I found the magic string that, when used as an element ID and then
      # linked to from elsewhere in the document, causes wkhtmltopdf to think an
      # unthinkable thought and corrupt the output file.
      # Your guess is as good as mine. #doomed #sorcery #wat
      # >:|
      # -NF
    end
  end
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

desc "Create tarball of documentation"
task :tarball do
  tarball_name = "puppetdocs-latest.tar.gz"
  FileUtils.cd 'output'
  sh "tar -czf #{tarball_name} *"
  FileUtils.mv tarball_name, '..'
  FileUtils.cd '..'
  sh "git rev-parse HEAD > #{tarball_name}.version" if File.directory?('.git') # Record the version of this tarball, but only if we're in a git repo.
end

desc "Build the documentation site and tar it for deployment"
task :build do
  Rake::Task['generate'].invoke
  Rake::Task['tarball'].invoke
end

desc "Build all references and man pages for a new Puppet version"
task :references => [ 'references:check_version', 'references:fetch_tags', 'references:index:stub', 'references:puppetdoc', 'references:update_manpages']

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

end

desc "Deploy the site to the production servers"
task :deploy do
  mirrors = ['mirror0', 'mirror2']
  Rake::Task['build'].invoke
  mirrors.each do |mirror|
    sh "rake #{mirror} vlad:release"
    # Note that the below will always fail on the second mirror, even though it should totally work. Life is filled with mystery. >:|
    # Rake::Task[mirror].invoke
    # Rake::Task['vlad:release'].reenable # so we can invoke it again if this isn't the last mirror
    # Rake::Task['vlad:release'].invoke
  end
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "puppet-docs"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
