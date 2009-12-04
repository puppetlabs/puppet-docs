module PuppetGuides

  module Reference

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
        %x{ruby -I#{puppet_dir}/lib #{puppet_dir}/bin/puppetdoc -m markdown -r #{@name}}
        if $?.success?
          install
          puts "Generated #{destination_filename}"
        else
          abort "Could not generate #{@name} reference using puppetdoc at #{version}"
        end
      end
            
      private

      def install
        content = File.read(puppetdoc_filename)
        content = content.sub(/^%\s+.*?/m, prologue)
        File.open(destination_filename, 'w') { |f| f.write content }
      end

      def prologue
        title = "#{@name.capitalize} Reference (#{version})\n========================\n\n"
        separator = "\n\n* * *\n\n"
        if File.exist?(prologue_filename)
          template = ERB.new(File.read(prologue_filename))
          title + template.result(binding) + separator
        else
          title + separator
        end
      end

      def prologue_filename
        @prologue_filename ||= PuppetGuides.root + "reference-prologues/#{@name}.erb"
      end

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
        PuppetGuides.root + 'vendor/puppet'
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
        @destination_filename ||= PuppetGuides.root + "source/#{@name}-reference-#{@tag}.markdown"
      end

      def puppetdoc_filename
        @puppetdoc_filename ||= File.join('/tmp', version.to_s, "#{@name}.mdwn")
      end
      
    end
    
  end

end
