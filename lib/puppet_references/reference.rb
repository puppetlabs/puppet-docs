require 'puppet_references'

module PuppetReferences
  class Reference
    attr_accessor :commit
    DEFAULT_HEADER_DATA = {layout: 'default',
                           built_from_commit: @commit}
    def initialize(commit)
      @commit = commit
    end

    def make_header(header_data)
      PuppetReferences::Util.make_header(DEFAULT_HEADER_DATA.merge(header_data))
    end
  end
end
