require 'puppet_references'
require 'puppet_docs/versions'

module PuppetReferences
  module VersionTables
    class Agent1x < PuppetReferences::VersionTables::AgentTables
      def initialize(agent_data)
        super
        @file = '_agent1.x.html'
        @versions = PuppetDocs::Versions.sort_descending(
          @agent_data.keys.select{|v| v =~ /^1\./}
        )
      end
    end
  end
end