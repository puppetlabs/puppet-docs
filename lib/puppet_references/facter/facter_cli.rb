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


      def header_data
        {title: 'Facter: CLI',
         toc: 'columns',
         canonical: "#{@latest}/cli.html"}
      end


      def build_all
        require 'open3'
        puts 'Building CLI documentation page for facter.'
        OUTPUT_DIR.mkpath
        Bundler.with_unbundled_env do
          Open3.capture3("BUNDLE_GEMFILE=#{PuppetReferences::FACTER_DIR}/Gemfile bundle update")
        end
        raw_text, err, exit_code = Open3.capture3("BUNDLE_GEMFILE=#{PuppetReferences::FACTER_DIR}/Gemfile bundle exec facter man")
        if exit_code != 0
          puts "Encountered an error while building the facter cli docs, will abort: #{err}"
          return
        end
        content = make_header(header_data) + PREAMBLE + 
          raw_text.gsub(/SYNOPSIS\n--------\n\s\s(.*?)$/, "SYNOPSIS\n--------\n" + "\s\s\s\s" + '\1')
        filename = OUTPUT_DIR + 'cli.md'
        filename.open('w') {|f| f.write(content)}
        puts 'CLI documentation is done!'
      end

      def build_v3_cli
        OUTPUT_DIR.mkpath
        filename = OUTPUT_DIR + 'cli.md'
        man_filepath = PuppetReferences::FACTER_DIR + 'man/man8/facter.8'
        raw_text = PuppetReferences::Util.convert_man(man_filepath)
        content = make_header(header_data) + raw_text
        filename.open('w') {|f| f.write(content)}
      end 

    end 
  end
end
