require 'puppet_references'
module PuppetReferences
  module Puppet
    module Yard
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'yard'

      def self.build_all
        PuppetReferences::PuppetCommand.new("yard -o #{OUTPUT_DIR}").get
      end
    end
  end
end
