require 'puppet_references'
module PuppetReferences
  module VersionTables
    class PeLate3 < PuppetReferences::VersionTables::PeTables
      def initialize(pe_data, agent_data = {})
        super
        @server_stuff << 'Apache'
        @server_stuff << 'LibAPR'
        @server_stuff << 'Passenger'
        @server_stuff.delete('Nginx')
        @agent_stuff.delete('Puppet Agent')

        @file = '_versions_late_3.x.md'
        @versions = @pe_data.keys.select {|v|
          v =~ /^3\.[78]/
        }.sort.reverse
      end
    end
  end
end

