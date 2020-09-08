# encoding: UTF-8
require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'pathname'
require 'fileutils'
require 'yaml'
require 'puppet_docs/config'
require 'rake/clean'


CLOBBER.include('output')
CLOBBER.include('externalsources')
CLOBBER.include('references_output')

top_dir = Dir.pwd

SOURCE_DIR = "#{top_dir}/source"
OUTPUT_DIR = "#{top_dir}/output"
STASH_DIR = "#{top_dir}/_stash"
PREVIEW_DIR = "#{top_dir}/_preview"

VERSION_FILE = "#{OUTPUT_DIR}/VERSION.txt"

@config_data = PuppetDocs::Config.new("#{SOURCE_DIR}/_config.yml")

def jekyll(command = 'build', source = SOURCE_DIR, destination = OUTPUT_DIR, *args)

  about_verbose_mode = <<-ABOUT_VERBOSE_MODE

    -*-*-*-*-*-*-*-*-*-*-*-*-

    To turn on verbose mode and logging,
    $ export DEBUG_PUPPET_DOCS_RAKEFILE=1

    To turn off,
    $ unset DEBUG_PUPPET_DOCS_RAKEFILE

    -*-*-*-*-*-*-*-*-*-*-*-*-

  ABOUT_VERBOSE_MODE

  puts about_verbose_mode

  if ENV['DEBUG_PUPPET_DOCS_RAKEFILE']
    verbose_mode = '--verbose | tee puppet-docs-build.log'
  end

  amended_config = "#{SOURCE_DIR}/_config_amended.yml"
  File.write(amended_config, YAML.dump(@config_data))
  system("set -x; bundle exec jekyll #{command} --source #{source} --destination #{destination} #{args.join(' ')} --config #{amended_config} #{verbose_mode}")
  FileUtils.rm(amended_config)
end

desc "Stash all directories but one in a temporary location. Run a preview server on localhost:4000."
task :preview, :filename do |t, args|

  if ["marionette-collective", "puppetdb_master", "puppetdb_1.1", "puppetdb", "mcollective"].include?(args.filename)
    abort("\n\n*** External documentation sources aren't supported right now.\n\n")
  end

  # Make sure we have a stash_directory
  FileUtils.mkdir(STASH_DIR) unless File.exist?(STASH_DIR)

  # Directories and files we have to have for a good live preview
  required_dirs = ["_config.yml", "_includes", "_plugins", "files", "favicon.ico", "_layouts","images"]

  # Move the things we don't need into the _stash
  Dir.glob("#{SOURCE_DIR}/*") do |directory|
    FileUtils.mv directory, STASH_DIR unless directory.include?(args.filename) || required_dirs.include?(File.basename(directory))
  end

  # Get all the files we'd like to see in a temporary preview index (so we don't have to hunt for files by name)
  Dir.chdir("#{SOURCE_DIR}/#{args.filename}")
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

  Dir.chdir(SOURCE_DIR)
  # put our file list index in place
  File.open("index.markdown", 'w') {|f| f.write(preview_index) }

  # Run our preview server, watching ... watching ...
  jekyll('serve', SOURCE_DIR, PREVIEW_DIR)

  # When we kill it with a ctl-c ...
  puts "\n\n*** Shut down the server."

  # Clean up after ourselves (in a separate task in case something goes wrong and we need to do it manually)
  Rake::Task['unpreview'].invoke
end

