require 'json'
require 'pathname'
require 'puppet_references'

module PuppetReferences
  module VersionTables
    # A generic class for puppet agent tables.
    class AgentTables
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'version_tables'

      def initialize(agent_data)
        @agent_data = agent_data
        @file = 'generic.md' # override me
        @versions = [] # override me
        @agent_stuff = %w(Puppet Facter Hiera MCollective Ruby OpenSSL)

      end

      def build_all
        header = ['puppet-agent'].concat(@agent_stuff)
        body = @versions.map {|version| # Make a row for each version
          component_versions = @agent_stuff.map {|component| # read from the version info
            PuppetReferences::Util.link_release_notes_if_applicable(
                component,
                @agent_data[version][component],
                nil,
                @agent_data
            )
          }
          linked_agent_version = PuppetReferences::Util.link_release_notes_if_applicable(
              'Puppet Agent',
              version,
              nil,
              @agent_data
          )
          [linked_agent_version].concat(component_versions)
        }

        table = PuppetReferences::Util.table_from_header_and_array_of_body_rows(header, body)

        OUTPUT_DIR.mkpath
        filename = OUTPUT_DIR + @file
        filename.open('w') {|f| f.write(table)}
      end

    end
  end
end
