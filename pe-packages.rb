#!/usr/bin/env ruby

require 'json'
require 'pp'

@package_name_variations = {

'Puppet' => [
  'pe-puppet',
  'pup-puppet'
],

'Puppet Server' => [
  'pe-puppetserver'
],

'Facter' => [
  'pe-facter',
  'pup-facter'
],

'Hiera' => [
  'pe-hiera',
  'pup-hiera'
],

'PuppetDB' => [
  'pe-puppetdb'
],

'Mcollective' => [
  'pe-mcollective',
  'pup-mcollective'
],

'Razor server' => [
  'pe-razor-server'
],

'Razor libs' => [
  'pe-razor-libs'
],

'Ruby' => [
  'pe-ruby',
  'pup-ruby'
],

'Apache' => [
  'pe-httpd'
],

'ActiveMQ' => [
  'pe-activemq'
],

'PostgreSQL' => [
  'pe-postgresql'
],

'Passenger' => [
  'pe-passenger'
],

'MySQL' => [
],

'OpenSSL' => [
  'pe-openssl',
  'pup-openssl'
],

'Java' => [
  'pe-java'
],

'LibAPR' => [
  'pe-libapr'
],

'NXOS agent' => [
  'puppet-enterprise-nxos-1-i386',
  'puppet-enterprise-nxos-1-x86_64'
]

}

versions_of_interest_old = [
'3.2.0',
'3.2.1',
'3.2.2',
'3.2.3',
'3.3.0',
'3.3.1',
'3.3.2'
]

versions_of_interest_new = [
'3.7.0',
'3.7.1',
'3.7.2',
'3.8.0',
'3.8.1'
]

versions_of_interest = versions_of_interest_new

# this is like { platformname: { packagename: { version: version, md5: md5 }, packagename: {...} }, platformname: {......} }
def load_package_json(version)
  Dir.chdir(File.expand_path('~/Documents/misc_code/enterprise-dist')) do
    system('git fetch upstream')
    system("git checkout #{version}")
    JSON.load( File.read( './packages.json' ) )
  end
end

def normalize_package_data(packagedata)
  result = {}
  packagedata.each do | platform, platform_hash |
    platform_hash.each do | package_name, package_data |
      we_care = @package_name_variations.detect {|k,v| v.include?(package_name)}
      if we_care
        common_name = we_care[0]
        normalized_version = package_data['version'].split(/\.?(pe|pup|sles|el)/)[0]
        result[common_name] ||= {}
        result[common_name][normalized_version] ||= []
        result[common_name][normalized_version] << platform
      end
    end
  end

  result
end

historical_packages = versions_of_interest.reduce( {} ) do |result, version|
  result[version] = normalize_package_data( load_package_json(version) )
  result
end
# results in something like
# { '3.2.0' => { 'Puppet' => { '3.7.1-1' => ['debian-6-amd6', '...'], '3.7.1-4' => ['...', '...'] } }


header_row = ["Pkg. / Ver."].concat( versions_of_interest )
other_rows = @package_name_variations.keys.map {|common_name|
  # a row
  [common_name].concat(
    # Cells in row after the first cell
    versions_of_interest.map {|pe_version|
      # a cell of versions
      if historical_packages[pe_version][common_name]
        historical_packages[pe_version][common_name].map {|pkg_ver, platforms|
          # an individual version w/ associated platforms
          '<abbr title="' << platforms.join(', ') << '">' <<
            pkg_ver <<
          '</abbr>'
        }.join("<br>")
      else
        ""
      end
    }
  )
}


# now make a table

print <<EOT
<table>
  <thead>
    <tr>
      <th>#{header_row.join('</th> <th>')}</th>
    </tr>
  </thead>

  <tbody>
    <tr>#{other_rows.map {|row| "<td>" << row.join("</td> <td>") << "</td>"}.join("</tr>\n<tr>")}
    </tr>
  </tbody>
</table>

EOT

# done