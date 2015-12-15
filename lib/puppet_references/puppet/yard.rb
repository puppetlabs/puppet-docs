require 'puppet_references'
module PuppetReferences
  module Puppet
    class Yard < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'yard'

      def build_all
        PuppetReferences::PuppetCommand.new("yard -o #{OUTPUT_DIR}").get
      end
    end
  end
end
