set :application, "docs.puppetlabs.com"
set :repository, "git://github.com/puppetlabs/puppet-docs.git"
set :user, "deploy"

task :mirror0 do
    set :domain,    "#{user}@docs.mirror0.puppetlabs.com"
    set :deploy_to, "/var/www/#{application}"
end

task :mirror2 do
      set :domain,    "#{user}@docs.mirror2.puppetlabs.com"
      set :deploy_to, "/var/www/#{application}"
end

namespace :vlad do

desc "Release the documentation site"
remote_task :release do
  staging_dir = "~/puppetdocs_deploy"
  rsync "puppetdocs-latest.tar.gz", "~/"
  run "rm -rf #{staging_dir}"
  run "mkdir -p #{staging_dir}"
  run "cp ~/puppetdocs-latest.tar.gz #{staging_dir}/"
  run "cd #{staging_dir} && tar -xzf puppetdocs-latest.tar.gz"
  run "rsync -av --delete #{staging_dir}/ #{deploy_to}/" # This is strictly local, so we can't use vlad's rsync helper.
end

end
