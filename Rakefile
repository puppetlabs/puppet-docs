# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'pathname'
require 'fileutils'
require 'yaml'

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

references = %w(configuration function indirection metaparameter report type developer man)
top_dir = Dir.pwd

source_dir = "#{top_dir}/source"
output_dir = "#{top_dir}/output"
stash_dir = "#{top_dir}/_stash"
preview_dir = "#{top_dir}/_preview"

version_file = "#{output_dir}/VERSION.txt"

config_data = YAML.load(File.read("#{source_dir}/_config.yml"))

desc "Stash all directories but one in a temporary location. Run a preview server on localhost:4000."
task :preview, :filename do |t, args|

  if ["marionette-collective", "puppetdb_master", "puppetdb_1.1", "puppetdb", "mcollective"].include?(args.filename)
    abort("\n\n*** External documentation sources aren't supported right now.\n\n")
  end

  # Make sure we have a stash_directory
  FileUtils.mkdir(stash_dir) unless File.exist?(stash_dir)

  # Directories and files we have to have for a good live preview
  required_dirs = ["_config.yml", "_includes", "_plugins", "files", "favicon.ico", "_layouts","images"]

  # Move the things we don't need into the _stash
  Dir.glob("#{source_dir}/*") do |directory|
    FileUtils.mv directory, stash_dir unless directory.include?(args.filename) || required_dirs.include?(File.basename(directory))
  end

  # Get all the files we'd like to see in a temporary preview index (so we don't have to hunt for files by name)
  Dir.chdir("#{source_dir}/#{args.filename}")
  file_list = Dir.glob("**/*.markdown")
  preview_index_files = []
  file_list.each do |f|
    html_name = f.gsub(/\.markdown/,'.html')
    preview_index_files << "* [#{args.filename}/#{html_name}](#{args.filename}/#{html_name})\n"
  end

preview_index=<<PREVIEW_INDEX
---
layout: frontpage
title: Files Available for Live Preview
canonical: "/"
---
#{preview_index_files}
PREVIEW_INDEX

  Dir.chdir(source_dir)
  # put our file list index in place
  File.open("index.markdown", 'w') {|f| f.write(preview_index) }

  # Run our preview server, watching ... watching ...
  system("bundle exec jekyll  #{preview_dir} --auto --serve")

  # When we kill it with a ctl-c ...
  puts "\n\n*** Shut down the server."

  # Clean up after ourselves (in a separate task in case something goes wrong and we need to do it manually)
  Rake::Task['unpreview'].invoke
end

desc "Move all stashed directories back into the source directory, ready for site generation. "
task :unpreview do
  puts "\n*** Putting back the stashed files, removing the preview directory."
  FileUtils.mv Dir.glob("#{stash_dir}/*"), "#{source_dir}"
  FileUtils.rm_rf(preview_dir)
  puts "\n*** Done.\n\n"
end

namespace :externalsources do

  unless File.exists?("externalsources") && File.directory?("externalsources")
    Dir.mkdir("externalsources")
  end

  # Returns the short name of a repo, which would be the directory name if you did a `git clone` without specifying a directory name. This isn't used anymore, but I left it around in case it's useful later.
  def repo_name(repo_url)
    repo_url.split('/')[-1].sub(/\.git$/, '')
  end

  # Returns something like git_github_com_puppetlabs_marionette-collective_git. We use this as the name of the main repo directory, because we may need to disambiguate between two repos with the same short name but a different user account on github.
  def repo_unique_id(repo_url)
    repo_url.gsub(/[:\/\.]+/, '_')
  end

  # "Update all working copies defined in source/_config.yml"
  task :update do
    Rake::Task['externalsources:clone'].invoke
    Dir.chdir("externalsources") do
      config_data['externalsources'].each do |name, info|
        unless File.directory?(name)
          puts "Making new working directory for #{name}"
          system ("\"#{top_dir}/vendor/bin/git-new-workdir\" '#{repo_unique_id(info['repo'])}' '#{name}' '#{info['commit']}'")
        end
        Dir.chdir(name) do
          puts "Updating #{name}"
          system ("git fetch origin && git checkout --force #{info['commit']} && git clean --force .")
        end
      end
    end
  end

  # "Clone any external documentation repos (from externalsources in source/_config.yml) that don't yet exist"
  task :clone do
    repos = []
    config_data['externalsources'].each do |name, info|
      repos << info['repo']
    end
    Dir.chdir("externalsources") do
      repos.uniq.each do |repo|
        system ("git clone #{repo} #{repo_unique_id(repo)}") unless File.directory?("#{repo_unique_id(repo)}")
      end
    end
  end

  # "Symlink external documentation into place in the source directory"
  task :link do
    Rake::Task['externalsources:clean'].invoke # Bad things happen if any of these symlinks already exist, and Jekyll will run FOREVER
    Rake::Task['externalsources:clean'].reenable
    config_data['externalsources'].each do |name, info|
      # Have to use absolute paths for the source, since we have no idea how deep in the hierarchy info['url'] is (and thus how many ../..s it would need).
      FileUtils.ln_sf "#{top_dir}/externalsources/#{name}/#{info['subdirectory']}", "#{source_dir}#{info['url']}"
    end
  end

  # "Clean up any external source symlinks from the source directory" # In the current implementation, all external sources are symlinks and there are no other symlinks in the source. This means we can naively kill all symlinks in ./source.
  task :clean do
    allsymlinks = FileList.new("#{source_dir}/**/*").select{|f| File.symlink?(f)}
    allsymlinks.each do |f|
      File.delete(f)
    end
  end
