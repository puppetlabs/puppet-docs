require 'puppet_references'

module PuppetReferences
  module VersionTables
    class Agent1x < PuppetReferences::VersionTables::AgentTables
      def initialize(agent_data)
        super
        @file = '_agent1.x.html'
        @versions = @agent_data.keys.select{|v| v =~ /^1\./}.sort.reverse
      end
    end
  end
end