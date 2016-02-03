require 'jekyll/document'
require 'pathname'

module Jekyll
  class DocumentDataGenerator < Generator

    # If a page is part of a large versioned document (as defined by the 'documents' list in
    # the puppet-docs config file), give it a reference to its document and set its nav snippet.
    # This modifies pages in-place before they are rendered, and makes new data available in
    # both layouts and content.
    def generate(site)
      documents = site.config['document_list']

      site.pages.each do |page|
        (base_url, data) = doc_for_page(page.url, documents)
        next if data.nil?
        page.data['doc'] = data
        page.data['nav'] = data['nav']
      end
    end

    # Takes a page URL and a whole documents hash.
    # Returns a two-element array [doc_baseurl, doc_data].
    def doc_for_page(page_url, documents)
      documents.detect {|base_url, data| Regexp.new("^#{base_url}") =~ page_url}
    end

  end
end
