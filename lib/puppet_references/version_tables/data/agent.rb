require 'puppet_references'
require 'pathname'
require 'json'
require 'versionomy'

module PuppetReferences
  module VersionTables
    module Data
      class Agent
        def initialize
          @repo = PuppetReferences::Repo.new(
            'puppet-agent',
            PuppetReferences::AGENT_DIR,
            ['git@github.com:puppetlabs/puppet-agent.git',
             'git@github.com:puppetlabs/puppet-agent-cve.git']
          )
          @data = nil
          config = PuppetReferences::VersionTables::Config.read
          @includes = config['agent']['include'] || {}
          @excludes = config['agent']['exclude'] || []

          detected_versions = @repo.tags.map {|tag| tag.name}
          until detected_versions.first == '1.0.0'
            detected_versions.shift
          end
          @versions_and_commits = Hash[ detected_versions.map {|name| [name, name]} ]
          @excludes.each do |tag|
            @versions_and_commits.delete(tag)
          end
          @versions_and_commits.merge!(@includes)

          @component_files = {
              'Ruby' => 'ruby.rb',
              'OpenSSL' => 'openssl.rb',
              'Puppet' => 'puppet.json',
              'Facter' => 'facter.json',
              'Hiera' => 'hiera.json',
              'MCollective' => 'marionette-collective.json'
          }
          @component_name_patterns = {
              'Ruby' => /^ruby(-[\d\.]+)?$/,
              'OpenSSL' => /^openssl$/,
              'Puppet' => /^puppet$/,
              'Facter' => /^facter$/,
              'Hiera' => /^hiera$/,
              'MCollective' => /^marionette-collective$/
          }

        end

        # The main method: just return everything.
        def data
          unless @data
            puts 'Updating historical agent data by reading the puppet-agent repo...'
            @data = Hash[
                @versions_and_commits.map {|name, commit|
                  puts "#{name}..."
                  @repo.checkout(commit)
                  if Versionomy.parse(name) < Versionomy.parse('1.8.0')
                    components_hash = get_components_hash_pre_vanagon_0_7()
                  else
                    components_hash = get_components_hash()
                  end
                  [name, components_hash]
                }
            ]
          end
          @data
        end

        # Before Vanagon 0.7, we have to actually just grep the component files. Boo.
        def get_components_hash_pre_vanagon_0_7
          @component_files.reduce(Hash.new) {|result, (component, config)|
            component_file = PuppetReferences::AGENT_DIR + 'configs/components' + config
            if component_file.extname == '.json'
              result[component] = version_from_json(component_file)
            elsif component_file.extname == '.rb'
              result[component] = version_from_ruby(component_file)
            else
              raise("Unexpected file extension for #{component_file}")
            end
            result
          }
        end

        def get_components_hash
          # Make sure the bundle is fresh
          @repo.update_bundle

          # This might vary per-platform... but for now, we'll just take the most recent 64-bit EL version and hope.
          platform = Dir.glob(PuppetReferences::AGENT_DIR.to_s + '/configs/platforms/*').map{|path| File.basename(path, '.rb')}.select{|path| path =~ /^el-\d+-x86_64/}.sort.last
          puts "Using agent data for #{platform}"
          inspect_command = PuppetReferences::PuppetCommand.new("inspect puppet-agent #{platform}", PuppetReferences::AGENT_DIR)
          inspect_data = JSON.parse(inspect_command.get)

          @component_name_patterns.reduce(Hash.new) {|result, (component, pattern)|
            component_data = inspect_data.detect{|comp| comp['name'] =~ pattern}
            if component_data.nil?
              raise("Can't find #{component} on #{platform}! Possibly the name pattern (#{pattern.to_s}) changed (ugh why). Dumping ALL raw data for this version: \n#{inspect_data}")
            end

            if component_data['version']
              result[component] = component_data['version']
            elsif component_data['options']['ref']
              result[component] = version_from_ref(component_data['options']['ref'])
            else
              raise("Can't figure out how to get version for #{component} on #{platform}. Dumping raw data: \n#{component_data}")
            end
            result
          }
        end

        def version_from_ref(ref)
          ref.split('/')[-1]
        end

        def version_from_json(file)
          # We want the last component of a string like refs/tags/4.2.0.
          version_from_ref(JSON.load(File.read(file))['ref'])
        end

        def version_from_ruby(file)
          ruby_text = File.read(file)
          # find 'pkg.version "version"' and capture the version.
          ruby_text.match(/^\s*pkg\.version[\s\(]*['"]([^'"]+)['"]/)[1]
        end

      end
    end
  end
end

