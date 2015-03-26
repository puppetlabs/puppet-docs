module PuppetDocs

  module Reference

    # Find the special versions that should be symlinked
    def self.special_versions
      listing = {}
      listing[:stable] = generated_versions.detect { |v, dir| v.release_type == :final }
      listing[:latest] = generated_versions.first
      # This looks super hairy, so here's the deal: We have an array of
      # arrays, w/ each internal array containing a Versionomy::Value object and
      # a directory. Whole thing is sorted by the versionomy objects in
      # descending order. Since it's sorted descending, we are guaranteed that:
      #
      # * Every time we see a NEW major.minor value of the version objects,
      #   we're looking at the latest reference from that particular major.minor
      #   series.
      # * Every time we see a NEW major value, we're looking at the latest
      #   reference from that particular major series.
      #
      # So we'll just compare against the previous for both of those, and add
      # each detected new version. This gives us self-maintaining 2.latest,
      # 2.7.latest, etc. links, which is rad.
      #
      # Stable sub-versions are a little trickier. We'll say that moving to a
      # new version series "destabilizes" that type of series. If we're in a
      # destabilized series, we always check to see if it's a final release (not
      # an RC or beta); if it is, we set the stable version, and stabilize. This
      # means we catch the FIRST final release in each series.
      prev_maj_min = "0.0"
      prev_maj     = "0"
      stabilized_maj_min = false
      stabilized_maj     = false
      generated_versions.each do |ver_dir_pair|
        v = ver_dir_pair[0]
        maj_min = "#{v.major}.#{v.minor}"
        maj = "#{v.major}"
        # Handle latest versions, inc. RCs and betas
        if maj_min != prev_maj_min
          listing["#{maj_min}.latest"] = ver_dir_pair
          prev_maj_min = maj_min
          stabilized_maj_min = false
        end
        if maj != prev_maj
          listing["#{maj}.latest"] = ver_dir_pair
          prev_maj = maj
          stabilized_maj = false
        end
        # Handle stable versions
        if !stabilized_maj_min and v.release_type == :final
          listing["#{maj_min}.stable"] = ver_dir_pair
          stabilized_maj_min = true
        end
        if !stabilized_maj and v.release_type == :final
          listing["#{maj}.stable"] = ver_dir_pair
          stabilized_maj = true
        end
      end
      listing
    end

    # A sorted array of [version, path] for non-symlinked version paths
    def self.generated_versions #:nodoc:
      return @generated_versions if @generated_versions
      possibles = generated_version_directories.map do |path|
        [Versionomy.parse(path.basename.to_s), path]
      end
      @generated_versions = possibles.sort_by { |x| x.first }.reverse
    end

    # The valid, non-symlinked version paths
    def self.generated_version_directories #:nodoc:
      children = (PuppetDocs.root + "source/references").children
      possibles = children.select do |child|
        child.directory? && !child.symlink?
      end
    end

    class Generator

      def initialize(tag, name, commit = nil)
        @tag = tag
        @name = name
        @commit = commit
        @real_commit = @commit || @tag
        setup_repository!
        validate!
        checkout_puppet!
      end

      def generate
        # Expect that we're running under bundler, and preserve its prepend to $RUBYLIB:
        old_rubylib = ENV['RUBYLIB']
        ENV['RUBYLIB'] = old_rubylib.split(':')[0] << ":#{facter_dir}/lib:#{hiera_dir}/lib:#{puppet_dir}/lib"

        puts "Generating #{@name} reference for #{version}."

        # Handle special references
        if @name == "developer"
          Dir.chdir(puppet_dir)
          puts "(YARD documentation takes a while to generate.)"
          `bundle exec yard -o #{yard_directory}`
          return
        end
        if @name == "man"
          require 'puppet_docs/reference/man'
          # gotta pass in the puppet dir and the destination dir
          PuppetDocs::Reference::Man.write_manpages(puppet_dir, man_directory)
          return
        end
        if @name == "type"
          require 'puppet_docs/reference/type'
          # Get structured data (as JSON) from a subshell with cleaned RUBYLIB:
          typejson = `ruby #{File.dirname(__FILE__) + '/quarantine/get_typedocs.rb'}`
          # Use json to build content; this gets written to disk later
          content  = PuppetDocs::Reference::Type.build_page(typejson)
          # Write json to disk now
          setup_destination!
          File.open(destination_directory + 'type.json', 'w') { |f| f.write typejson }
          puts "Wrote #{destination_directory}/type.json"
        else
          raw_content = `ruby #{puppet_dir}/bin/puppet doc --modulepath /tmp/nothing --libdir /tmp/alsonothing -m text -r #{@name}`
          title = /\# (.*)\n/.match(raw_content)[1]
          header = <<EOT
