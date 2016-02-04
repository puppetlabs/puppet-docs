Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.2.2'
  s.required_ruby_version = '>= 2.0.0'

  s.name = 'puppet_docs'
  s.version = '0.1'
  s.license = 'Apache 2.0'

  s.summary = 'Internal tools used for building the docs.puppetlabs.com website.'
  s.description = s.summary.dup

  s.authors = ['Nick Fagerlund', 'Mike Hall', 'James Turnbull']
  s.email = 'docs@puppetlabs.com'
  s.homepage = 'https://github.com/puppetlabs/puppet-docs'

  s.require_paths = ['lib']
end
