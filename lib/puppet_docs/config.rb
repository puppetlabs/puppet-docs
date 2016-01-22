require 'yaml'
require 'pathname'

module PuppetDocs
  class Config < Hash
    def initialize(config_file)
      super()
      self.merge!(YAML.load(File.read(config_file)))

      # Merge document info into external sources. Expected behavior is that documents override
      # standalone sources if there's a conflict.
      self['documents'].each {|base_url, data|
        if data['external_source']
          self['externalsources'][base_url] = data['external_source']
        end
      }

      # Expand the document data: add a base_url key and expand the nav path
      self['documents'].each {|base_url, data|
        data['base_url'] = base_url
        data['nav'] = (Pathname.new(base_url) + data['nav']).to_s
      }

      # Summarize the document data into a hierarchical hash with all the versions per document, with each
      # version mapping to the base URL you'd use to find that document's data in the main documents hash.
      # Like:
      # {'pe' => {'2015.3' => '/pe/2015.3', '3.8' => '/pe/3.8'}, puppet => { ... } }
      self['document_list'] = self['documents'].reduce( {} ) {|memo, (base_url, data)|
        memo[data['doc']] ||= {}
        memo[data['doc']][data['version']] = base_url

        memo
      }


    end

  end
end
