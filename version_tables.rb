#!/usr/bin/env ruby

require 'json'
require 'pp'

module VersionTables

  def self.table_from_header_and_array_of_body_rows(header_row, other_rows)
    html_table = <<EOT
<table>
  <thead>
    <tr>
      <th>#{header_row.join('</th> <th>')}</th>
    </tr>
  </thead>

  <tbody>
    <tr>#{other_rows.map {|row| "<td>" << row.join("</td> <td>") << "</td>"}.join("</tr>\n    <tr>")}</tr>
  </tbody>
</table>

EOT
    html_table
  end

  def self.release_notes_for_component_version(component, version) # returns string or nil.
    x = version.split('.')[0]
    x_dot_y = version.split('.')[0..1].join('.')
    dotless = version.gsub(/\./, '')
    case component
      when 'Puppet'
        if x == '3' and x_dot_y.to_f < 3.5
          "/puppet/3/reference/release_notes.html#puppet-#{dotless}"
        else
          "/puppet/#{x_dot_y}/reference/release_notes.html#puppet-#{dotless}"
        end
      when 'Puppet Server'
        "/puppetserver/#{x_dot_y}/release_notes.html#puppet-server-#{dotless}"
      when 'Facter'
        "/facter/#{x_dot_y}/release_notes.html#facter-#{dotless}"
      when 'Hiera'
        if x == '1'
          "/hiera/1/release_notes.html#hiera-#{dotless}"
        else
          "/hiera/#{x_dot_y}/release_notes.html#hiera-#{dotless}"
        end
      when 'PuppetDB'
        "/puppetdb/#{x_dot_y}/release_notes.html" # Anchors are broken because Kramdown is silly.
      when 'MCollective'
        "/mcollective/releasenotes.html" # Anchors broken here too.
      when 'r10k'
        "https://github.com/puppetlabs/r10k/blob/master/CHANGELOG.mkd##{dotless}"
      else
        nil
    end
  end

  def self.link_release_notes_if_applicable(component, text, version = nil)
    unless version
      version = text
    end
    notes = release_notes_for_component_version(component, version)
    if notes
      '<a href="' << notes << '">' << text << '</a>'
    else
      text
    end
  end

  module PE
    def self.abbr_for_given_version(version, platforms)
      # an individual version w/ associated platforms
      '<abbr title="' << platforms.join(', ') << '">' <<
        version <<
      '</abbr>'
    end

    def self.all_abbrs_for_component(component, vers_to_platforms)
      # a cell of versions
      vers_to_platforms.sort {|x,y| y[0] <=> x[0]}.map {|pkg_ver, platforms|
        VersionTables.link_release_notes_if_applicable(
          component,
          abbr_for_given_version(pkg_ver, platforms),
          pkg_ver
        )
      }.join("<br>")
    end

    def self.make_table_body(versions, components, historical_packages)
      versions.map {|version| # Make a row for each version
        component_versions = components.map {|component|
          if historical_packages[version][component]
            all_abbrs_for_component(component, historical_packages[version][component])
          else
            ""
          end
        }
        [version].concat(component_versions)
      }
    end

  end

end




# First, Puppet Labs software.

# pl_header = ['PE Version'].concat(pl_software)
# pl_body = make_table_body(pl_software, historical_packages)
#
# # Then, third-party software.
#
# third_header = ['PE Version'].concat(third_party)
# third_body = make_table_body(third_party, historical_packages)
#
# # now make tables
#
# print "### Puppet Labs Software\n\n"
# print table_from_header_and_array_of_body_rows(pl_header, pl_body)
# print "### Third-Party Software\n\n"
# print table_from_header_and_array_of_body_rows(third_header, third_body)

# done
