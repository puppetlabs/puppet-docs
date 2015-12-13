require 'puppet_references'
require 'puppet_references/puppet_command'
module PuppetReferences
  class DocCommand < PuppetReferences::PuppetCommand
    def initialize(name, puppet_dir = PuppetReferences::PUPPET_DIR)
      super(name, "puppet doc -r #{name}", puppet_dir)
    end
  end
end