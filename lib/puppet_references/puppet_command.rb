require 'puppet_references'
require 'puppet_references/bleach'
module PuppetReferences
  class PuppetCommand
    attr_reader :name
    def initialize(name, command, puppet_dir = PuppetReferences::PUPPET_DIR)
      @name = name
      @command = command
      @puppet_dir = File.expand_path(puppet_dir)
    end
    def get
      text = ''
      Dir.chdir(@puppet_dir) do
        text = PuppetReferences::Bleach.run_dirty_command(
            "bundle exec #{@command} #{PuppetReferences::Bleach::PUPPET_OPTIONS}"
        )
      end
      text
    end

  end
end
