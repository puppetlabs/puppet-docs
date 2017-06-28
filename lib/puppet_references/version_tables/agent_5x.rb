require 'puppet_references'

module PuppetReferences
  module VersionTables
    class Agent2x < PuppetReferences::VersionTables::AgentTables
      def initialize(agent_data)
        super
        @file = '_agent5.x.html'
        @versions = @agent_data.keys.select{|v| v =~ /^5\./}.sort.reverse
      end
    end
  end
end