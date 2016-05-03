require 'puppet_references'
module PuppetReferences
  module VersionTables
    class PeEarly3 < PuppetReferences::VersionTables::PeTables
      def initialize(pe_data, agent_data = {})
        super
        @server_stuff << 'Apache'
        @server_stuff << 'LibAPR'
        @server_stuff << 'Passenger'
        @server_stuff.delete('Puppet Server')
        @server_stuff.delete('Nginx')
        @server_stuff.delete('r10k')
        @agent_stuff.delete('Puppet Agent')

        @file = '_versions_early_3.x.md'
        @versions = [
            '3.3.2',
            '3.3.1',
            '3.3.0',
            '3.2.3',
            '3.2.2',
            '3.2.1',
            '3.2.0'
        ]
      end
    end
  end
end

