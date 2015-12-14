require 'puppet_references'
require 'yaml'
module PuppetReferences
  module Util
    # Given a hash of data, return YAML frontmatter suitable for the docs site.
    def self.make_header(data)
      # clean out any symbols:
      clean_data = data.reduce( {} ) do |result, (key,val)|
        result[key.to_s]=val
        result
      end
      YAML.dump(clean_data) + "---\n\n"
    end
  end
end
