require 'jekyll/document'
require 'pathname'
require 'byebug'

# Let's crack this open and see what's in there.

module Jekyll
  class InvestigateGenerator < Generator
    # priority :lowest

    def generate(site)
      puts 'about to do the thing'
      puts Time.now.to_s
      byebug

      documents = site.config['documents']

      site.pages.each do |page|
        (base_url, data) = doc_for_page(page.url, documents)
        next if data.nil?
        page.data['doc'] = data
        page.data['nav'] = data['nav']
      end

      puts 'did the thing.'
      puts Time.now.to_s
      byebug
      puts 'hey'

    end

    # Takes a page URL and a whole documents hash.
    # Returns a two-element array [doc_baseurl, doc_data].
    def doc_for_page(page_url, documents)
      documents.detect {|url, data| Regexp.new("^#{url}") =~ page_url}
    end

    # Original:
    # /pe/2015.3:
    #   doc: pe
    #   version: 2015.3
    #   nav: ./_pe_toc.html
    #   external_source:
    #     repo: git@github.com:puppetlabs/pe-docs-private.git
    #     commit: origin/pe2015.3.1
    #     subdirectory: source
    #   my_versions:
    #     puppet: 4.3
    #     facter: 3.1
    #     hiera: 3.0
    #     puppetserver: 2.2
    #     puppetdb: 3.2

    # Munged for pages:
    # /pe/2015.3:
    #   base_url: /pe/2015.3
    #   doc: pe
    #   version: 2015.3
    #   nav: /pe/2015.3/_pe_toc.html
    #   external_source:
    #     repo: git@github.com:puppetlabs/pe-docs-private.git
    #     commit: origin/pe2015.3.1
    #     subdirectory: source
    #   my_versions:
    #     puppet: 4.3
    #     facter: 3.1
    #     hiera: 3.0
    #     puppetserver: 2.2
    #     puppetdb: 3.2

    # site.config['document_list']:
    # pe:
    #   2015.3: /pe/2015.3
    #   3.8: /pe/3.8
    # puppet:
    #   4.3: /puppet/4.3/reference

  end
end

