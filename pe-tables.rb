pl_software = [
"Puppet",
"Puppet Agent",
"Puppet Server",
"Facter",
"Hiera",
"PuppetDB",
"Mcollective",
"Razor Server",
"Razor Libs"
]

third_party = [
"Ruby",
"Apache",
"Nginx",
"ActiveMQ",
"PostgreSQL",
"Passenger",
"OpenSSL",
"Java",
"LibAPR"
]

def abbr_for_given_version(version, platforms)
  # an individual version w/ associated platforms
  '<abbr title="' << platforms.join(', ') << '">' <<
    version <<
  '</abbr>'
end

def all_abbrs_for_component(component, vers_to_platforms)
  # a cell of versions
  vers_to_platforms.sort {|x,y| y[0] <=> x[0]}.map {|pkg_ver, platforms|
    abbr_for_given_version(pkg_ver, platforms)
  }.join("<br>")
end

def table_from_header_and_array_of_body_rows(header_row, other_rows)
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

def make_table_body(list_of_components, historical_packages)
  historical_packages.map {|pe_version, version_info|
    component_versions = list_of_components.map {|component|
      if version_info[component]
        all_abbrs_for_component(component, version_info[component])
      else
        ""
      end
    }
    [pe_version].concat(component_versions)
  }
end



# header_row = ["Pkg. / Ver."].concat( versions_of_interest )
# other_rows = @package_name_variations.keys.map {|common_name|
#   # Versions of this component per PE version (Cells in row after the first cell)
#   component_versions_per_pe_version = versions_of_interest.map {|pe_version|
#     # a cell of versions
#     if historical_packages[pe_version][common_name]
#       all_abbrs_for_component(common_name, historical_packages[pe_version][common_name])
#     else
#       ""
#     end
#   }
#   # a row
#   if component_versions_per_pe_version.uniq == ['']
#     nil # for compact, below.
#   else
#     component_name_string = '<abbr title="' << @package_name_variations[common_name].join(', ') << '">' << common_name << '</abbr>'
#     [component_name_string].concat(component_versions_per_pe_version)
#   end
# }.compact


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