end

desc "Generate the documentation"
task :generate do
  Rake::Task['externalsources:update'].invoke # Create external sources if necessary, and check out the required working directories
  Rake::Task['externalsources:link'].invoke # Link docs folders from external sources into the source at the appropriate places.

  system("mkdir -p #{output_dir}")
  system("rm -rf #{output_dir}/*")
  system("mkdir #{output_dir}/references")
  Dir.chdir(source_dir) do
    system("bundle exec jekyll  #{output_dir}")
  end

  Rake::Task['references:symlink'].invoke
  Rake::Task['symlink_latest_versions'].invoke

  Rake::Task['externalsources:clean'].invoke # The opposite of externalsources:link. Delete all symlinks in the source.
  Rake::Task['externalsources:clean'].reenable
end

desc "Symlink latest versions of several projects; see symlink_latest and lock_latest lists in _config.yml"
task :symlink_latest_versions do
  require 'versionomy'
  require 'pathname'

  # Auto-link the latest version of every project in symlink_latest
  config_data['symlink_latest'].each do |project|
    # Skip locked projects
    next if config_data['lock_latest'].keys.include?(project)

    # this bit is snipped from PuppetDocs::Reference
    subdirs = Pathname.new("#{output_dir}/#{project}").children.select do |child|
      child.directory? && !child.symlink?
    end
    versions = []
    subdirs.each do |path|
      begin
        version = Versionomy.parse(path.basename.to_s)
        versions << version
      rescue
        next
      end
    end
    versions.sort! # sorts into ascending order, so most recent is last
    Dir.chdir "#{output_dir}/#{project}" do
      FileUtils.ln_sf versions.last.to_s, 'latest'
    end
  end

  # Manually link the locked "latest" version of every project in lock_latest
  config_data['lock_latest'].each do |project, version|
    Dir.chdir "#{output_dir}/#{project}" do
      FileUtils.ln_sf version.to_s, 'latest'
    end
  end
end

desc "Serve generated output on port 9292"
task :serve do
  system("rackup")
end

desc "Generate docs and serve locally"
task :run => [:generate, :serve]


task :write_version do
  if File.directory?('.git')
    current_commit = `git rev-parse HEAD`.strip
    File.open(version_file, 'w') do |f|
      f.print(current_commit)
    end
  end
end

task :check_git_dirty_status do
  if File.directory?('.git')
    Rake::Task['externalsources:clean'].invoke # Don't let leftover symlinks from a cancelled build mark the tree as dirty.
    Rake::Task['externalsources:clean'].reenable

    if `git status --porcelain 2> /dev/null | tail -n1` != ''
      STDOUT.puts "The working directory has uncommitted changes. They're probably either \n  incomplete changes you don't want to release, or important changes you \n  don't want lost; in either case, you might want to deal with them before \n  you build and deploy the site. Continue anyway? (y/n)"
      abort "Aborting." unless STDIN.gets.strip.downcase =~ /^y/
    end
  end
end

