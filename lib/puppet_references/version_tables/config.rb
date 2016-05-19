require 'yaml'
module PuppetReferences
  module VersionTables
    class Config
      def self.read
        YAML.load(File.read(File.join(File.dirname(__FILE__), 'config.yaml')))
      end
    end
  end
end
