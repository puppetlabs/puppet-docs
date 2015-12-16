require 'pathname'

module PuppetReferences
  BASE_DIR = Pathname.new(File.expand_path(__FILE__)).parent.parent
  PUPPET_DIR = BASE_DIR + 'vendor/puppet'
  FACTER_DIR = BASE_DIR + 'vendor/facter'
  AGENT_DIR = BASE_DIR + 'vendor/puppet-agent'
  PE_DIR = BASE_DIR + 'vendor/enterprise-dist'
  OUTPUT_DIR = BASE_DIR + 'references_output'

  require 'puppet_references/util'
  require 'puppet_references/repo'
  require 'puppet_references/reference'
  require 'puppet_references/doc_command'
  require 'puppet_references/man_command'
  require 'puppet_references/puppet/puppet_doc'
  require 'puppet_references/puppet/man'
  require 'puppet_references/puppet/yard'
  require 'puppet_references/puppet/type'
  require 'puppet_references/puppet/http'
  require 'puppet_references/facter/core_facts'

  def self.build_puppet_references(commit)
    references = [
        PuppetReferences::Puppet::Http,
        PuppetReferences::Puppet::Man,
        PuppetReferences::Puppet::PuppetDoc,
        PuppetReferences::Puppet::Type,
        PuppetReferences::Puppet::Yard
    ]
    repo = PuppetReferences::Repo.new('puppet', PUPPET_DIR)
    real_commit = repo.checkout(commit)
    repo.update_bundle
    references.each do |ref|
      ref.new(real_commit).build_all
    end
    # TODO: tell the writer where to move these things to. Probably centralize the "latest" dir info into a config file or something, and read that.
  end

  def self.build_facter_references(commit)
    references = [
        PuppetReferences::Facter::CoreFacts
    ]
    repo = PuppetReferences::Repo.new('facter', FACTER_DIR)
    real_commit = repo.checkout(commit)
    references.each do |ref|
      ref.new(real_commit).build_all
    end
  end
end
