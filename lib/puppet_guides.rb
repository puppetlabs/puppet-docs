# Loading Action Pack requires rack and erubis.
require 'rubygems'
require 'set'
require 'maruku'
require 'nokogiri'
require 'pathname'

require 'actionpack'
require 'action_controller'
require 'action_view'

module PuppetGuides

  def self.root
    @root ||= Pathname.new(File.expand_path(__FILE__)).parent + '..'
  end

  autoload :Generator,         "puppet_guides/generator"
  autoload :Reference,         "puppet_guides/reference"
  autoload :Helpers,           "puppet_guides/helpers"
  autoload :Levenshtein,       "puppet_guides/levenshtein"
  
end
