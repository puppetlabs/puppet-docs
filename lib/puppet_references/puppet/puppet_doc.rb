require 'puppet_references'
module PuppetReferences
  module Puppet
    class PuppetDoc < PuppetReferences::Reference
      REFERENCES = %w(configuration function indirection metaparameter report)
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'puppet'
      LATEST_DIR = '/references/latest'

      def build_all
        OUTPUT_DIR.mkpath
        puts 'Oldskool refs: Building all...'
        REFERENCES.each do |ref|
          build_reference(ref)
        end
        puts 'Oldskool refs: Done!'
      end

      def build_reference(reference)
        puts "Oldskool refs: Building #{reference} reference"
        raw_content = PuppetReferences::DocCommand.new(reference).get
        # Remove the first H1 with the title, like "# Metaparameter Reference"
        raw_content.sub!(/^# \w+ Reference *$/, '')
        if reference == 'configuration'
          clean_configuration_reference!(raw_content)
        end
        header_data = {title: "#{reference.capitalize} Reference",
                       canonical: "#{LATEST_DIR}/#{reference}.html"}
        content = make_header(header_data) + raw_content
        filename = OUTPUT_DIR + "#{reference}.md"
        filename.open('w') {|f| f.write(content)}
      end

      # Remove any references to a real system's hostname.
      def clean_configuration_reference!(text)
        # Assume we aren't on Solaris or AIX, where this might set the hostname to "-f" D:
        fqdn = `hostname -f`.strip
        domain = fqdn.partition('.')[2]
        text.gsub!(fqdn.downcase, "(the system's fully qualified domain name)")
        # This is yuck to deal with when the domain name is "local," like a Mac on a DNS-less network.
        # Will have to be very specific, which makes it kind of brittle.
        if domain != ''
          text.gsub!("- *Default*: #{domain.downcase}\n", "- *Default*: (the system's own domain)\n")
        end
      end
    end
  end
end