---
layout: default
title: "#{title}"
canonical: "/references/latest/#{@name}.html"
---
EOT
          content = header + "\n\n" + raw_content
        end


        if content
          if @name == "configuration" # then get any references to the laptop's hostname out of there
            require 'facter'
            hostname = Facter["hostname"].value
            domain = Facter["domain"].value
            if domain and domain != ""
              fqdn = [hostname, domain].join(".")
            else
              fqdn = hostname
            end
            content.gsub!(fqdn.downcase, "(the system's fully qualified domain name)")
            # Yuck, this next one is hard to deal with when the domain is "local," like a Mac on a DNS-less network. Will have to be very specific, which makes it kind of brittle.
            content.gsub!("- *Default*: #{domain.downcase}\n", "- *Default*: (the system's own domain)\n")
          end

          setup_destination!
          File.open(destination_filename, 'w') { |f| f.write content }
          puts "Wrote #{destination_filename}"
         else
          abort "Could not build #{@name} reference using puppetdoc at #{version}"
        end
      end

      private

      def valid_tags
        %x{git fetch --tags origin}
        @valid_tags ||= at('master') { `git tag` }.each_line.map { |s| s.strip }
      end

      def version
        @version ||=
          at @real_commit do
            raw = `ruby  -rpuppet -e 'puts Puppet::PUPPETVERSION'`.strip
            Versionomy.parse(raw)
          end
      end

      def validate!
        if !valid_tags.include?(@tag)
          abort "Invalid puppet tag: #{@tag}, and explicit commit not provided" if @commit.nil?
        end
      end

      def at(ref, &block)
        Dir.chdir(puppet_dir) do
          %x{git checkout --force #{ref} && git clean --force}
          if $?.success?
            yield if block_given?
          else
            abort "Could not switch to '#{ref}'"
          end
        end
      end

      def puppet_dir
        PuppetDocs.root + 'vendor/puppet'
      end

      def hiera_dir
        PuppetDocs.root + 'vendor/hiera'
      end

      def facter_dir
        PuppetDocs.root + 'vendor/facter'
      end


      def setup_repository!

        if File.directory?(puppet_dir)
          Dir.chdir(puppet_dir) do
            %x{git fetch origin}
          end
        else
          puts "Retrieving puppet source."
          %x{git clone git://github.com/puppetlabs/puppet.git '#{puppet_dir}'}
        end

        if File.directory?(facter_dir)
          Dir.chdir(facter_dir) do
            %x{git fetch origin && git checkout --force origin/2.x && git clean --force}
          end
        else
          puts "Retrieving facter source."
          %x{git clone git://github.com/puppetlabs/facter.git '#{facter_dir}'}
        end

        if File.directory?(hiera_dir)
          Dir.chdir(hiera_dir) do
            %x{git fetch origin && git checkout --force origin/master && git clean --force}
          end
        else
          puts "Retrieving hiera source."
          %x{git clone git://github.com/puppetlabs/hiera.git '#{hiera_dir}'}
        end

      end

      def checkout_puppet!
        at @real_commit
      end

      def destination_filename
        @destination_filename ||= destination_directory + (@name + ".markdown")
      end

      def destination_directory
        @destination_directory ||= PuppetDocs.root + "source/references" + @tag
      end

      def yard_directory
        @yard_directory ||= destination_directory + "developer"
      end

      def man_directory
        @yard_directory ||= destination_directory + "man"
      end

      def setup_destination!
        destination_directory.mkpath
      end

    end

  end

end
