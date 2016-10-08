require 'json'
require 'erb'
require 'ostruct'
require 'pathname'

JSON_FILE = '/Users/nick/Desktop/strings.json'
TEMPLATE_FILE = Pathname.new(File.expand_path(__FILE__)).dirname + 'functions_template.erb'

strings_data = JSON.load(File.read(JSON_FILE))
functions = strings_data['puppet_functions']

# Deal with the duplicate function situation.
# 1. Figure out which functions are duplicated.
names = functions.map {|func| func['name']}
duplicates = names.uniq.select {|name| names.count(name) > 1}
# 2. Reject the v3 version of any dupes
functions.delete_if {|func|
  duplicates.include?(func['name']) && func['type'] == 'ruby3x'
}

template_scope = OpenStruct.new({ functions: functions })

puts ERB.new(File.read(TEMPLATE_FILE), nil, '-').result(template_scope.instance_eval {binding})

