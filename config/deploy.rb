set :application, "docs.puppetlabs.com"
set :repository, "git://github.com/puppetlabs/puppet-docs.git"
set :user, "docsdeploy"

task :mirror0 do
    set :domain,    "#{user}@staticweb1-prod.puppetlabs.com"
    set :deploy_to, "/var/www/#{application}"
end

task :mirror1 do
    set :domain,    "#{user}@staticweb2-prod.puppetlabs.com"
    set :deploy_to, "/var/www/#{application}"
end

task :preview1 do
    set :domain,    "#{user}@staticweb1-dev.puppetlabs.com"
    set :deploy_to, "/var/www/docspreview1.ops.puppetlabs.net"
end

task :preview2 do
    set :domain,    "#{user}@staticweb1-dev.puppetlabs.com"
    set :deploy_to, "/var/www/docspreview2.ops.puppetlabs.net"
end

task :preview3 do
    set :domain,    "#{user}@staticweb1-dev.puppetlabs.com"
    set :deploy_to, "/var/www/docspreview3.ops.puppetlabs.net"
end

namespace :vlad do

desc "Release the documentation site"
remote_task :release do
  Rake::Task['check_build_version'].invoke
  puts "DEPLOYING TO: #{domain}"
  tarball_name = "puppetdocs-latest.tar.gz"
  staging_dir = "~/puppetdocs_deploy"

  sh "rsync -av --delete output/ #{domain}:#{deploy_to}/"

  run "rm -rf #{staging_dir}"
  run "cp -R #{deploy_to} #{staging_dir}"
  run "cd #{staging_dir} && ruby ./linkmunger.rb && tar -czf #{tarball_name} *"
  run "mv #{staging_dir}/#{tarball_name} #{deploy_to}/#{tarball_name}"
end

end
