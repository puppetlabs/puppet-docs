require 'puppet_references'

module PuppetReferences
  class Reference
    attr_accessor :commit
    def initialize(commit)
      @commit = commit
    end

    def make_header(header_data)
      default_header_data = {layout: 'default',
                             built_from_commit: @commit}
      PuppetReferences::Util.make_header(default_header_data.merge(header_data))
    end
  end
end
