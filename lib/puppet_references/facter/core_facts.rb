require 'puppet_references'
module PuppetReferences
  module Facter
    class CoreFacts < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'facter'
      PREAMBLE_FILE = Pathname.new(__FILE__).dirname + 'core_facts_preamble.md'
      PREAMBLE = PREAMBLE_FILE.read

      def initialize(*args)
        @latest = '/facter/latest'
        super(*args)
      end

      def build_all
        puts 'Core facts: building reference.'
        OUTPUT_DIR.mkpath
        raw_text = `ruby #{PuppetReferences::FACTER_DIR}/lib/docs/generate.rb`
        header_data = {title: 'Facter: Core Facts',
                       toc: 'columns',
                       canonical: "#{@latest}/core_facts.html"}
        content = make_header(header_data) + PREAMBLE + raw_text
        filename = OUTPUT_DIR + 'core_facts.md'
        filename.open('w') {|f| f.write(content)}
        puts 'Core facts: done!'
      end

    end
  end
end