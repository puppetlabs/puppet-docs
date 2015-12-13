require 'puppet_references/puppet_command'
module PuppetReferences
  class ManCommand < PuppetReferences::PuppetCommand
    def initialize(name, puppet_dir = './vendor/puppet')
      super("puppet man #{name} --render-as s", puppet_dir)
    end
  end
end