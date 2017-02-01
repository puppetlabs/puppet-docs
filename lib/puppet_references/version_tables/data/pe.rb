require 'puppet_references'
require 'pathname'
require 'json'

module PuppetReferences
  module VersionTables
    module Data
      class Pe
        def initialize(cache = {})
          @repo = PuppetReferences::Repo.new('enterprise-dist', PuppetReferences::PE_DIR)
          @server_repo = PuppetReferences::Repo.new('pe-puppetserver', PuppetReferences::PE_SERVER_DIR)
          @data = nil
          @cache = cache
          config = PuppetReferences::VersionTables::Config.read
          @includes = config['pe']['include'] || {}
          @excludes = config['pe']['exclude'] || []
          detected_versions = @repo.tags.map {|tag| tag.name}.select {|name|
            (name =~ /^\d{4}/ or name =~ /^3\.8/) and name !~ /-/
          }
          @versions_and_commits = Hash[ detected_versions.map {|name| [name, name]} ]
          @excludes.each do |tag|
            @versions_and_commits.delete(tag)
          end
          @versions_and_commits.merge!(@includes)

          @package_name_variations = {

              'Puppet' => %w(pe-puppet pup-puppet puppet-enterprise-nxos-1-i386 puppet-enterprise-nxos-1-x86_64),

              'Puppet Agent' => %w(puppet-agent),

              'Puppet Server' => %w(pe-puppetserver),

              'Facter' => %w(pe-facter pup-facter),

              'Hiera' => %w(pe-hiera pup-hiera),

              'PuppetDB' => %w(pe-puppetdb),

              'MCollective' => %w(pe-mcollective pup-mcollective),

              'Razor Server' => %w(pe-razor-server),

              'Razor Libs' => %w(pe-razor-libs),

              'r10k' => %w(pe-r10k),

              'Ruby' => %w(pe-ruby pup-ruby),

              'Nginx' => %w(pe-nginx),

              'Apache' => %w(pe-httpd),

              'ActiveMQ' => %w(pe-activemq),

              'PostgreSQL' => %w(pe-postgresql),

              'Passenger' => %w(pe-passenger),

              'OpenSSL' => %w(pe-openssl pup-openssl),

              'Java' => %w(pe-java),

              'LibAPR' => %w(pe-libapr)

          }
        end

        # The main method: just return everything.
        def data
          unless @data
            puts 'Updating historical PE data by reading the enterprise-dist repo...'
            @data = @versions_and_commits.reduce( {} ) do |result, (name, commit)|
              puts "#{name}..."
              if @cache[name]
                puts "  (using cached)"
                result[name] = @cache[name]
              else
                result[name] = packages_json_to_versions_sorted_by_platform( load_package_json(commit) )
              end
              result
            end
            # results in something like
            # { '3.2.0' => { 'Puppet' => { '3.7.1-1' => ['debian-6-amd6', '...'], '3.7.1-4' => ['...', '...'] } }
          end
          @data
        end

        # this is like { platformname: { packagename: { version: version, md5: md5 }, packagename: {...} }, platformname: {......} }
        def load_package_json(version)
          @repo.checkout(version)
          JSON.load( File.read( PuppetReferences::PE_DIR + 'packages.json' ) )
        end

        # Use lein deps :tree to turn a pe-puppetserver version into a real Puppet Server version
        def normalize_puppetserver_version_number(tag)
          @server_repo.checkout(tag)
          lein_tree = ''
          Dir.chdir(@server_repo.directory) do
            begin
              lein_tree = `lein deps :tree`
              unless $?.success?
                puts "
ERROR: Uh, something weird went wrong. Probably one of these things:

* Are you not on the office wi-fi or the VPN?
  If not, Leiningen won't be able to get pe-puppetserver's dependencies,
  since it has to contact a private Maven server. Check lein's error-spew
  above for more info.

* Is Java uninstalled?
  Sometimes (when you upgrade your OS?) you can end up in a situation where
  Leiningen is installed, but Java no longer is. Try running `java -version` and
  see what happens, then follow up if necessary.

* Is Lein outdated?
  This doesn't happen very often, but it's possible our Clojure projects have
  started using a new lein feature, and your outdated lein is exploding when
  they try to call a new function. If you've already checked the first two, run
  `lein upgrade` to be certain."
                exit(1)
              end
            rescue Errno::ENOENT
              puts "
ERROR: Building the version tables requires Leiningen, and I can't find it!
Make sure the `lein` command is present; run `which lein` to check for it.

If you haven't installed lein yet... the install instructions at
http://leiningen.org/#install are not written with us in mind, so follow these:

* Install Java, if you haven't.
* Run `curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein`.
* Run `mv lein /usr/local/bin/lein` (you might have to sudo).
* Run `chmod a+x /usr/local/bin/lein` (you might have to sudo).
* Run `lein` and let it finish installing itself.
"
              exit(1)
            end
          end
          real_version = lein_tree.scan(%r{puppetlabs/puppetserver\s*"([^"]+)"})[0][0]
          real_version
        end

        def normalize_version_number(number, name = '')
          # First, handle Puppet Server version numbers. This gets hairy.
          if name == 'Puppet Server' && number >= '2.2.0' # Simple string compare seems to work fine for now; we can use versionomy here later if necessary.
            number = normalize_puppetserver_version_number(number)
          end
          # There's a special case in here for a slightly mangled Ruby version on Solaris.
          number = number.sub(/^1.9.3-p484/, '1.9.3.484').split(/\.?(-|pe|pup|sles|el)/)[0]
          if name != 'Ruby' && name != 'OpenSSL'
            # Reduce everything else to three digits.
            number = number.split('.')[0..2].join('.')
          end
          number
        end

        def packages_json_to_versions_sorted_by_platform(packagedata)
          result = {}
          packagedata.each do | platform, platform_hash |
            # Skip never-shipped network device OSes.
            # https://tickets.puppetlabs.com/browse/DOC-2645
            if platform == "nxos-1-x86_64" || platform == "cumulus-1.5-powerpc" || platform == "nxos-1-i386"
              next
            end

            platform_hash.each do | package_name, package_data |
              we_care = @package_name_variations.detect {|k,v| v.include?(package_name)}
              if we_care
                common_name = we_care[0]
                normalized_version = normalize_version_number(package_data['version'], common_name)
                result[common_name] ||= {}
                result[common_name][normalized_version] ||= []
                result[common_name][normalized_version] << platform
              end
            end
          end

          result
        end


      end
    end
  end
end