desc "Move all stashed directories back into the source directory, ready for site generation. "
task :unpreview do
  puts "\n*** Putting back the stashed files, removing the preview directory."
  FileUtils.mv Dir.glob("#{STASH_DIR}/*"), "#{SOURCE_DIR}"
  FileUtils.rm_rf(PREVIEW_DIR)
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
  def safe_dirname(name)
    name.sub(/^[:\/\.]+/, '').gsub(/[:\/\.]+/, '_')
  end

  # "Update all working copies defined in source/_config.yml"
  task :update do
    Rake::Task['externalsources:clone'].invoke
    Dir.chdir('externalsources') do
      @config_data['externalsources'].each do |url, info|
        workdir = safe_dirname(url)
        local_repo = safe_dirname(info['repo'])
        unless File.directory?(workdir)
          puts "Making new working directory for #{url}"
          system ("\"#{top_dir}/vendor/bin/git-new-workdir\" '#{local_repo}' '#{workdir}' '#{info['commit']}'")
        end
        Dir.chdir(workdir) do
          puts "Updating #{url}"
          system ("git checkout --force #{info['commit']} && git clean --force .")
        end
      end
    end
  end

  # "Fetch all external doc repos (from externalsources in source/_config.yml), cloning any that don't yet exist"
  task :clone do
    repos = @config_data['externalsources'].values.map {|info| info['repo']}.uniq

    Dir.chdir("externalsources") do
      repos.each do |repo|
        puts "Fetching #{repo}"
        repo_dir = safe_dirname(repo)
        system ("git clone #{repo} #{repo_dir}") unless File.directory?(repo_dir)
        Dir.chdir(repo_dir) do
          system("git fetch origin")
        end
      end
    end
  end

  # "Symlink external documentation into place in the source directory"
  task :link do
    Rake::Task['externalsources:clean'].invoke # Bad things happen if any of these symlinks already exist, and Jekyll will run FOREVER
    Rake::Task['externalsources:clean'].reenable
    @config_data['externalsources'].each do |url, info|
      workdir = safe_dirname(url)
      destination = "#{SOURCE_DIR}#{url}"
      if File.exist?(destination)
        puts "\n  WARNING: I need to symlink #{url} into place at #{destination}, but a file or directory already exists there. It's probably a glitch, so I'm deleting it. -NF"
        # This usually happens when a directory like source/pe/3.8 contains a (usually hidden) file that Git won't automatically delete because it's listed in the .gitignore file. (For example, .DS_Store.) That leaves the containing directory hanging around, and if we try to run the FileUtils.ln_sf command below, it will link <PE REPO>/source into place at source/pe/3.8/source instead of source/pe/3.8, which then breaks the site.
        FileUtils.remove_entry_secure(destination)
      end
      # Have to use absolute paths for the source, since we have no idea how deep in the hierarchy the url is (and thus how many ../..s it would need).
      FileUtils.ln_sf "#{top_dir}/externalsources/#{workdir}/#{info['subdirectory']}", "#{SOURCE_DIR}#{url}"
    end
  end

  # "Clean up any external source symlinks from the source directory" # In the current implementation, all external sources are symlinks and there are no other symlinks in the source. This means we can naively kill all symlinks in ./source.
  task :clean do
    allsymlinks = FileList.new("#{SOURCE_DIR}/**/*").select{|f| File.symlink?(f)}
    allsymlinks.each do |f|
      File.delete(f)
    end
  end
end

desc "Clean up any crap left over from failed docs site builds"
task :clean do
  # Get rid of external sources symlinks
  puts "Deleting symlinks to external sources..."
  Rake::Task['externalsources:clean'].invoke
  Rake::Task['externalsources:clean'].reenable
  # Get rid of the amended config file we write for Jekyll
  begin
    puts "Deleting _config_amended.yml..."
    FileUtils.rm("#{SOURCE_DIR}/_config_amended.yml")
  rescue
    puts "There was no _config_amended.yml file to delete."
  end
end

desc "Generate the documentation"
task :generate do
  Rake::Task['externalsources:update'].invoke # Create external sources if necessary, and check out the required working directories
  Rake::Task['externalsources:link'].invoke # Link docs folders from external sources into the source at the appropriate places.

  system("mkdir -p #{OUTPUT_DIR}")
  system("rm -rf #{OUTPUT_DIR}/*")
  jekyll()

  # Rake::Task['symlink_latest_versions'].invoke

  Rake::Task['externalsources:clean'].invoke # The opposite of externalsources:link. Delete all symlinks in the source.
  Rake::Task['externalsources:clean'].reenable

  Rake::Task['generate_redirects'].invoke

  if @config_data['preview'].class == Array && @config_data['preview'].length > 0
    puts "THIS IS A PREVIEW VERSION, AND IT'S MISSING IMPORTANT STUFF. Do not deploy the site in this state; this is for local viewing only. To build a real version of the site, delete the `preview:` key from _config.yml."
  end
end

desc "Symlink latest versions of several projects; see symlink_latest and lock_latest lists in _config.yml"
task :symlink_latest_versions do
  require 'puppet_docs/versions'

  # Auto-link the latest version of every project in symlink_latest
  @config_data['symlink_latest'].each do |project|
    project_dir = "#{OUTPUT_DIR}/#{project}"

    versions = Pathname.glob("#{project_dir}/*").select {|f|
      f.directory? && !f.symlink?
    }.map {|d| d.basename.to_s}

    latest = @config_data['lock_latest'][project] || PuppetDocs::Versions.latest(versions)

    begin
      Dir.chdir project_dir do
        FileUtils.ln_sf latest, 'latest'
      end
    rescue Errno::ENOENT => err
      if @config_data['preview'].class == Array && @config_data['preview'].length > 0
        puts "WARNING: Couldn't symlink latest version of #{project}, but you're building a limited preview, so I'll let it slide."
      else
        puts "ERROR: Couldn't symlink latest version of #{project}. Something is probably horribly wrong. I'm bailing out."
        raise Errno::ENOENT
      end
    end
  end
end

