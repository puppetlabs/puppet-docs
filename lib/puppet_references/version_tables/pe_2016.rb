require 'puppet_references'
module PuppetReferences
  module VersionTables
    class Pe2016 < PuppetReferences::VersionTables::PeTables
      def initialize(pe_data, agent_data = nil)
        super
        @file = '_versions_2016.md'
        @versions = @pe_data.keys.select {|v|
          v =~ /^2016/
        }.sort.reverse
      end
    end
  end
end

