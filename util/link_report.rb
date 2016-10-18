#!/usr/bin/env ruby
require 'yaml'

if ARGV.empty?
  puts %Q{link_report.rb:
    Prints a report on broken links (in one or more path prefixes) to stdout.
    Requires a `link_test_results.yaml' file in the top of the puppet-docs
    directory; before using this, you must create that file with the
    'build_and_check_links' rake task.

Usage:
    ./link_report.rb <PREFIX> [<PREFIX>]

Example:
    bundle exec rake build_and_check_links; say "I'm done"
    ./link_report.rb /pe/2015.3 | bbedit}
  exit
end

PREFIXES = "(#{ARGV.join('|')})"
LINK_CHECK_YAML = File.join(File.dirname(__FILE__), '..', 'link_test_results.yaml')
USING_HOSTNAME_IS_OK = [
  %r{^/puppet/[^/]+/reference/(function\.|http_api/|indirection\.|configuration\.|man/|metaparameter\.|report\.|type\.|types/)}
]

all_info = YAML.load( File.read( LINK_CHECK_YAML ))

kinds = {
  :broken_anchor => "GLITCHY: in-page anchor is broken",
  :broken_path => "BROKEN: URL doesn't resolve",
  :internal_with_hostname => "UGLY: Internal links with protocol and hostname",
  :redirected => "STALE: redirected to a new URL."
}

subset = all_info.select {|key, val| key =~ /^#{PREFIXES}/ }.sort

# Suppress hostname warnings for pages that SHOULD be using the docs site hostname
subset.each do |page, report|
  if USING_HOSTNAME_IS_OK.detect {|match| page =~ match}
    report.delete(:internal_with_hostname)
  end
end
subset.delete_if do |page, report|
  report.empty?
end

# Print the report
subset.each do |page, report|
  puts "--------------------------------------"
  puts "file: #{page}"
  report.each do |kind, links|
    next unless kinds.include?(kind)
    puts "--#{kinds[kind]}"
    links.each do |link|
      puts "    #{link}"
    end
    puts ""
  end
end
