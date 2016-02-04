require 'versionomy'

module PuppetDocs
  # This is a module of utility functions that take and return pure strings (and groups of strings),
  # to avoid contaminating other code with Versionomy objects.
  module Versions
    # The versions array must be an array of strings.
    # It can safely contain any number of "garbage" versions, though it shouldn't.
    # This doesn't account for lock_latest. Use a simple || operator to handle that.
    def self.latest(versions_array)
      sort_descending(versions_array).first
    end

    # Given an array of parseable and unparseable versions, return the same array sorted in
    # newest-first order.
    def self.sort_descending(versions_array)
      parsed_versions = versions_array.map {|ver|
        begin
          Versionomy.parse(ver)
        rescue
          nil
        end
      }.compact
      sorted_normal_versions = parsed_versions.sort {|x,y| y <=> x }.map{|ver| ver.to_s}
      special_versions = versions_array - sorted_normal_versions

      sorted_normal_versions + special_versions
    end
  end
end
