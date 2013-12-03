module PuppetDocs
  module Reference
    module Man
      require 'pathname'
      require 'fileutils'

      # This implements man page building for puppet versions.
      def self.write_manpages(puppet_dir, destination_dir)
        Dir.mkdir(destination_dir) unless File.directory?(destination_dir)
#         Dir.chdir(destination_dir) do
#           File.open("./this_would_be_the_man_page.txt", 'w') {|f| f.puts "Okay, here it is"}
#         end

        # Note that the index must be built manually if new applications are added. Also, let's not ever have a `puppet index` command.
        puppet = ENV['PUPPETDIR']
        applications  = Dir.glob(%Q{#{puppet}/lib/puppet/application/*})
        ronn = %x{which ronn}.chomp
        unless File.executable?(ronn) then fail("Ronn does not appear to be installed.") end
        applications.each do |app|
          app.gsub!( /^#{puppet}\/lib\/puppet\/application\/(.*?)\.rb/, '\1')
          headerstring = "---\nlayout: default\ntitle: puppet #{app} Manual Page\n---\n\npuppet #{app} Manual Page\n======\n\n"
          manstring = %x{RUBYLIB=#{puppet}/lib:$RUBYLIB #{puppet}/bin/puppet #{app} --help | #{ronn} --pipe -f}
          File.open(%Q{./source/man/#{app}.markdown}, 'w') do |file|
            file.puts("#{headerstring}#{manstring}")
          end
        end

      end
    end
  end
end
