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
        Puppet::Util::Instrumentation.init()

        non_face_applications = helpface.legacy_applications
        faces = Puppet::Face.faces
        faces.delete(:resource)

        # Dump the application names to a file
        Dir.chdir(destination_dir) do
          File.open("./this_would_be_the_man_page.txt", 'w') {|f| f.puts non_face_applications.join(', '); f.puts faces.join(', ')}
        end

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
          headerstring = "---\nlayout: default\ntitle: puppet #{name} Manual Page\n---\n\n"

          ronn = IO.popen("bundle exec ronn --pipe -f", "r+")
          ronn.write(man_string)
          ronn.close_write
          processed_man_string = ronn.read
          ronn.close

          File.open("#{destination_dir}/#{name}.markdown", 'w') do |file|
            file.puts("#{headerstring}#{processed_man_string}")
          end
        end

      end # self.write_manpages
    end
  end
end
