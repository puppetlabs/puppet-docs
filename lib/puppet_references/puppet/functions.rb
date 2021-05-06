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
        @latest = '/puppet/latest'
        super(*args)
      end

      def build_all
        build_variant('function.md')
      end

      def build_variant(filename, preferred_version = 'ruby4x')
        OUTPUT_DIR.mkpath
        puts "Functions ref (#{filename}): Building"
        strings_data = PuppetReferences::Puppet::Strings.new
        functions = strings_data['puppet_functions']
        header_data = {title: 'Built-in function reference',
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
        # BTW, I learned this trick from the Facter reference that the agent team made for us back in the day.
        template_binding = OpenStruct.new({ functions: functions }).instance_eval {binding}

        body = ERB.new(File.read(TEMPLATE_FILE), nil, '-').result(template_binding)
        # This substitution could potentially make things a bit brittle, but it has to be done because the jump
        # From H2s to H4s is causing issues with the DITA-OT, which sees this as a rule violation. If it 
        # Does become an issue, we should return to this and figure out a better way to generate the functions doc.  
        content = make_header(header_data) + "\n\n" + PREAMBLE + "\n\n" + body.gsub(/#####\s(.*?:)/,'**\1**').gsub(/####\s/,'###\s')
        output_path = OUTPUT_DIR + filename
        output_path.open('w') {|f| f.write(content)}
        puts "Functions ref (#{filename}): Done!"
      end
    end
  end
end
