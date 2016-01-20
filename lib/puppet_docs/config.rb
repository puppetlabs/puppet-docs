require 'yaml'

module PuppetDocs
  class Config < Hash
    def initialize(config_file)
      super()
      self.merge!(YAML.load(File.read(config_file)))

      # Merge document info into external sources. Expected behavior is that documents override
      # standalone sources if there's a conflict.
      self['documents'].each {|url, info|
        if info['external_source']
          self['externalsources'][url] = info['external_source']
        end
      }
    end

  end
end
