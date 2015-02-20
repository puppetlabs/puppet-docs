set :application, "docs.puppetlabs.com"
set :repository, "git://github.com/puppetlabs/puppet-docs.git"
set :user, "docsdeploy"

task :mirror0 do
    set :domain,    "#{user}@staticweb1-prod.puppetlabs.com"
    set :deploy_to, "/var/www/#{application}"
end

task :preview1 do
    set :domain,    "#{user}@docspreview1.puppetlabs.lan"
    set :deploy_to, "/opt/docspreview1"
end

task :preview2 do
    set :domain,    "#{user}@docspreview2.puppetlabs.lan"
    set :deploy_to, "/opt/docspreview2"
end

task :preview3 do
    set :domain,    "#{user}@docspreview3.puppetlabs.lan"
    set :deploy_to, "/opt/docspreview3"
end

namespace :vlad do

desc "Release the documentation site"
remote_task :release do
  Rake::Task['check_build_version'].invoke
  puts "DEPLOYING TO: #{domain}"
  tarball_name = "puppetdocs-latest.tar.gz"
  staging_dir = "~/puppetdocs_deploy"
#  rsync tarball_name, "~/"
  sh "rsync -av --delete output/ #{domain}:#{deploy_to}/"
  run "rm -rf #{staging_dir}"
  run "cp -R #{deploy_to} #{staging_dir}"

  run "cd #{staging_dir} && ruby ./linkmunger.rb && tar -czf #{tarball_name} *"
  run "mv #{staging_dir}/#{tarball_name} #{deploy_to}/#{tarball_name}"
end

end
