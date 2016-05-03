require 'puppet_references'
module PuppetReferences
  module VersionTables
    class Pe2015 < PuppetReferences::VersionTables::PeTables
      def initialize(pe_data, agent_data = nil)
        super
        @server_stuff.delete('Apache')
        @server_stuff.delete('LibAPR')
        @server_stuff.delete('Passenger')
        @file = '_versions_2015.md'
        @versions = @pe_data.keys.select {|v|
          v =~ /^2015/
        }.sort.reverse
      end
    end
  end
end

