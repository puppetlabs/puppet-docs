require 'versionomy'

module PuppetDocs
  module Versions
    # The versions array must be an array of strings.
    # It can safely contain any number of "garbage" versions, though it shouldn't.
    # This doesn't account for lock_latest. Use a simple || operator to handle that.
    def self.latest(versions_array)
      versions_array.map {|ver|
        begin
          Versionomy.parse(ver)
        rescue
          nil
        end
      }.compact.sort.last.to_s
    end
  end
end
