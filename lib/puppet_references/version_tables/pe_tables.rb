require 'pathname'
require 'puppet_references'

module PuppetReferences
  module VersionTables
    # This is a generic class for this; you have to subclass it for it to work.
    class PeTables
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'version_tables'

      def initialize(pe_data, agent_data = {})
        @pe_data = pe_data
        @agent_data = agent_data
        @file = 'generic.md' # override me
        @versions = [] # override me
        @agent_stuff = [ # prune me
            'Puppet Agent',
            'Puppet',
            'Facter',
            'Hiera',
            'MCollective',
            'Ruby',
            'OpenSSL'
        ]
        @server_stuff = [ # prune me
            'Puppet Server',
            'PuppetDB',
            'r10k',
            'Razor Server',
            'Razor Libs',
            'PostgreSQL',
            'Java',
            'ActiveMQ',
            'Nginx'
        ]
      end

      def build_all
        puts "Building #{@file}"
        # Merge info from puppet-agent and client tools packages into PE version info!
        @versions.each {|pe_version|
          merge_vanagon_info!( @pe_data[pe_version], 'Puppet Agent', @agent_data )
        }

        # First, software on agents / all nodes.
        agent_header = ['PE Version'].concat(@agent_stuff)
        agent_body = make_table_body(@versions, @agent_stuff, @pe_data)

        # Then, server-side software.
        server_header = ['PE Version'].concat(@server_stuff)
        server_body = make_table_body(@versions, @server_stuff, @pe_data)

        # now make tables
        tables = "### Agent components (on all nodes)\n\n" <<
        PuppetReferences::Util.table_from_header_and_array_of_body_rows(agent_header, agent_body) <<
        "### Server components\n\n" <<
        PuppetReferences::Util.table_from_header_and_array_of_body_rows(server_header, server_body)

        OUTPUT_DIR.mkpath
        filename = OUTPUT_DIR + @file
        filename.open('w') {|f| f.write(tables)}
      end

      def abbr_for_given_version(version, platforms)
        # an individual version w/ associated platforms
        '<abbr title="' << platforms.join(', ') << '">' <<
            version <<
            '</abbr>'
      end

      def all_abbrs_for_component(component, vers_to_platforms)
        # a cell of versions
        vers_to_platforms.sort {|x,y| y[0] <=> x[0]}.map {|pkg_ver, platforms|
          PuppetReferences::Util.link_release_notes_if_applicable(
              component,
              abbr_for_given_version(pkg_ver, platforms),
              pkg_ver,
              @agent_data
          )
        }.join('<br>')
      end

      def make_table_body(versions, components, historical_packages)
        versions.map {|version| # Make a row for each version
          component_versions = components.map {|component|
            if historical_packages[version][component]
              all_abbrs_for_component(component, historical_packages[version][component])
            else
              ''
            end
          }
          [version].concat(component_versions)
        }
      end

      # this_pe_version_info is version_info[<PE VERSION>].
      # name_of_vanagon_package is, e.g., 'Puppet Agent'.
      # vanagon_data is the full dump of version info for that vanagon project (slurped in from json).
      def merge_vanagon_info!(this_pe_version_info, name_of_vanagon_package, vanagon_data)
        # Remember that we might have to handle multiple agent/client-tools versions per PE release. So...
        versions_and_operating_systems = this_pe_version_info[name_of_vanagon_package] # it's a hash. '1.2.2' => ['os-1', 'os-2']
        if versions_and_operating_systems.nil?
          return
        end
        versions_and_operating_systems.each {|vanagon_version, os_list|
          vanagon_contents = vanagon_data[vanagon_version] # it's a hash. 'Component' => '4.2.2'
          vanagon_contents.each {|component, component_version|
            # set version_info[pe_version][component][component_verision] to os_list, but be conservative
            # in case there's something there already.
            this_pe_version_info[component] ||= {}
            this_pe_version_info[component][component_version] ||= []
            this_pe_version_info[component][component_version].concat(os_list)
          }
        }
      end

    end
  end
end
