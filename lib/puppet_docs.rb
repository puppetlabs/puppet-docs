require 'rubygems'
require 'fileutils'
require 'set'
require 'pathname'

%w(jekyll maruku versionomy).each do |dep|
  begin
    require dep
  rescue LoadError
    abort "Could not require '#{dep}'.\nRun `rake install:#{dep}` (or `rake install`)"
  end
end

module PuppetDocs

  def self.root
    @root ||= Pathname.new(File.expand_path(__FILE__)).parent + '..'
  end

  autoload :Reference,         "puppet_docs/reference"

end

