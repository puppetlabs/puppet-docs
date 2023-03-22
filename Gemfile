source 'https://rubygems.org/'
gemspec :name => 'puppet_docs'

gem 'versionomy', '~> 0.5.0'
gem 'rake', '~> 13.0', '>= 13.0.1'
gem 'rack', '~> 2.2', '>= 2.2.3'
gem 'git', '~> 1.8'
gem 'json', '~> 2.5'

group(:build_site) do
  gem 'jekyll', '~> 4.1'
  gem 'kramdown', '~> 2.3'
  gem 'vlad', '~> 2.7'
  gem 'vlad-git', '~> 2.1'
  gem 'listen', '~> 3.5.1' # Preserve ability to run on Ruby 2.0, since listen 3.1 requires Ruby ~> 2.2.
end

group(:generate_references) do
  gem 'yard', '~> 0.9'
  gem 'rdoc', '~> 6.2'
  gem 'rgen', '~> 0.9'
  gem 'pandoc-ruby'
  gem 'puppet-strings'
  gem 'puppet', '~> 6'
  gem 'nokogiri', '>= 1.12.5'
  gem 'pragmatic_segmenter', '~> 0.3'
  gem 'punkt-segmenter', '~> 0.9'
end

group(:unknown) do
  gem 'maruku', '~> 0.7'
  gem 'activerecord', '~>6'
end

# group(:debug) do
#   gem 'byebug'
# end
