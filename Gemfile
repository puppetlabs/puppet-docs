source 'https://rubygems.org/'
gemspec :name => 'puppet_docs'

gem 'versionomy', '~> 0.5.0'
gem 'rake', '~> 13.0', '>= 13.0.1'
gem 'rack', '~> 2.2', '>= 2.2.3'
gem 'git', '~> 1.7'
gem 'json', '~> 2.3', '>= 2.3.1'

group(:build_site) do
  gem 'jekyll', '~> 3.8' # See https://jekyllrb.com/docs/upgrading/3-to-4/ before going to '~> 4.1'
  gem 'kramdown', '~> 1.17'
  gem 'vlad', '~> 1.4'
  gem 'vlad-git', '~> 2.1'
  gem 'listen', '~> 3.2.1' # Preserve ability to run on Ruby 2.0, since listen 3.1 requires Ruby ~> 2.2.
end

group(:generate_references) do
  gem 'ronn', '~> 0.7'
  gem 'yard', '~> 0.9'
  gem 'rdoc', '~> 6.2'
  gem 'rgen', '~> 0.8'
  gem 'puppet-strings', :git => 'https://github.com/puppetlabs/puppet-strings.git', :tag => 'v2.4.0'
  gem 'puppet', '~> 6'
  gem 'nokogiri', '~> 1.10'
  gem 'pragmatic_segmenter', '~> 0.3'
  gem 'punkt-segmenter', '~> 0.9'
end

group(:unknown) do
  gem 'maruku', '~> 0.7'
  gem 'activerecord', '~>3'
end

# group(:debug) do
#   gem 'byebug'
# end
