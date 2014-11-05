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

task :check_tarball do
  tarball_name = "puppetdocs-latest.tar.gz"
  abort "No site tarball found! Run 'rake build' before releasing." unless File.exists?(tarball_name)
  if File.directory?('.git')
    if File.exists?("#{tarball_name}.version")
      head = `git rev-parse HEAD`.chomp
      tarball_version = File.open("#{tarball_name}.version", 'r') {|f| f.gets.chomp}
      if head != tarball_version
        STDOUT.puts "Site tarball wasn't built from HEAD and may be outdated. Deploy anyway? (y/n)"
        abort "Aborting." unless STDIN.gets.strip.downcase == ('y' or 'yes')
      end
    else
      STDOUT.puts "Can't tell age of site tarball; it's probably outdated. Deploy anyway? (y/n)"
      abort "Aborting." unless STDIN.gets.strip.downcase == ('y' or 'yes')
    end
  end
end

desc "Release the documentation site"
remote_task :release do
  Rake::Task['vlad:check_tarball'].invoke # When deploying to multiple mirrors in a single wrapper rake task, this will only run once.
  puts "DEPLOYING TO: #{domain}"
  tarball_name = "puppetdocs-latest.tar.gz"
  staging_dir = "~/puppetdocs_deploy"
#  rsync tarball_name, "~/"
  sh "rsync -av --progress #{tarball_name} #{domain}:~/#{tarball_name}"
  run "rm -rf #{staging_dir}"
  run "mkdir -p #{staging_dir}"
  run "cp ~/#{tarball_name} #{staging_dir}/"
  run "cd #{staging_dir} && tar -xzf #{tarball_name}"
  run "rsync -av --delete #{staging_dir}/ #{deploy_to}/" # This is strictly local, so we can't use vlad's rsync helper.
end

end
