module PuppetDocs
  module Reference
    module Man
      require 'pathname'
      require 'fileutils'

      # This implements man page building for puppet versions.
      def self.write_manpages(puppet_dir, destination_dir)
        # put a stub
        Dir.mkdir(destination_dir) unless File.directory?(destination_dir)
        Dir.chdir(destination_dir) do
          File.open("./this_would_be_the_man_page.txt", 'w') {|f| f.puts "Okay, here it is"}
        end
      end
    end
  end
end
