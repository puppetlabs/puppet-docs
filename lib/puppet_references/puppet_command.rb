require 'puppet_references'
require 'puppet_references/bleach'
module PuppetReferences
  class PuppetCommand
    def initialize(command, puppet_dir = PuppetReferences::PUPPET_DIR)
      @command = command
      @puppet_dir = File.expand_path(puppet_dir)
      if @command =~ /^puppet/
        @command << " #{PuppetReferences::Bleach::PUPPET_OPTIONS}"
      end
    end
    def get
      text = ''
      Dir.chdir(@puppet_dir) do
        text = PuppetReferences::Bleach.run_dirty_command(
            "bundle exec #{@command}"
        )
      end
      text
    end

  end
end
