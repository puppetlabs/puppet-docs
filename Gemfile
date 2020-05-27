source 'https://rubygems.org/'
gemspec :name => 'puppet_docs'

gem 'versionomy'
gem 'rake'
gem 'rack', '~> 1.6' # We don't want Rack 2.0 because our builders can't handle it (and it's probably incompatible, too)
gem 'git'
gem 'json'

group(:build_site) do
  gem 'jekyll', '3.4.5'
  gem 'kramdown', '1.12.0'
  gem 'vlad'
  gem 'vlad-git'
  gem 'listen', '~> 3.0.0' # Preserve ability to run on Ruby 2.0, since listen 3.1 requires Ruby ~> 2.2.
end

group(:generate_references) do
  gem 'ronn'
  gem 'yard'
  gem 'rdoc'
  gem 'rgen'
  gem 'puppet-strings', :git => 'https://github.com/puppetlabs/puppet-strings.git', :tag => 'v2.4.0'
  gem 'puppet'
  gem 'nokogiri'
  gem 'pragmatic_segmenter'
  gem 'punkt-segmenter'
end

group(:unknown) do
  gem 'maruku'
  gem 'activerecord', '~>3'
end

# group(:debug) do
#   gem 'byebug'
# end
