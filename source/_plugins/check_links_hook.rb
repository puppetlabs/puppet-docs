require 'pathname'
require 'puppet_docs/versions'
require 'puppet_docs/auto_redirects'
require 'yaml'

Jekyll::Hooks.register :site, :post_render do |site|
  if site.config['check_links']

    puts 'Checking internal links! This can take upwards of 20m.'
    DOCS_HOSTNAME = /(docs.puppetlabs.com|docs.puppet.com)/
    PREVIEW_HOSTNAMES = %r{^(https?:)?//docspreview\d\.(puppetlabs\.lan|ops\.puppetlabs\.net)}
    NGINX_CONFIG = File.read("#{site.source}/nginx_rewrite.conf")
    GENERATED_REDIRECTS = PuppetDocs::AutoRedirects.generate(site.config, "#{site.source}/_redirects.yaml")

    link_test_results = {}
    link_regex = %r{<[^>]+(href|src)=(['"])([^'"]+)\2}i
    redirections = (NGINX_CONFIG + GENERATED_REDIRECTS).scan(%r{^rewrite\s+(\S+)}).map{|ary| Regexp.new(ary[0]) }

    site.pages.each do |page|
      puts "testing #{page.url}"

      link_test_results[page.relative_path] = {}
      link_test_results[page.relative_path][:internal_with_hostname] = []
      link_test_results[page.relative_path][:broken_path] = []
      link_test_results[page.relative_path][:broken_anchor] = []
      link_test_results[page.relative_path][:redirected] = []

      cwd = Pathname.new(page.relative_path).dirname
      links = page.content.scan(link_regex).map{|ary| ary[2]}

      links.each {|link|
        (path, anchor) = link.split('#', 2)

        if path =~ /^(mailto|ftp|&)/ # then we don't care, byeeeee
          next
        elsif path =~ %r{^(https?:)?//} # it's internal-with-hostname, external, or broken in an interesting way.
          if path =~ DOCS_HOSTNAME # it's internal!
            link_test_results[page.relative_path][:internal_with_hostname] << link
            # continue and see if it actually resolves. Get the path portion.
            path = path.split(DOCS_HOSTNAME, 2)[1]
          elsif path =~ PREVIEW_HOSTNAMES or path =~ %r{^(https?:)?//localhost} # it's a link to the preview site.
            link_test_results[page.relative_path][:broken_path] << link
            next
          elsif path =~ %r{^//[^/\.]+/} # the hostname has no TLD and probably won't resolve on the global internet.
            # Someone probably typoed something like //puppet/latest/reference/etc.
            link_test_results[page.relative_path][:broken_path] << link
            next
          else # it's external and we don't careeeee
            next
          end
        end

        if path == '' # it's an in-page link.
          full_path = page.url
          destination = page
        else
          full_path = (cwd + path).to_s

          if full_path =~ %r{/latest(/|$)} # then we have to resolve it to its real directory, because we haven't symlinked latest yet.
            path_dirs = full_path.split('/', -1)
            project = path_dirs[ 1..(path_dirs.index('latest') - 1) ].join('/') # something like 'references' or 'ja/puppet'
            if site.config['symlink_latest'].include?(project)
              project_dir = "#{site.source}/#{project}"
              versions = Pathname.glob("#{project_dir}/*").select {|f|
                f.directory?
              }.map {|d| d.basename.to_s}

              latest = site.config['lock_latest'][project] || PuppetDocs::Versions.latest(versions) || 'latest' # last one just in case we've deleted them all.
              path_dirs[ path_dirs.index('latest') ] = latest
              full_path = path_dirs.join('/')
            end
          end

          # Handle Jekyll's "friendly" index.html URL trimming
          full_path.sub!(%r{/index\.html$}, '/')

          destination = site.pages.detect {|pg| pg.url == full_path or pg.relative_path == full_path or pg.url == "#{full_path}/"}
          # that last one is because /puppet/4.3/reference is known to Jekyll as /puppet/4.3/reference/.
        end

        if destination.nil? # then there's no page by that name; we'll skip anchors no matter what, but we'll check static files and redirects before calling it broken.
          if site.static_files.detect {|thing| thing.url == full_path}
            # It's an image or something, and the link is good. Do nothing.
          elsif redirections.detect {|match| full_path =~ match }
            # This links to something that got redirected. It should probably be updated eventually.
            link_test_results[page.relative_path][:redirected] << link
          else
            # Finally, we're willing to call it broken.
            link_test_results[page.relative_path][:broken_path] << link
          end
        else # we found a "real" page, so go ahead and check the anchors.
          if anchor != nil and anchor != '' and destination.content !~ /id=(['"])#{anchor}\1/ # then we couldn't find that anchor.
            link_test_results[page.relative_path][:broken_anchor] << link
          end
        end
      }
    end

    # Clean the results
    link_test_results.each do |_filename, tally|
      tally.reject! {|_kind, links| links.empty?}
    end
    link_test_results.reject! {|_filename, tally| tally.empty?}
    File.open("#{File.dirname(site.source)}/link_test_results.yaml", 'w') {|f| f.write( YAML.dump(link_test_results) )}
    puts "Finished checking links! See #{File.dirname(site.source)}/link_test_results.yaml for the details."

  end
end
