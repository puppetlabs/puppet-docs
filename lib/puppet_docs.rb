# Loading Action Pack requires rack and erubis.
require 'rubygems'
require 'set'
require 'maruku'
require 'nokogiri'
require 'pathname'

require 'actionpack'
require 'action_controller'
require 'action_view'

module PuppetDocs

  def self.root
    @root ||= Pathname.new(File.expand_path(__FILE__)).parent + '..'
  end

  autoload :Generator,         "puppet_docs/generator"
  autoload :Reference,         "puppet_docs/reference"
  autoload :Helpers,           "puppet_docs/helpers"
  autoload :Levenshtein,       "puppet_docs/levenshtein"
  autoload :Snippet,           "puppet_docs/snippet"
  
end
