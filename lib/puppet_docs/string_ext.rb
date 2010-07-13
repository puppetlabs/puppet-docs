module PuppetDocs

  module StringExt

    def underscore
      to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def titleize
      underscore.gsub(/\b('?[a-z])/) { $1.capitalize }
    end

  end

end
