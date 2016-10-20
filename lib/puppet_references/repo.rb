require 'puppet_references'
require 'git'

module PuppetReferences
  class Repo

    attr_reader :name, :directory, :source, :repo

    def initialize(name, directory, sources = nil)
      @name = name
      @directory = directory
      if sources
        @sources = [sources].flatten
      else
        @sources = ["git@github.com:puppetlabs/#{@name}.git"]
      end
      @main_source = @sources[0]
      unless Dir.exist?(@directory + '.git')
        puts "Cloning #{@name} repo..."
        Git.clone(@main_source, @directory)
        puts 'done cloning.'
      end
      @repo = Git.open(@directory)
      # fetch the main source
      @repo.fetch
      # fetch tags from secondary sources
      @sources[1..-1].each do |source|
        @repo.fetch(source, {tags: true})
      end
    end

    def checkout(commit)
      @repo.checkout(commit, {force: true})
      @repo.revparse(commit)
    end

    def tags
      @repo.tags
    end

    def update_bundle
      Dir.chdir(@directory) do
        if Dir.exist?(@directory + '.bundle/stuff')
          puts "In #{@name} dir: Running bundle update."
          PuppetReferences::Util.run_dirty_command('bundle update')
        else
          puts "In #{@name} dir: Running bundle install --path .bundle/stuff"
          PuppetReferences::Util.run_dirty_command('bundle install --path .bundle/stuff')
        end
      end
    end

  end
end