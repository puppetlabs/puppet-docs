require 'puppet_references'

module PuppetReferences
  module Puppet
    class TypeStrings < PuppetReferences::Puppet::Type

      def initialize(*args)
        super(*args)
        @output_dir_individual = PuppetReferences::OUTPUT_DIR + 'puppet/types_strings'
        @base_filename = 'type_strings'
      end

      def get_type_json
        # Do whatever you need to get build a JSON object appropriate for the template.
        # BTW, thanks Past Nick for making this easy to swap out???
        strings_data = PuppetReferences::Puppet::Strings.new(true)
        type_hash = {}
        strings_data['resource_types'].each do |type|
          type_hash[ type['name'] ] = {
              'description' => type['docstring']['text'],
              'features' => (type['features'] || []).reduce(Hash.new) {|memo, feature|
                memo[feature['name']] = feature['description']
                memo
              },
              'providers' => strings_data['providers'].select {|provider|
                provider['type_name'] == type['name']
              }.reduce(Hash.new) {|memo, provider|
                description = provider['docstring']['text']
                if provider['commands'] || provider['confines'] || provider['defaults']
                  description = description + "\n"
                end
                if provider['commands']
                  description = description + "\n* Required binaries: `#{provider['commands'].values.join('`, `')}`"
                end
                if provider['confines']
                  description = description + "\n* Confined to: `#{provider['confines'].map{|fact,val| "#{fact} == #{val}"}.join('`, `')}`"
                end
                if provider['defaults']
                  description = description + "\n* Default for: `#{provider['defaults'].map{|fact,val| "#{fact} == #{val}"}.join('`, `')}`"
                end
                memo[provider['name']] = {
                    'features' => (provider['features'] || []),
                    'description' => description
                }
                memo
              },
              'attributes' => (type['parameters'] || []).reduce(Hash.new) {|memo, attribute|
                description = attribute['description'] || ''
                if attribute['default']
                  description = description + "\n\nDefault: `#{attribute['default']}`"
                end
                if attribute['values']
                  description = description + "\n\nAllowed values:\n\n" + attribute['values'].map{|val| "* `#{val}`"}.join("\n")
                end
                memo[attribute['name']] = {
                    'description' => description,
                    'kind' => 'parameter',
                    'namevar' => attribute['isnamevar'] ? true : false
                }
                memo
              }.merge( (type['properties'] || []).reduce(Hash.new) {|memo, attribute|
                description = attribute['description'] || ''
                if attribute['default']
                  description = description + "\n\nDefault: `#{attribute['default']}`"
                end
                if attribute['values']
                  description = description + "\n\nAllowed values:\n\n" + attribute['values'].map{|val| "* `#{val}`"}.join("\n")
                end
                memo[attribute['name']] = {
                    'description' => description,
                    'kind' => 'property',
                    'namevar' => false
                }
                memo
              } )
          }
        end
        JSON.dump(type_hash)
      end

    end
  end
end