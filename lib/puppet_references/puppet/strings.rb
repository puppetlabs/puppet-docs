require 'puppet_references'
require 'json'

module PuppetReferences
  module Puppet
    class Strings < Hash
      STRINGS_JSON_FILE = PuppetReferences::OUTPUT_DIR + 'puppet/strings.json'
      @@strings_data_cached = false

      def initialize
        super()
        unless @@strings_data_cached
          generate_strings_data
        end
        self.merge!(JSON.load(File.read(STRINGS_JSON_FILE)))
        # We can't keep the actual data hash in an instance variable, because if you duplicate the main hash, all its
        # deeply nested members will be assigned by reference to the new hash, and you'll get leakage across objects.
      end

      def generate_strings_data
        puts 'Generating Puppet Strings JSON data...'
        rubyfiles = Dir.glob("#{PuppetReferences::PUPPET_DIR}/lib/puppet/**/*.rb")
        system("bundle exec puppet strings generate --emit-json #{STRINGS_JSON_FILE} #{rubyfiles.join(' ')}")
        puts "Strings data: Done! (#{STRINGS_JSON_FILE})"
        @@strings_data_cached = true
      end
    end
  end
end