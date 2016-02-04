source 'https://rubygems.org/'
gemspec :name => 'puppet_docs'

gem 'versionomy'
gem 'rake'
gem 'rack'
gem 'git'
gem 'json'

group(:build_site) do
  gem 'jekyll', '3.0.1'
  gem 'kramdown', '~> 1.9'
  gem 'vlad'
  gem 'vlad-git'
end

group(:generate_references) do
  gem 'ronn'
  gem 'yard'
  gem 'rdoc'
end

group(:unknown) do
  gem 'maruku'
  gem 'activerecord', '~>3'
end

# group(:debug) do
#   gem 'byebug'
# end
