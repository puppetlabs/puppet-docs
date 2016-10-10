require 'puppet_references'
require 'json'

module PuppetReferences
  module Puppet
    class Strings < Hash
      STRINGS_JSON_FILE = PuppetReferences::OUTPUT_DIR + 'puppet/strings.json'
      @@strings_data = nil

      def initialize
        super()
        unless @@strings_data
          generate_strings_data
        end
        self.merge!(@@strings_data)
      end

      def generate_strings_data
        puts 'Generating Puppet Strings JSON data...'
        system("bundle exec puppet strings generate --emit-json #{STRINGS_JSON_FILE} #{PuppetReferences::PUPPET_DIR}/lib/puppet/**/*.rb")
        puts "Strings data: Done! (#{STRINGS_JSON_FILE})"
        @@strings_data = JSON.load(File.read(STRINGS_JSON_FILE))
      end
    end
  end
end