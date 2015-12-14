require 'puppet_references'
require 'puppet_references/puppet_command'
module PuppetReferences
  class ManCommand < PuppetReferences::PuppetCommand
    attr_reader :name
    FACES_THAT_RUIN_EVERYTHING = %w(resource)
    def initialize(name, puppet_dir = PuppetReferences::PUPPET_DIR)
      @name = name
      if FACES_THAT_RUIN_EVERYTHING.include?(@name)
        super("puppet #{@name} --help", puppet_dir)
      else
        super("puppet man #{@name} --render-as s", puppet_dir)
      end

    end
  end
end