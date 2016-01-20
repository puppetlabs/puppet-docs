require 'yaml'

module PuppetDocs
  class Config < Hash
    def initialize(config_file)
      @overrides = []
      super()
      self.merge!(YAML.load(File.read(config_file)))
    end

    def [](key)
      if @overrides.include?(key)
        self.send(key.to_sym)
      else
        super
      end
    end

  end
end