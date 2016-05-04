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
  require 'puppet_references/version_tables/config'
  require 'puppet_references/version_tables/data/pe'
  require 'puppet_references/version_tables/data/agent'
  require 'puppet_references/version_tables/pe_tables'
  require 'puppet_references/version_tables/pe_early3'
  require 'puppet_references/version_tables/pe_late3'
  require 'puppet_references/version_tables/pe_2015'
  require 'puppet_references/version_tables/pe_2016'
  require 'puppet_references/version_tables/agent_tables'
  require 'puppet_references/version_tables/agent_1x'

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
    build_from_list_of_classes(references, real_commit)
  end

  def self.build_facter_references(commit)
    references = [
        PuppetReferences::Facter::CoreFacts
    ]
    repo = PuppetReferences::Repo.new('facter', FACTER_DIR)
    real_commit = repo.checkout(commit)
    build_from_list_of_classes(references, real_commit)
  end

  def self.build_from_list_of_classes(reference_classes, real_commit)
    references = reference_classes.map {|r| r.new(real_commit)}
    references.each do |ref|
      ref.build_all
    end

    locations = references.map {|ref|
      "#{ref.class.to_s} -> #{ref.latest}"
    }.join("\n")
    puts 'NOTE: Generated files are in the references_output directory.'
    puts "NOTE: You'll have to move the generated files into place yourself. The 'latest' location for each is:"
    puts locations
  end

  def self.build_version_tables
    require 'json'
    pe_data = PuppetReferences::VersionTables::Data::Pe.new.data
    agent_data = PuppetReferences::VersionTables::Data::Agent.new.data

    # Write json to disk in case we need to investigate anything in it
    tables_dir = OUTPUT_DIR + 'version_tables'
    tables_dir.mkpath
    File.open(tables_dir + 'pe.json', 'w') {|fh| fh.write(JSON.dump(pe_data))}
    File.open(tables_dir + 'agent.json', 'w') {|fh| fh.write(JSON.dump(agent_data))}

    pe_classes = [
        PuppetReferences::VersionTables::Pe2016,
        PuppetReferences::VersionTables::Pe2015,
        PuppetReferences::VersionTables::PeLate3,
        PuppetReferences::VersionTables::PeEarly3
    ]
    agent_classes = [
        PuppetReferences::VersionTables::Agent1x
    ]

    # Write all tables
    pe_classes.each do |klass|
      klass.new(pe_data, agent_data).build_all
    end
    agent_classes.each do |klass|
      klass.new(agent_data).build_all
    end
  end
end
