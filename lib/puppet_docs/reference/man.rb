module PuppetDocs
  module Reference
    module Man
      require 'pathname'
      require 'fileutils'

      # This implements man page building for puppet versions.
      def self.write_manpages(puppet_dir, destination_dir)
        Dir.mkdir(destination_dir) unless File.directory?(destination_dir)

        # Note that there's no index.
        applications = Dir.glob(%Q{#{puppet_dir}/lib/puppet/application/*}).collect{ |app_file|
          app_file.sub(/^#{puppet_dir}\/lib\/puppet\/application\/([\w_]+)\.rb$/, '\1')
        }
        require 'puppet/face' # works because rubylib is already munged???
        # All four lines below are terrible. See puppet/tasks/manpages.rake for details.
        Puppet.initialize_settings()
        helpface = Puppet::Face[:help, '0.0.1']
        manface  = Puppet::Face[:man, '0.0.1']

        non_face_applications = helpface.legacy_applications
        faces = Puppet::Face.faces
        faces.delete(:resource)

        # Dump the application names to a file
#         Dir.chdir(destination_dir) do
#           File.open("./this_would_be_the_man_page.txt", 'w') {|f| f.puts non_face_applications.join(', '); f.puts faces.join(', ')}
#         end

        man_strings = {}


        # Generate and cache all man strings (raw with no header, etc.)
        non_face_applications.each do |app|
          # RUBYLIB is already cleaned out and initialized in the Generator#generate method.
          man_strings[app] = %x{ruby #{puppet_dir}/bin/puppet #{app} --help}
        end
        faces.each do |face|
          man_strings[face] = manface.man("#{face}")
        end

        # Write files
        man_strings.each do |name, man_string|
          headerstring = "---\nlayout: default\nnav: /_includes/references_man.html\ntitle: puppet #{name} Man Page\n---\n\n"

          ronn = IO.popen("bundle exec ronn --pipe -f", "r+")
          ronn.write(man_string)
          ronn.close_write
          processed_man_string = ronn.read
          ronn.close

          File.open("#{destination_dir}/#{name}.markdown", 'w') do |file|
            file.puts("#{headerstring}#{processed_man_string}")
          end
        end

        # Categorize subcommands
        categories = {}
        categories[:core] = %w(
          agent
          apply
          cert
          master
          module
          resource
        )
        categories[:occasional] = %w(
          config
          describe
          device
          doc
          epp
          help
          man
          node
          parser
          plugin
        )
        categories[:weird] = %w(
          ca
          catalog
          certificate
          certificate_request
          certificate_revocation_list
          facts
          file
          filebucket
          inspect
          key
          report
          resource_type
          status
        )
        all_in_categories = categories.reduce( [] ) {|total, (cat, items)| total = total + items}
        all_in_source = non_face_applications + faces.collect{|sym| sym.to_s}
        # Don't let new commands drop off into The Nothing:
        leftovers = all_in_source - all_in_categories
        # Clean up any commands that don't exist in this version of Puppet:
        categories.values.each do |list|
          list.reject! {|sub| !all_in_source.include?(sub)}
        end

        index_text = <<EOT
---
title: Puppet Man Pages
layout: default
nav: references_man.html
---

Puppet's command line tools consist of a single `puppet` binary with many subcommands. The following subcommands are available in this version of Puppet:

Core Tools
-----

These subcommands form the core of Puppet's tool set, and every user should understand what they do.

#{ categories[:core].reduce('') {|memo, item| memo << "- [puppet #{item}](./#{item}.html)\n"} }

Occasionally Useful Subcommands
-----

Many or most users will need to use these subcommands at some point, but they aren't needed for daily use the way the core tools are.

#{ categories[:occasional].reduce('') {|memo, item| memo << "- [puppet #{item}](./#{item}.html)\n"} }

Niche Subcommands
-----

Most users can ignore these subcommands. They're only useful for certain niche workflows, and most of them are interfaces to Puppet's internal subsystems.

#{ categories[:weird].reduce('') {|memo, item| memo << "- [puppet #{item}](./#{item}.html)\n"} }

EOT
        # Handle any leftovers that aren't in categories
        if !leftovers.empty?
          index_text << <<EOADDENDUM
Unknown or New Subcommands
-----

These subcommands have not yet been added to any of the categories above.

#{ leftovers.reduce('') {|memo, item| memo << "- [puppet #{item}](./#{item}.html)\n"} }
EOADDENDUM
        end
        # write index
        File.open("#{destination_dir}/index.markdown", 'w') do |file|
          file.puts(index_text)
        end

      end # self.write_manpages
    end
  end
end
