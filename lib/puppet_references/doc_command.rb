require 'puppet_references/bleach'
class PuppetReferences
  class DocCommand
    def initialize(name, puppet_dir = './vendor/puppet')
      @name = name
      @puppet_dir = File.expand_path(puppet_dir)
    end

    def get
      text = ''
      Dir.chdir(@puppet_dir) do
        text = PuppetReferences::Bleach.run_dirty_command(
            "bundle exec puppet doc -r #{@name} #{PuppetReferences::Bleach::PUPPET_OPTIONS}"
        )
      end
      text
    end
  end
end