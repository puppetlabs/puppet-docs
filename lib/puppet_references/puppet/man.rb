require 'puppet_references'
module PuppetReferences
  module Puppet
    class Man < PuppetReferences::Reference
      OUTPUT_DIR = PuppetReferences::OUTPUT_DIR + 'puppet/man'

      def initialize(*args)
        @latest = '/puppet/latest/reference/man'
        super(*args)
      end

      def build_all
        OUTPUT_DIR.mkpath
        commands = get_subcommands
        puts 'Man pages: Building all...'
        build_index(commands)
        commands.each do |command|
          build_manpage(command)
        end
        puts 'Man pages: Done!'
      end

      def build_index(commands)
        puts 'Man pages: Building index page'
        # Categorize subcommands
        categories = {
            core: %w(
          agent
          apply
          cert
          master
          module
          resource
          lookup
        ),
            occasional: %w(
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
        ),
            weird: %w(
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
        }
        all_in_categories = categories.values.flatten
        # Don't let new commands drop off into The Nothing:
        leftovers = commands - all_in_categories
        # Clean up any commands that don't exist in this version of Puppet:
        categories.values.each do |list|
          list.reject! {|sub| !commands.include?(sub)}
        end
        header_data = {title: 'Puppet Man Pages',
                       nav: '/_includes/references_man.html',
                       canonical: "#{@latest}/index.html"}
        index_text = <<EOT
#{ make_header(header_data) }

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
        unless leftovers.empty?
          index_text << <<EOADDENDUM
Unknown or New Subcommands
-----

These subcommands have not yet been added to any of the categories above.

#{ leftovers.reduce('') {|memo, item| memo << "- [puppet #{item}](./#{item}.html)\n"} }
EOADDENDUM
        end
        # write index
        filename = OUTPUT_DIR + 'index.html'
        filename.open('w') {|f| f.write(index_text)}
      end

      def get_subcommands
        application_files = Pathname.glob(PuppetReferences::PUPPET_DIR + 'lib/puppet/application/*.rb')
        applications = application_files.map {|f| f.basename('.rb').to_s}
        applications.delete('face_base')
        applications.delete('indirection_base')
        applications
      end

      def render_with_ronn(raw_text)
        rendered_html = ''
        Dir.chdir(PuppetReferences::BASE_DIR) do
          ronn = IO.popen("bundle exec ronn --pipe -f", "r+")
          ronn.write(raw_text)
          ronn.close_write
          rendered_html = ronn.read
          ronn.close
        end
        rendered_html
      end

      def build_manpage(subcommand)
        puts "Man pages: Building #{subcommand}"
        header_data = {title: "Man Page: puppet #{subcommand}",
                       nav: '/_includes/references_man.html',
                       canonical: "#{@latest}/#{subcommand}.html"}
        raw_text = PuppetReferences::ManCommand.new(subcommand).get
        content = make_header(header_data) + render_with_ronn(raw_text)
        filename = OUTPUT_DIR + "#{subcommand}.md"
        filename.open('w') {|f| f.write(content)}
      end
    end
  end
end