task :check_build_version do
  abort "No site build found! Run 'rake build' before releasing." unless File.directory?(output_dir)
  abort "Site build is empty! Run 'rake build' before releasing." if (Dir.entries(output_dir) - %w{ . .. }).empty?
  if File.directory?('.git')
    if File.exists?(version_file)
      head = `git rev-parse HEAD`.strip
      build_version = File.read(version_file)
      if head != build_version
        STDOUT.puts "This build wasn't built from HEAD and may be outdated. Continue anyway? (y/n)"
        abort "Aborting." unless STDIN.gets.strip.downcase =~ /^y/
      end
    else
      STDOUT.puts "Can't tell age of site build; it's probably outdated. Continue anyway? (y/n)"
      abort "Aborting." unless STDIN.gets.strip.downcase =~ /^y/
    end
  end
end

desc "Build the documentation site and prepare it for deployment"
task :build do
  Rake::Task['check_git_dirty_status'].invoke
  Rake::Task['generate'].invoke
  Rake::Task['write_version'].invoke
end

desc "Instead of building real pages, build naked HTML fragments (with no nav, etc.)"
task :build_html_fragments do
  Rake::Task['check_git_dirty_status'].invoke
  Dir.chdir("#{source_dir}/_layouts") do
    FileUtils.mv("default.html", "real_default.html")
    FileUtils.mv("fragment.html", "default.html")
  end
  Rake::Task['generate'].invoke
  # don't write version, so we'll give a noisy error if you try to deploy fragments!
  Dir.chdir("#{source_dir}/_layouts") do
    FileUtils.mv("default.html", "fragment.html")
    FileUtils.mv("real_default.html", "default.html")
  end
end

desc "Build all references for a new Puppet version"
task :references => [ 'references:check_version', 'references:index:stub', 'references:puppetdoc']

namespace :references do

  namespace :symlink do
    # "Show the versions that will be symlinked"
    task :versions do
      require 'puppet_docs'
      PuppetDocs::Reference.special_versions.each do |name, (version, source)|
        puts "#{name}: #{version}"
      end
    end
  end

  # "Symlink the latest & stable directories"
  task :symlink do
    require 'puppet_docs'
    PuppetDocs::Reference.special_versions.each do |name, (version, source)|
      Dir.chdir "#{output_dir}/references" do
        FileUtils.ln_sf version.to_s, name.to_s
      end
    end
  end

  namespace :puppetdoc do

    references.each do |name|
      # "Write references/VERSION/#{name}"
      task name => 'references:check_version' do
        require 'puppet_docs'
        PuppetDocs::Reference::Generator.new(ENV['VERSION'], name, ENV['COMMIT']).generate
      end
    end

  end

  desc "Write all references for VERSION (from optional COMMIT if tag doesn't yet exist)"
  task :puppetdoc => references.map { |r| "puppetdoc:#{r}" }

  namespace :index do

    # "Generate a stub index for VERSION"
    task :stub => 'references:check_version' do
      filename = Pathname.new("#{source_dir}/references") + ENV['VERSION'] + 'index.markdown'
      filename.parent.mkpath
      filename.open('w') do |f|
        f.puts "---"
        f.puts "layout: default"
        f.puts "title: #{ENV['VERSION']} References"
        f.puts "---\n\n\n"
        f.puts "# #{ENV['VERSION']} References\n"
        f.puts "* * *\n\n"
        references.each do |name|
          unless name=="developer" or name=="man"
            f.puts "* [#{name.capitalize}](./#{name}.html)"
          end
        end
        f.puts "* [Developer Documentation](./developer/index.html)\n* [Man Pages](./man/index.html)"
      end
      puts "Wrote #{filename}"
    end

  end

  task :check_version do
    abort "No VERSION given to build references for" unless ENV['VERSION']
  end

end

desc "Deploy the site to the production servers"
task :deploy do
  mirrors = ['mirror0','mirror1']
  Rake::Task['build'].invoke
  mirrors.each do |mirror|
    sh "rake #{mirror} vlad:release"
    # Note that the below will always fail on the second mirror, even though it should totally work. Life is filled with mystery. >:|
    # Rake::Task[mirror].invoke
    # Rake::Task['vlad:release'].reenable # so we can invoke it again if this isn't the last mirror
    # Rake::Task['vlad:release'].invoke
  end
end

