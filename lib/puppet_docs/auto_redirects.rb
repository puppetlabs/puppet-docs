require 'yaml'
require 'pathname'
require 'versionomy'

module PuppetDocs
  module AutoRedirects
    # config must be a PuppetDocs::Config object. redirects_yaml must be the
    # path to a yaml file of the following format:
    #
    # ---
    # - in_doc: pe
    #   was: install_system_requirements.html
    #   became:
    #     - sys_req_hw.html
    #     - sys_req_os.html
    #     - sys_req_browsers.html
    #     - sys_req_sysconfig.html
    #   at_version: 2016.4
    # - in_doc: pe
    #   was: orchestration_actions.html
    #   became: mco_actions.html
    #   at_version: 2016.2
    #
    # The "was" and "became" keys can be either strings or arrays, and you can
    # use a small amount of regex syntax in them to match multiple files.
    def self.generate(config, redirects_yaml)
      redirects = YAML.load(File.read(redirects_yaml))

      # Convert array of redirect data hashes into array of redirect lines
      redirect_lines = redirects.reduce( ["\n\n# Auto-generated rewrites from _redirects.yaml:"] ) {|memo, redirect|
        doc         = redirect['in_doc']
        at_version  = redirect['at_version'].to_s
        was         = normalize_paths(redirect['was'])
        became      = normalize_paths(redirect['became'])
        if doc == 'puppet'
          # shot myself in the foot here. -_-
          latest = '/puppet/latest/reference'
        else
          latest = "/#{doc}/latest"
        end

        # First, bail out unless the doc exists and this is a valid version.
        if config['document_version_index'][doc].class != Hash || !( config['document_version_index'][doc].has_key?(at_version) )
          puts "Skipping bad auto-redirect (make sure the syntax is right and the version exists!): #{redirect.to_s}"
          memo
        else
          at_baseurl = config['document_version_index'][doc][at_version]
          at_index = config['document_version_order'][doc].index(at_baseurl)
          new_versions = [latest] + config['document_version_order'][doc][0..at_index]
          old_versions = config['document_version_order'][doc][at_index+1..-1]

          generated_rewrites = [
            build_rewrite_for_versions(new_versions, was, became),
            build_rewrite_for_versions(old_versions, became, was)
          ]
          memo + generated_rewrites
        end
      }

      # Return a string ready to append to the nginx config file:
      redirect_lines.join("\n") + "\n"
    end

    # Normalize string-or-array into normal array, and strip leading ./ or /
    def self.normalize_paths(path_or_array)
      [path_or_array].flatten.map {|path| path.sub(/^\.?\/?/, '')}
    end

    # Takes an array of affected path prefixes, an array of "from" filenames,
    # and an array of "to" filenames.
    def self.build_rewrite_for_versions(versions, from, to)
      "rewrite ^(#{ versions.join('|') })/(#{ from.join('|') })  $1/#{to.first}  permanent;"
    end

  end
end