module PuppetDocs

  module Reference

    # Find the special versions that should be symlinked
    def self.special_versions
      listing = {}
      listing[:stable] = generated_versions.detect { |v, dir| v.release_type == :final }
      listing[:latest] = generated_versions.first
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

      def initialize(tag, name)
        @tag = tag
        @name = name
        setup_repository!
        validate!
        change_to_tag!
      end

      def generate
        puts "Generating #{@name} reference for #{version}."
        content = `ruby -I#{puppet_dir}/lib #{puppet_dir}/bin/puppet doc -m text -r #{@name}`
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
            content.gsub!(domain.downcase, "(the system's own domain)")
          end

          setup_destination!
          File.open(destination_filename, 'w') { |f| f.write content }
          File.open(destination_filename).read() =~ /\# (.*)\n/
          title = $1
          file = IO.read(destination_filename)
          header = <<EOT
---
layout: legacy
title: "#{title}"
canonical: "/references/latest/#{@name}.html"
---
EOT
          open(destination_filename, 'w') { |f| f << header << "\n\n" << file}
          puts "Wrote #{destination_filename}"
         else
          abort "Could not build #{@name} reference using puppetdoc at #{version}"
        end
      end

      private

      def valid_tags
        %x{git fetch --tags origin}
        @valid_tags ||= at('master') { `git tag` }.grep(/\./).map { |s| s.strip }
      end

      def version
        @version ||=
          at @tag do
            raw = `ruby -I#{puppet_dir}/lib -rpuppet -e 'puts Puppet::PUPPETVERSION'`.strip
            Gem::Version.new(raw)
          end
      end

      def validate!
        unless valid_tags.include?(@tag)
          abort "Invalid puppet tag: #{@tag}"
        end
      end

      def at(ref, &block)
        Dir.chdir(puppet_dir) do
          %x{git reset --hard #{ref}}
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

      def setup_repository!
        if File.directory?(puppet_dir)
          at 'master' do
            %x{git pull origin master}
          end
        else
          puts "Retrieving puppet source."
          %x{git clone git://github.com/puppetlabs/puppet.git '#{puppet_dir}'}
        end
      end

      def change_to_tag!
        at @tag
      end

      def destination_filename
        @destination_filename ||= destination_directory + (@name + ".markdown")
      end

      def destination_directory
        @destination_directory ||= PuppetDocs.root + "source/references" + @tag
      end

      def setup_destination!
        destination_directory.mkpath
      end

    end

  end

end
