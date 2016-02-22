#!/usr/bin/env ruby
# USAGE:
#  ./linkmunger.rb [-n] <PATH>
# Takes a path to the folder acting as site root as argument, or else
# assumes it should treat the cwd as the site root.
# OPTIONS:
#  -n: run in no-op mode

def relativepath(path, relative_to)
  if path == relative_to
    if path[-1] == "/" and relative_to[-1] == "/"
      return "."
    else
      return File.basename(path)
    end
  end

  if path == "#{relative_to}/"
    # from /a to /a/
    return File.basename(path) + "/"
  end

  if "#{path}/" == relative_to
    # from /a/ to /a
    return "../" + File.basename(path)
  end

  path = path.chomp("/")
  if path == ""
    path = [""]
  else
    # The negative limit ensures that empty values aren't dropped.
    path = path.split(File::SEPARATOR, -1)
  end

  relative_to = relative_to.chomp("/")
  if relative_to == ""
    relative_to = [""]
  else
    # The negative limit ensures that empty values aren't dropped.
    relative_to = relative_to.split(File::SEPARATOR, -1)
  end

  while (path.length > 0) && (path.first == relative_to.first)
    path.shift
    relative_to.shift
  end

  if relative_to.length == 0 and path.length == 0
    throw "BUG: Processed paths were equivalent when raw paths were the same"
  elsif relative_to.length == 0
    path.join(File::SEPARATOR)
  elsif path.length == 0 and relative_to.length == 1
    "."
  else
    (['..'] * (relative_to.length - 1) + path).join(File::SEPARATOR)
  end
end

noop = ARGV.first == "-n"
if noop
  ARGV.shift
  puts "Running in no-op mode"
end

if ARGV.first
  Dir.chdir(ARGV.shift)
end

regex = %r{
  (href|src)=
  # The first quote, which must be matched by the final quote
  (['"])
    # The value is either a single /, or it starts with / but not //, since
    # that's a URL with a host but no protocol. Sometimes it will incorrectly
    # have a quote that's different from the one that starts the attribute.
    (
      /(?:[^/'"].*?)?
    )
  # Look for a matching quote.
  \2
}xi

changed = 0
Dir['**/*.html'].each do |page_path|
  puts "Processing: /#{page_path}"
  results = File.read(page_path).gsub(regex) do |match|
    changed += 1
    "#{$1}=#{$2}" + relativepath($3, "/" + page_path) + $2
  end

  if ! noop
    File.write(page_path, results)
  end
end

puts "Updated #{changed} links"
