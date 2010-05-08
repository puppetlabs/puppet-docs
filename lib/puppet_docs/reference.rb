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
        [Versionomy.parse(path.basename), path]
      end
      @generated_versions = possibles.sort_by { |x| x.first }.reverse
    end

    # The valid, non-symlinked version paths
    def self.generated_version_directories #:nodoc:
      children = (PuppetDocs.root + "output/references").children
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
        raw_content = `ruby -I#{puppet_dir}/lib #{puppet_dir}/bin/puppetdoc -m text -r #{@name}`
        if raw_content
          setup_destination!
          content = nil
          IO.popen("pandoc -s -r rst -w markdown", "w+") do |pandoc| # was rst2html.py ... why?
            pandoc.write raw_content
            pandoc.close_write
            content = pandoc.read
          end
          if content
            File.open(destination_filename, 'w') { |f| f.write content }
            puts "Wrote #{destination_filename}"
          else
            abort "Could not convert RST to Markdown (requires pandoc)"
          end
        else
          abort "Could not build #{@name} reference using puppetdoc at #{version}"
        end
      end
            
      private

      def valid_tags
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
          %x{git clone git://github.com/reductivelabs/puppet.git '#{puppet_dir}'}
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
