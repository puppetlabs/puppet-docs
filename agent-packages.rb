#!/usr/bin/env ruby

require 'git'
require 'pathname'
require 'json'
require 'pp'

agent_packages_dir = Pathname.new(File.expand_path(__FILE__)).parent
puppet_agent_dir = (agent_packages_dir + 'puppet-agent')

if !Dir.exist?(puppet_agent_dir + '.git')
  Git.clone('git@github.com:puppetlabs/puppet-agent.git', puppet_agent_dir)
end

agent_repo = Git.open(puppet_agent_dir)
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


agent_versions_hash = tags.reduce(Hash.new) {|result, tag|
  agent_repo.checkout(tag)
  components_hash = component_files.reduce(Hash.new) {|result, (component, config)|
    component_file = agent_packages_dir + 'puppet-agent/configs/components' + config
    if component_file.extname == '.json'
      result[component] = version_from_json(component_file)
    elsif component_file.extname == '.rb'
      result[component] = version_from_ruby(component_file)
    else
      raise("Unexpected file extension for #{component_file}")
    end
    result
  }
  result[tag.name] = components_hash
  result
}

puts JSON.dump(agent_versions_hash)
