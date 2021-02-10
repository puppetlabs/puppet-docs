require 'puppet_references'
module PuppetReferences
  module Facter
    class FacterCli < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'facter'
      PREAMBLE_FILE = Pathname.new(__FILE__).dirname + 'facter_cli_preamble.md'
      PREAMBLE = PREAMBLE_FILE.read

      def initialize(*args)
        @latest = '/puppet/latest'
        super(*args)
      end

      def build_all
        require 'open3'
        puts 'Building CLI documentation page for facter.'
        OUTPUT_DIR.mkpath
        raw_text, err, exit_code = Open3.capture3("ruby #{PuppetReferences::FACTER_DIR}/lib/docs/generate_cli.rb")
        if exit_code != 0
          puts "Encountered an error while building the facter cli docs, will abort: #{err}"
          return
        end

        header_data = {title: 'Facter: CLI',
                       toc: 'columns',
                       canonical: "#{@latest}/cli.html"}
        content = make_header(header_data) + PREAMBLE + raw_text
        filename = OUTPUT_DIR + 'cli.md'
        filename.open('w') {|f| f.write(content)}
        puts 'CLI documentation is done!'
      end
    end
  end
end