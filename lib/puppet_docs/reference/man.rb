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
        require 'puppet/face'
        # All four lines below are terrible. See puppet/tasks/manpages.rake for details.
        Puppet.initialize_settings()
        helpface = Puppet::Face[:help, '0.0.1']
        manface  = Puppet::Face[:man, '0.0.1']
        Puppet::Util::Instrumentation.init()

        non_face_applications = helpface.legacy_applications
        faces = Puppet::Face.faces
        faces.delete(:resource)




        Dir.chdir(destination_dir) do
          File.open("./this_would_be_the_man_page.txt", 'w') {|f| f.puts non_face_applications.join(', '); f.puts faces.join(', ')}
        end

#         ronn = 'bundle exec ronn'
#         applications.each do |app|
#           headerstring = "---\nlayout: default\ntitle: puppet #{app} Manual Page\n---\n\n"
#           # RUBYLIB is already cleaned out and initialized in the Generator#generate method.
#           manstring = %x{ruby #{puppet_dir}/bin/puppet #{app} --help | #{ronn} --pipe -f}
#           # `ruby #{puppet_dir}/bin/puppet doc --modulepath /tmp/nothing --libdir /tmp/alsonothing -m text -r #{@name}`
#           File.open("#{destination_dir}/#{app}.markdown", 'w') do |file|
#             file.puts("#{headerstring}#{manstring}")
#           end
#         end

      end # self.write_manpages
    end
  end
end
