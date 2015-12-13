source 'https://rubygems.org/'

gem 'versionomy'
gem 'rake'
gem 'rack'
gem 'git'

group(:build_site) do
  gem 'jekyll', :git => 'git://github.com/puppetlabs/jekyll.git', :branch => 'puppetdocs'
  gem 'kramdown'
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


