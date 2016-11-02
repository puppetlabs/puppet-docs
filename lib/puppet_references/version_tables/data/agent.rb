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
          temp_component_files = @component_files.merge( {'Ruby' => 'ruby-2.1.9.rb'} )
          temp_component_files.reduce(Hash.new) {|result, (component, config)|
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

        def version_from_json(file)
          # We want the last component of a string like refs/tags/4.2.0.
          JSON.load(File.read(file))['ref'].split('/')[-1]
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

