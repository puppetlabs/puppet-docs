module PuppetGuides

  class Snippet

    def self.cache
      @cache ||= {}
    end

    def self.[](name)
      name = name.to_s.downcase
      cache[name] ||= new(name)
    end

    def initialize(name)
      @name = name
    end

    def to_s
      content
    end

    private

    def filename
      @filename ||= PuppetGuides.root + "snippets/#{@name}.markdown"
    end

    def content
      @content ||=
        if filename.exist?
          filename.read
        else
          ''
        end
    end
    
  end

end
