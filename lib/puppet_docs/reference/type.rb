module PuppetDocs::Reference::Type
  require 'puppet'
  require 'puppet/util/docs'
  extend Puppet::Util::Docs
  # We use scrub().
  require 'erb'

  def build_page(typedocs)
    header = <<EOT
---
layout: default
title: "Type Reference"
canonical: "/references/latest/type.html"
munge_header_ids: false
---

EOT

    generated_at = "> **NOTE:** This page was generated from the Puppet source code on #{Time.now.to_s}"
    footer = generated_at
    preamble = <<EOT
#{generated_at}

## About Resource Types

- All types have a special attribute called the *namevar.* This is the attribute
  used to uniquely identify a type instance _on the target system._ If you don't
  specifically assign a value for the namevar, its value will default to the
  _title_ of the resource.

  In the following code:

      file { "/etc/passwd":
        owner => root,
        group => root,
        mode  => 644
      }

  `/etc/passwd` is considered the title of the file object (used for things like
  dependency handling), and because `path` is the namevar for `file`, that
  string is assigned to the `path` parameter.
- The *attributes* of a resource instance determine its desired state.  They
  either directly modify the system (internally, these are called "properties")
  or they affect how the instance behaves (e.g., adding a search path for `exec`
  instances or determining recursion on `file` instances).
- *Providers* implement the same resource type on different kinds of systems.
  They usually do this by calling out to external commands.

  Providers often specify binaries that they require. Fully qualified binary
  paths indicate that the binary must exist at that specific path, and
  unqualified paths indicate that Puppet will search for the binary using the
  shell path.
- *Features* are abilities that some providers might not support.  You can use
  the list of supported features to determine how a given provider can be used.

  Resource types define the set of features they can use, and providers can
  declare which features they provide.

----------------

EOT

    header + preamble +
      typedocs.keys.sort.collect{|name|
        docs_for_this_type(name, typedocs[name])
      }.join("\n\n---------\n\n") +
      footer
  end

  def build_json(typedocs)
    require 'json'
    JSON.dump(typedocs)
  end


  # The schema of the typedocs object:

  # { :name_of_type => {
  #     :description => 'Markdown fragment: description of type',
  #     :features    => { :feature_name => 'feature description', ... }
  #       # If there are no features, the value of :features will be an empty hash.
  #     :providers   => { # If there are no providers, the value of :providers will be an empty hash.
  #       :name_of_provider => {
  #         :description => 'Markdown fragment: docs for this provider',
  #         :features    => [:feature_name, :other_feature, ...]
  #           # If provider has no features, the value of :features will be an empty array.
  #       },
  #       ...etc...
  #     }
  #     :attributes  => { # Puppet dictates that there will ALWAYS be at least one attribute.
  #       :name_of_attribute => {
  #         :description => 'Markdown fragment: docs for this attribute',
  #         :kind        => (:property || :parameter),
  #         :namevar     => (true || false), # always false if :kind => :property
  #       },
  #       ...etc...
  #     },
  #   },
  #   ...etc...
  # }
  def get_typedocs # spit back the all-types object; this is the worker that interfaces w/ the puppet code.
    typedocs = {}

    Puppet::Type.loadall

    Puppet::Type.eachtype { |type|
      # List of types to ignore:
      next if type.name == :puppet
      next if type.name == :component
      next if type.name == :whit

      # Initialize the documentation object for this type
      docobject = {
        :description => scrub(type.doc),
        :attributes  => {}
      }

      # Handle features:
      # inject will return empty hash if type.features is empty.
      docobject[:features] = type.features.inject( {} ) { |allfeatures, name|
        allfeatures[name] = scrub( type.provider_feature(name).docs )
        allfeatures
      }

      # Handle providers:
      # inject will return empty hash if type.providers is empty.
      docobject[:providers] = type.providers.inject( {} ) { |allproviders, name|
        allproviders[name] = {
          :description => scrub( type.provider(name).doc ),
          :features    => type.provider(name).features
        }
        allproviders
      }

      # Override several features missing due to bug #18426:
      if type.name == :user
        docobject[:providers][:useradd][:features] << :manages_passwords << :manages_password_age << :libuser
      end
      if type.name == :group
        docobject[:providers][:groupadd][:features] << :libuser
      end


      # Handle properties:
      docobject[:attributes].merge!(
        type.validproperties.inject( {} ) { |allproperties, name|
          property = type.propertybyname(name)
          raise "Could not retrieve property #{propertyname} on type #{type.name}" unless property
          description = property.doc
          $stderr.puts "No docs for property #{name} of #{type.name}" unless description and !description.empty?

          allproperties[name] = {
            :description => scrub(description),
            :kind        => :property,
            :namevar     => false # Properties can't be namevars.
          }
          allproperties
        }
      )

      # Handle parameters:
      docobject[:attributes].merge!(
        type.parameters.inject( {} ) { |allparameters, name|
          description = type.paramdoc(name)
          $stderr.puts "No docs for parameter #{name} of #{type.name}" unless description and !description.empty?

          # Strip off the too-huge provider list. The question of what to do about
          # providers is a decision for the formatter, not the fragment collector.
          description = description.split('Available providers are')[0] if name == :provider

          allparameters[name] = {
            :description => scrub(description),
            :kind        => :parameter,
            :namevar     => type.key_attributes.include?(name) # returns a boolean
          }
          allparameters
        }
      )

      # Finally:
      typedocs[type.name] = docobject
    }

    typedocs
  end

  def docs_for_this_type(name, this_type)
    sorted_attribute_list = this_type[:attributes].keys.sort {|a,b|
      # Float namevar to top and ensure to second-top
      if this_type[:attributes][a][:namevar]
        -1
      elsif this_type[:attributes][b][:namevar]
        1
      elsif a == :ensure
        -1
      elsif b == :ensure
        1
      else
        a <=> b
      end
    }
    sorted_feature_list = this_type[:features].keys.sort
    longest_attribute_name = sorted_attribute_list.collect{|attr| attr.to_s.length}.sort.last

    ERB.new(File.read(File.dirname(__FILE__) + '/type_template.erb'), nil, '-').result(binding)
  end


  module_function :build_page
  module_function :build_json
  module_function :get_typedocs
  module_function :docs_for_this_type

end