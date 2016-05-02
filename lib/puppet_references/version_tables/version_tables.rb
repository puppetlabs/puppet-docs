#!/usr/bin/env ruby

require 'json'
require 'pp'

module VersionTables

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
