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

  # Set special shortcut variables ( {{puppet}}, {{pe}}, etc.) for linking to our main documents.
  # These resolve to the *base URL* of the "correct" version of a given document. So for example,
  # {{puppet}} would render as /puppet/4.3/reference, or whatever.
  # (This means we can't ever release a product called "page" or "site," but I'm really not concerned about that???)
  document_version_index = payload['site']['document_version_index']
  if data
    # If we're coming from a versioned doc, link to our known version. (Defaults to latest if no one claimed anyone.)
    data['my_versions'].each do |doc, version|
      payload[doc] = document_version_index[doc][version]
    end
  else
    # Fall back to latest if this isn't a versioned doc.
    document_version_index.each do |doc, versions|
      payload[doc] = versions['latest']
    end
  end

end
