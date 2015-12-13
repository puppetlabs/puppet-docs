require 'puppet_references'
module PuppetReferences
  module Puppet
    module PuppetDoc
      REFERENCES = %w(configuration function indirection metaparameter report)
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'puppet'
      LATEST_DIR = '/references/latest'

      def self.build_all
        OUTPUT_DIR.mkpath
        REFERENCES.each do |ref|
          build_reference(ref)
        end
      end

      def self.make_header(reference)
        <<EOT
---
layout: default
title: "#{reference.capitalize} Reference"
canonical: "#{LATEST_DIR}/#{reference}.html"
---
EOT
      end

      def self.build_reference(reference)
        filename = OUTPUT_DIR + "#{reference}.md"
        raw_content = PuppetReferences::DocCommand.new(reference).get
        # Remove the first H1 with the title, like "# Metaparameter Reference"
        raw_content.sub!(/^# \w+ Reference *$/, '')
        if reference == 'configuration'
          clean_configuration_reference!(raw_content)
        end
        content = make_header(reference) + "\n\n" + raw_content
        filename.open('w') {|f| f.write(content)}
      end

      # Remove any references to a real system's hostname.
      def self.clean_configuration_reference!(text)
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


