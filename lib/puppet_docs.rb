require 'pathname'

module PuppetDocs
  BASE_DIR = Pathname.new(File.expand_path(__FILE__)).parent.parent

  require 'puppet_docs/auto_redirects'
  require 'puppet_docs/config'
  require 'puppet_docs/versions'
end

