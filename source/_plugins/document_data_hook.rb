Jekyll::Hooks.register :pages, :pre_render do |page, payload|
  # Find out whether this page is part of a large versioned document (as defined by the 'documents' list in
  # the puppet-docs config file)
  documents = payload['site']['document_list']
  (base_url, data) = documents.detect {|base_url, data| Regexp.new("^#{base_url}") =~ payload['page']['url'] }

  # If so, give it a reference to its document and set its nav snippet.
  # This makes new data available under "page.doc" in both layouts and content.
  if data
    payload['page']['doc'] = data
    payload['page']['nav'] = data['nav']
  end


end
