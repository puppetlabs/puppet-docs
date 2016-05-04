require 'puppet_references'
require 'pathname'
require 'json'

module PuppetReferences
  module VersionTables
    module Data
      class Pe
        def initialize
          @repo = PuppetReferences::Repo.new('enterprise-dist', PuppetReferences::PE_DIR)
          @data = nil
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
              result[name] = packages_json_to_versions_sorted_by_platform( load_package_json(commit) )
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

        def normalize_version_number(number, name = '')
          # There's a special case in here for a slightly mangled Ruby version on Solaris.
          normalized_number = number.sub(/^1.9.3-p484/, '1.9.3.484').split(/\.?(-|pe|pup|sles|el)/)[0]
          if name != "Ruby" && name != "OpenSSL"
            # Reduce everything else to three digits.
            normalized_number = normalized_number.split('.')[0..2].join('.')
          end
          normalized_number
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
