require 'puppet_references'
require 'json'
require 'erb'
require 'ostruct'
require 'pathname'

module PuppetReferences
  module Puppet
    class Functions < PuppetReferences::Reference
      TEMPLATE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'functions_template.erb'
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'puppet'
      PREAMBLE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'functions_preamble.md'
      PREAMBLE = PREAMBLE_FILE.read

      def initialize(*args)
        @latest = '/puppet/latest/reference'
        super(*args)
      end

      def build_all
        build_variant('function_strings_prefer_v3.md', 'ruby3x')
        build_variant('function_strings_prefer_v4.md')
      end

      def build_variant(filename, preferred_version = 'ruby4x')
        OUTPUT_DIR.mkpath
        puts "Functions ref (#{filename}): Building"
        strings_data = PuppetReferences::Puppet::Strings.new
        functions = strings_data['puppet_functions']
        generated_at = "> **NOTE:** This page was generated from the Puppet source code on #{Time.now.to_s}"
        header_data = {title: 'List of built-in functions',
                       canonical: "#{@latest}/function.html",
                       toc_levels: 2,
                       toc: 'columns'}

        # Deal with the duplicate function stub situation.
        # 1. Figure out which functions are duplicated.
        names = functions.map {|func| func['name']}
        duplicates = names.uniq.select {|name| names.count(name) > 1}
        # 2. Reject the unpreferred version of any dupes.
        functions = functions.reject {|func|
          duplicates.include?(func['name']) && func['type'] != preferred_version
        }

        # Make a limited binding object that only has one variable, so the template doesn't have access to the current scope.
        template_binding = OpenStruct.new({ functions: functions }).instance_eval {binding}

        body = ERB.new(File.read(TEMPLATE_FILE), nil, '-').result(template_binding)
        content = make_header(header_data) + generated_at + "\n\n" + PREAMBLE + "\n\n" + body + generated_at
        output_path = OUTPUT_DIR + filename
        output_path.open('w') {|f| f.write(content)}
        puts "Functions ref (#{filename}): Done!"
      end
    end
  end
end

