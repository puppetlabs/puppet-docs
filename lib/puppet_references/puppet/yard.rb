require 'puppet_references'
module PuppetReferences
  module Puppet
    class Yard < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'yard'

      def initialize(*args)
        @latest = '/references/latest/developer'
        super(*args)
      end

      def build_all
        puts 'Building YARD references, which always takes a while...'
        PuppetReferences::PuppetCommand.new("yard -o #{OUTPUT_DIR}").get
        puts 'Done with YARD!'
      end
    end
  end
end
