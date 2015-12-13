require 'puppet_references/puppet_command'
module PuppetReferences
  class DocCommand < PuppetReferences::PuppetCommand
    def initialize(name, puppet_dir = './vendor/puppet')
      super("puppet doc -r #{name}", puppet_dir)
    end
  end
end