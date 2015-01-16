#!/usr/bin/env ruby

require 'json'
require 'pp'

packagedata = JSON.load( File.read( '/Users/nick/Desktop/packages.json' ) )

# puts packagedata.keys
platforms = packagedata.keys
# puts packagedata.values.collect {|hsh| hsh.keys}
all_packages = packagedata.values.collect {|distro_hash| distro_hash.keys}.flatten.uniq.sort

top_row = ['Platform ↓ / Packages →'] + all_packages
# array of equal-length arrays:
table_rows = packagedata.reduce( [top_row] ) {|all_rows, (platform, platform_data)|
  this_row = [platform] + all_packages.collect {|package|
    platform_data[package] ? platform_data[package]['version'] : 'n/a'
  }
  all_rows << this_row
}

# pp table_rows

table_body = table_rows.reduce('') {|html, row|
  html << "<tr>\n  <td>"
  html << row.join("</td>\n  <td>")
  html << "</td>\n</tr>\n"
}

puts "<table>\n" << table_body << "</table>\n"