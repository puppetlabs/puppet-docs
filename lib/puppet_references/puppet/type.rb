require 'puppet_references'
require 'json'
require 'erb'

module PuppetReferences
  module Puppet
    module Type
      TYPEDOCS_SCRIPT = PuppetReferences::BASE_DIR + 'lib/puppet_references/quarantine/get_typedocs.rb'
      TEMPLATE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'type_template.erb'
      TEMPLATE = ERB.new(TEMPLATE_FILE.read, nil, '-')
      OUTPUT_DIR_UNIFIED = PuppetReferences::OUTPUT_DIR + 'puppet'
      OUTPUT_DIR_INDIVIDUAL = PuppetReferences::OUTPUT_DIR + 'puppet/types'
      LATEST_DIR = '/references/latest'
      PREAMBLE = <<EOT
## About Resource Types

### Built-in Types and Custom Types

This is the documentation for the _built-in_ resource types and providers, keyed
to a specific Puppet version. (See sidebar.) Additional resource types can be
distributed in Puppet modules; you can find and install modules by browsing the
[Puppet Forge](http://forge.puppetlabs.com). See each module's documentation for
information on how to use its custom resource types.

### Declaring Resources

To manage resources on a target system, you should declare them in Puppet
manifests. For more details, see
[the resources page of the Puppet language reference.](/puppet/latest/reference/lang_resources.html)

You can also browse and manage resources interactively using the
`puppet resource` subcommand; run `puppet resource --help` for more information.

### Namevars and Titles

All types have a special attribute called the *namevar.* This is the attribute
used to uniquely identify a resource _on the target system._ If you don't
specifically assign a value for the namevar, its value will default to the
_title_ of the resource.

Example:

    file { '/etc/passwd':
      owner => root,
      group => root,
      mode  => 644
    }

In this code, `/etc/passwd` is the _title_ of the file resource; other Puppet
code can refer to the resource as `File['/etc/passwd']` to declare
relationships. Because `path` is the namevar for the file type and we did not
provide a value for it, the value of `path` will default to `/etc/passwd`.

### Attributes, Parameters, Properties

The *attributes* (sometimes called *parameters*) of a resource determine its
desired state.  They either directly modify the system (internally, these are
called "properties") or they affect how the resource behaves (e.g., adding a
search path for `exec` resources or controlling directory recursion on `file`
resources).

### Providers

*Providers* implement the same resource type on different kinds of systems.
They usually do this by calling out to external commands.

Although Puppet will automatically select an appropriate default provider, you
can override the default with the `provider` attribute. (For example, `package`
resources on Red Hat systems default to the `yum` provider, but you can specify
`provider => gem` to install Ruby libraries with the `gem` command.)

Providers often specify binaries that they require. Fully qualified binary
paths indicate that the binary must exist at that specific path, and
unqualified paths indicate that Puppet will search for the binary using the
shell path.

### Features

*Features* are abilities that some providers may not support. Generally, a
feature will correspond to some allowed values for a resource attribute; for
example, if a `package` provider supports the `purgeable` feature, you can
specify `ensure => purged` to delete config files installed by the package.

Resource types define the set of features they can use, and providers can
declare which features they provide.

----------------

EOT

      def self.build_all
        puts 'Type ref: Building all'
        type_json = get_type_json
        type_data = JSON.load(type_json)

        write_json_file(type_json)
        build_index(type_data.keys.sort)
        build_unified_page(type_data)
        type_data.each do |name, data|
          build_page(name, data)
        end
        puts 'Type ref: Done!'
      end

      def self.build_index(names)
        header_data = {layout: 'default',
                       title: 'Resource Types: Index',
                       canonical: "#{LATEST_DIR}/types/index.html"}
        links = names.map {|name|
          "* [#{name}](./#{name}.html)"
        }
        content = PuppetReferences::Util.make_header(header_data) + "## List of Resource Types\n\n" + links.join("\n") + "\n\n" + PREAMBLE
        filename = OUTPUT_DIR_INDIVIDUAL + 'index.md'
        filename.open('w') {|f| f.write(content)}
      end

      def self.get_type_json
        puts "Type ref: Getting JSON data"
        PuppetReferences::PuppetCommand.new("ruby #{TYPEDOCS_SCRIPT}").get
      end

      def self.build_unified_page(typedocs)
        puts "Type ref: Building unified page"
        header_data = {layout: 'default',
                       title: 'Resource Type Reference (Single-Page)',
                       canonical: "#{LATEST_DIR}/type.html",
                       toc: 'columns'}
        generated_at = "> **NOTE:** This page was generated from the Puppet source code on #{Time.now.to_s}"

        sorted_type_list = typedocs.keys.sort
        all_type_docs = sorted_type_list.collect{|name|
          text_for_type(name, typedocs[name])
        }.join("\n\n---------\n\n")

        content = PuppetReferences::Util.make_header(header_data) + generated_at + "\n\n" + PREAMBLE + all_type_docs + "\n\n" + generated_at
        filename = OUTPUT_DIR_UNIFIED + 'type.md'
        filename.open('w') {|f| f.write(content)}
      end

      def self.write_json_file(json)
        puts 'Type ref: Writing JSON as file'
        filename = OUTPUT_DIR_UNIFIED + 'type.json'
        filename.open('w') {|f| f.write(json)}
      end

      def self.build_page(name, data)
        puts "Type ref: Building #{name}"
        header_data = {layout: 'default',
                       title: "Resource Type: #{name}",
                       canonical: "#{LATEST_DIR}/types/#{name}.html"}
        generated_at = "> **NOTE:** This page was generated from the Puppet source code on #{Time.now.to_s}"
        content = PuppetReferences::Util.make_header(header_data) + generated_at + "\n\n" + text_for_type(name, data) + "\n\n" + generated_at
        filename = OUTPUT_DIR_INDIVIDUAL + "#{name}.md"
        filename.open('w') {|f| f.write(content)}
      end

      def self.text_for_type(name, this_type)
        sorted_attribute_list = this_type['attributes'].keys.sort {|a,b|
          # Float namevar to top and ensure to second-top
          if this_type['attributes'][a]['namevar']
            -1
          elsif this_type['attributes'][b]['namevar']
            1
          elsif a == 'ensure'
            -1
          elsif b == 'ensure'
            1
          else
            a <=> b
          end
        }
        sorted_feature_list = this_type['features'].keys.sort
        longest_attribute_name = sorted_attribute_list.collect{|attr| attr.length}.max

        # template uses: name, this_type, sorted_attribute_list, sorted_feature_list, longest_attribute_name
        TEMPLATE.result(binding)
      end

    end
  end
end
