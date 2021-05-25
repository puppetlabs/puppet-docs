require 'puppet_references'
require 'yaml'
require 'versionomy'
module PuppetReferences
  module Util
    # Given a hash of data, return YAML frontmatter suitable for the docs site.
    def self.make_header(data)
      # clean out any symbols:
      generated_at = "> **NOTE:** This page was generated from the Puppet source code on #{Time.now.to_s}"
      clean_data = data.reduce( {} ) do |result, (key,val)|
        result[key.to_s]=val
        result
      end
      YAML.dump(clean_data) + "---\n\n" + "# #{clean_data['title']}" + "\n\n" + generated_at + "\n\n"
    end

    # Run a command that can't cope with a contaminated shell environment.
    def self.run_dirty_command(command)
      result = Bundler.with_clean_env do
        # Bundler replaces the entire environment once this block is finished.
        ENV.delete('RUBYLIB')
        %x( #{command} )
      end
      result
    end

    # Just build an HTML table.
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

    # Get the Puppet version for a given puppet-agent version.
    def self.puppet_version_for_agent_version(agent_version, agent_info = {})
      agent_info[agent_version]['Puppet']
    end

    # Build a release notes URL for a given version, using what we know about each project's URLs and doc formats.
    # This has to take the hash of agent info, but only because finding the agent release notes relies on hidden info.
    # If we ever move those to their own dir, it'll fix that.
    def self.release_notes_for_component_version(component, version, agent_info = {}) # returns string or nil.
      begin
        parsed_version = Versionomy.parse(version)
        x = parsed_version.major.to_s
        x_dot_y = "#{parsed_version.major}.#{parsed_version.minor}"
        dotless = version.gsub(/\./, '')
      rescue
        x = version.split('.')[0]
        x_dot_y = version.split('.')[0..1].join('.')
        dotless = version.gsub(/\./, '')
      end
      case component
        when 'Puppet'
          begin
            mono_three = (x == '3' and Versonomy.parse(x_dot_y) < Versionomy.parse(3.5))
          rescue
            mono_three = false
          end
          if mono_three
            "/puppet/3/release_notes.html#puppet-#{dotless}"
          else
            "/puppet/#{x_dot_y}/release_notes.html#puppet-#{dotless}"
          end
        when 'Puppet Agent'
          begin
            too_old = Versionomy.parse(version) < Versionomy.parse('1.2')
          rescue
            too_old = false
          end
          if too_old
            nil
          else
            puppet_docs = puppet_version_for_agent_version(version, agent_info).split('.')[0..1].join('.')
            "/puppet/#{puppet_docs}/release_notes_agent.html#puppet-agent-#{dotless}"
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

    # Returns the provided text, wrapping it in a link if it can find an applicable release notes URL.
    def self.link_release_notes_if_applicable(component, text, version = nil, agent_data = {})
      unless version
        version = text
      end
      notes = release_notes_for_component_version(component, version, agent_data)
      if notes
        '<a href="' << notes << '">' << text << '</a>'
      else
        text
      end
    end

    def self.convert_man(man_filepath)
      require 'pandoc-ruby'
      PandocRuby.convert([man_filepath], from: :man, to: :markdown)
        .gsub(/#(.*?)\n/, '##\1')
        .gsub(/:\s\s\s\n\n```\{=html\}\n<!--\s-->\n```/, '')
        .gsub(/\n:\s\s\s\s/, '')
    end

  end
end