desc "Generate bidirectional redirects using the source/_redirects.yaml file, and write them to the Nginx config file in the output dir"
task :generate_redirects do
  require 'puppet_docs/auto_redirects'
  nginx_config = "#{OUTPUT_DIR}/nginx_rewrite.conf"
  redirects_yaml = "#{SOURCE_DIR}/_redirects.yaml"
  generated_lines = PuppetDocs::AutoRedirects.generate(@config_data, redirects_yaml)
  File.open(nginx_config, 'a') {|f| f.write(generated_lines)}
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
    File.open(VERSION_FILE, 'w') do |f|
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
  abort "No site build found! Run 'rake build' before releasing." unless File.directory?(OUTPUT_DIR)
  abort "Site build is empty! Run 'rake build' before releasing." if (Dir.entries(OUTPUT_DIR) - %w{ . .. }).empty?
  if File.directory?('.git')
    if File.exists?(VERSION_FILE)
      head = `git rev-parse HEAD`.strip
      build_version = File.read(VERSION_FILE)
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

desc 'Check all internal links in the site. This also results in a deployable site build.'
task :build_and_check_links do
  @config_data['check_links'] = true
  Rake::Task['build'].invoke
end



desc "Instead of building real pages, build naked HTML fragments (with no nav, etc.)"
task :build_html_fragments do
  Rake::Task['check_git_dirty_status'].invoke
  Dir.chdir("#{SOURCE_DIR}/_layouts") do
    FileUtils.mv("default.html", "real_default.html")
    FileUtils.mv("fragment.html", "default.html")
  end
  Rake::Task['generate'].invoke
  # don't write version, so we'll give a noisy error if you try to deploy fragments!
  Dir.chdir("#{SOURCE_DIR}/_layouts") do
    FileUtils.mv("default.html", "fragment.html")
    FileUtils.mv("real_default.html", "default.html")
  end
end

desc "Build HTML fragments, then mangle all of them for Transifex (takes a while)"
task :build_and_mangle_html_fragments do
  require 'puppet_docs/sentence_segmenter'
  Rake::Task[:build_html_fragments].invoke
  all_fragments = Dir.glob('output/**/*.html') # This actually sweeps up YARD pages too, but... never mind.
  total_size = all_fragments.length
  all_fragments.each_with_index do |fragment, i|
    print "(#{i+1}/#{total_size}) "
    PuppetDocs::SentenceSegmenter.mangle_file(fragment)
  end
end

desc "Build body-only HTML content (+ sidebar nav)"
task :body_and_nav_html_only do
  # Rake::Task['check_git_dirty_status'].invoke
  # The reason the above line was breaking jjb was because every time the job runs, it starts with a new workspace, unlike our old jobs. If you're running this command locally, you may want to uncomment the above line.
  Dir.chdir("#{SOURCE_DIR}/_layouts") do
    FileUtils.mv("default.html", "real_default.html")
    FileUtils.mv("body_only.html", "default.html")
  end

  # These steps below are the steps inside of :generate, minus the symlinks, and redirect tasks. Symlinks were doing weird things on Mikey's end, so I removed that task.
  Rake::Task['externalsources:update'].invoke # Create external sources if necessary, and check out the required working directories
  Rake::Task['externalsources:link'].invoke # Link docs folders from external sources into the source at the appropriate places.

  system("mkdir -p #{OUTPUT_DIR}")
  system("rm -rf #{OUTPUT_DIR}/*")
  jekyll()

  Rake::Task['externalsources:clean'].invoke # The opposite of externalsources:link. Delete all symlinks in the source.
  Rake::Task['externalsources:clean'].reenable


  if @config_data['preview'].class == Array && @config_data['preview'].length > 0
    puts "THIS IS A PREVIEW VERSION, AND IT'S MISSING IMPORTANT STUFF. Do not deploy the site in this state; this is for local viewing only. To build a real version of the site, delete the `preview:` key from _config.yml."
  end
  
  Dir.chdir("#{SOURCE_DIR}/_layouts") do
    FileUtils.mv("default.html", "body_only.html")
    FileUtils.mv("real_default.html", "default.html")
  end
end

desc "List the available groups of references. Run `rake references:<GROUP>` to build."
task :references do
  puts 'The following references are available:'
  puts 'bundle exec rake references:puppet VERSION=<GIT TAG OR COMMIT>'
  puts 'bundle exec rake references:facter VERSION=<GIT TAG OR COMMIT>'
  puts 'bundle exec rake references:version_tables'
end

namespace :references do
  task :puppet => 'references:check_version' do
    require 'puppet_references'
    PuppetReferences.build_puppet_references(ENV['VERSION'])
  end

  task :facter => 'references:check_version' do
    require 'puppet_references'
    PuppetReferences.build_facter_references(ENV['VERSION'])
  end

  task :version_tables do
    require 'puppet_references'
    PuppetReferences.build_version_tables
  end

  task :check_version do
    abort "No VERSION given to build references for" unless ENV['VERSION']
  end
end



