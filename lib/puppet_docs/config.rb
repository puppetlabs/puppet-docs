require 'yaml'
require 'pathname'
require 'puppet_docs/versions'
require 'byebug'

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

      # Expand the document data:
      # - add a base_url key
      # - expand the nav path
      # - sanitize version numbers into strings
      self['documents'].each {|base_url, data|
        data['base_url'] = base_url
        data['nav'] = (Pathname.new(base_url) + data['nav']).to_s
        data['version'] = data['version'].to_s
        if data['my_versions'].class == Hash
          data['my_versions'].keys.each {|doc|
            data['my_versions'][doc] = data['my_versions'][doc].to_s
          }
        end

      }

      # Index the document data by mapping version numbers to base URLs.
      # Like:
      # {'pe' => {2015.3 => '/pe/2015.3', 3.8 => '/pe/3.8'}, 'puppet' => { ... } }
      self['document_version_index'] = self['documents'].reduce( {} ) {|memo, (base_url, data)|
        memo[data['doc']] ||= {}
        memo[data['doc']][data['version']] = base_url

        memo
      }

      # Save an array of all known document groups.
      self['document_groups'] = self['document_version_index'].keys

      # Lists of base URLs, in descending version order, like:
      # {'pe' => ['/pe/2015.3', '/pe/2015.2', '/pe/3.8', ...], 'puppet' => [...]}
      self['document_version_order'] = self['document_version_index'].reduce( {} ) {|memo, (doc, ver_index)|
        memo[doc] = PuppetDocs::Versions.sort_descending(ver_index.keys).map {|ver| ver_index[ver]}
        memo
      }

      # Add the special "latest" version to the index.
      self['document_version_index'].each {|doc, ver_index|
        latest_ver = self['lock_latest'][doc] || PuppetDocs::Versions.latest(ver_index.keys)
        # byebug
        ver_index['latest'] = ver_index[latest_ver]
      }

      # Expand the document data: fill all empty my_version fields.
      self['documents'].each {|base_url, data|
        data['my_versions'] ||= {}

        # Exclude self:
        other_groups = self['document_groups'] - [ data['doc'] ]
        # If we have an explicit version for a given group, keep it:
        unknown_groups = other_groups.reject {|group| data['my_versions'].has_key?(group)}

        unknown_groups.each {|group|
          # Compile a list of the target group's versions that claim this version:
          matches = self['documents'].values.map {|candidate_data|
            next unless candidate_data['doc'] == group
            next unless candidate_data['my_versions']
            if candidate_data['my_versions'][data['doc']] == data['version']
              candidate_data['version']
            else
              nil
            end
          }.compact
          # Pick the latest version that claimed us, or default to latest
          # (the Versions.latest method returns nil for an empty array):
          best = PuppetDocs::Versions.latest(matches) || 'latest'
          data['my_versions'][group] = best
        }
      }

      # Duplicate the documents hash under a new name that doesn't conflict with Jekyll's
      # site.documents method. :( If you don't do this' you can't access the documents in templates.
      self['document_list'] = self['documents']

    end

  end
end
