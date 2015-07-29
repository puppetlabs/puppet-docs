#!/usr/bin/env ruby

require 'git'
require 'pathname'
require 'json'
require 'pp'

agent_packages_dir = Pathname.new(File.expand_path(__FILE__)).parent
agent_repo = Git.open(agent_packages_dir + 'puppet-agent')

component_files = {
  'Puppet' => 'puppet.json',
  'Facter' => 'facter.json',
  'Hiera' => 'hiera.json',
  'MCollective' => 'marionette-collective.json'
}

def version_from_json(file)
  JSON.load(File.read(file))['ref'].split('/')[-1]
end

agent_repo.fetch
tags = agent_repo.tags
# Structure of the repo didn't stabilize until 0.9.0-ish, so:
until tags.first.name == '1.0.0'
  tags.shift
end

# version_info = tags.map {|tag|
#   agent_repo.checkout(tag)
#   versions = component_files.values.map {|json|
#     # We want the last component of a string like refs/tags/4.2.0.
#     component_file = agent_packages_dir + 'puppet-agent/configs/components' + json
#     JSON.load(component_file.read)['ref'].split('/')[-1]
#   }
#   [tag.name, versions].flatten
# }

version_info_hash = tags.reduce(Hash.new) {|result, tag|
  agent_repo.checkout(tag)
  version_hash = component_files.reduce(Hash.new) {|result, (component, json)|
    # We want the last component of a string like refs/tags/4.2.0.
    component_file = agent_packages_dir + 'puppet-agent/configs/components' + json
    result[component] = version_from_json(component_file)
    result
  }
  result[tag.name] = version_hash
  result
}

# version_header = ['puppet-agent'].concat(component_files.keys)
# # version_table = version_info.unshift(version_header)
#
# html_rows = version_info.map {|r|
#   "<td>" << r.join("</td> <td>") << "</td>"
# }
#
# html_table = <<END
# <table>
#   <thead>
#     <tr><th>#{version_header.join('</th> <th>')}</th></tr>
#   </thead>
#   <tbody>
#     <tr>#{html_rows.join("</tr>\n    <tr>")}</tr>
#   </tbody>
# </table>
#
# END

# puts html_table
puts JSON.dump(version_info_hash)
