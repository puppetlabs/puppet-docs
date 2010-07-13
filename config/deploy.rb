set :application, "docs.puppetlabs.com"
set :repository, "git://github.com/reductivelabs/puppet-docs.git"

task :primary do
    set :user,      "deploy"
    set :domain,    "#{user}@docs.puppetlabs.com"
    set :deploy_to, "/var/www/#{application}"
end

task :mirror do
    set :user,      "deploy"
    set :domain,    "#{user}@docs.mirror1.puppetlabs.com"
    set :deploy_to, "/srv/www/docs.mirror1.puppetlabs.com/html"
end

namespace :vlad do

  remote_task :build do
    date = DateTime.now.strftime("%Y%m%d")
    sh "git checkout -b release_#{date}"
    Rake::Task['generate_pdf'].invoke
    Rake::Task['generate'].invoke
    Rake::Task['tarball'].invoke
    sh "git add -f output puppet.pdf puppetdocs-latest.tar.gz"
    sh "git commit -a -m 'Release dated #{date}'"
    sh "git push --force origin release_#{date}"
    sh "git checkout master"
    sh "git branch -d release_#{date}"
  end

  remote_task :release do
    repo = "#{deploy_to}/repo"
    run "rm -fr #{repo}; mkdir -p #{repo}"
    run "git clone #{repository} #{repo}"
    run "cd #{repo} && git pull origin release_#{date}"
    run "cd #{repo} && cp puppet.pdf puppetdocs-latest.tar.gz #{deploy_to}"
    run "cd #{repo}/output && cp -R * #{deploy_to}"
    run "rm -fr #{repo}"
  end

end
