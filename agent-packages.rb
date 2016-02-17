#!/usr/bin/env ruby

require 'git'
require 'pathname'
require 'json'
require 'pp'
require 'yaml'

project_dir = Pathname.new(File.expand_path(__FILE__)).parent
vanagon_dir = (project_dir + 'puppet-agent')
config_file = project_dir + 'config.yaml'

config = YAML.load(config_file.read)
includes = config['agent']['include'] || {}
excludes = config['agent']['exclude'] || []

if !Dir.exist?(vanagon_dir + '.git')
  Git.clone('git@github.com:puppetlabs/puppet-agent.git', vanagon_dir)
end

agent_repo = Git.open(vanagon_dir)
agent_repo.fetch

component_files = {
  'Ruby' => 'ruby.rb',
  'OpenSSL' => 'openssl.rb',
  'Puppet' => 'puppet.json',
  'Facter' => 'facter.json',
  'Hiera' => 'hiera.json',
  'MCollective' => 'marionette-collective.json'
}

def version_from_json(file)
  # We want the last component of a string like refs/tags/4.2.0.
  JSON.load(File.read(file))['ref'].split('/')[-1]
end

def version_from_ruby(file)
  ruby_text = File.read(file)
  # find 'pkg.version "version"' and capture the version.
  ruby_text.match(/^\s*pkg\.version[\s\(]*['"]([^'"]+)['"]/)[1]
end

tags = agent_repo.tags
# Structure of the repo didn't stabilize until 0.9.0-ish, so:
until tags.first.name == '1.0.0'
  tags.shift
end

versions_and_commits = Hash[ tags.map {|tag| [tag.name, tag.name]} ]
excludes.each do |tag|
  versions_and_commits.delete(tag)
end
versions_and_commits.merge!(includes)

agent_versions_hash = Hash[
  versions_and_commits.map {|name, commit|
    agent_repo.checkout(commit)
    components_hash = component_files.reduce(Hash.new) {|result, (component, config)|
      component_file = vanagon_dir + 'configs/components' + config
      if component_file.extname == '.json'
        result[component] = version_from_json(component_file)
      elsif component_file.extname == '.rb'
        result[component] = version_from_ruby(component_file)
      else
        raise("Unexpected file extension for #{component_file}")
      end
      result
    }
    [name, components_hash]
  }
]

puts JSON.dump(agent_versions_hash)
