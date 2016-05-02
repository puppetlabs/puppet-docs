#!/usr/bin/env ruby

my_dir = File.dirname(__FILE__)
system("mkdir -p #{my_dir}/output")

puts "Updating PE JSON..."
system("#{my_dir}/pe-packages.rb > #{my_dir}/pe.json")
puts "done.\nUpdating puppet-agent JSON..."
system("#{my_dir}/agent-packages.rb > #{my_dir}/agent.json")
puts "done."
puts "Building PE tables:"
puts "3.2–3.3..."
system("#{my_dir}/pe-tables-early3.rb > #{my_dir}/output/_versions_early_3.x.md")
puts "3.7–3.8..."
system("#{my_dir}/pe-tables-late3.rb > #{my_dir}/output/_versions_late_3.x.md")
puts "2015.x..."
system("#{my_dir}/pe-tables-2015.rb > #{my_dir}/output/_versions_2015.md")
puts "2016.x..."
system("#{my_dir}/pe-tables-2016.rb > #{my_dir}/output/_versions_2016.md")
puts "Building agent tables:"
puts "1.x..."
system("#{my_dir}/agent-tables-1x.rb > #{my_dir}/output/_agent1.x.html")
puts "done."

