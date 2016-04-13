set :application, "docs.puppet.com"
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

  stage_dir = deploy_to + '/stage'

  sh "rsync -crlpv --delete --force output/ #{domain}:#{stage_dir}/"

  # Create tarball, move everything into place, and reload NGINX. Rake has
  # trouble mixing stdout and stderr, so we combine them on the remote host.
  run "sh #{stage_dir}/install.sh #{deploy_to} 2>&1"
end

end
