module PuppetDocs

  class View

    def self.layout
      if ENV.fetch("PDF","") != ""
          path = PuppetDocs.root + "source/layout_pdf.html.erb"
      else
          path = PuppetDocs.root + "source/layout.html.erb"
      end
      path.read
    end

    # FIXME: I'm not sure why we want to do this.  Disabling for now.
    #def self.layout=(text)
    #  @layout = text
    #end

    def self.render_defaults
      @render_defaults ||= {:layout => true}
    end

    def initialize(data = {})
      @data    = Erubis::Context.new(data)
      class << @data; include PuppetDocs::Helpers; end
    end

    def set(name, value)
      @data[name] = value
    end

    def set_local(name, value)
      set(name, value)
      (class << @data; self; end).instance_eval "attr_reader :#{name}"
    end

    def [](name)
      @data[name]
    end

    def render(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options = self.class.render_defaults.merge(options)
      text = args.shift
      result = Erubis::Eruby.new(text).evaluate(@data, &data_access(nil))
      if options[:layout]
        if self.class.layout
          result = Erubis::Eruby.new(self.class.layout).evaluate(@data, &data_access(result))
        end
      end
      result
    end

    private

    def data_access(text = nil)
      proc do |*sections|
        if !sections.empty?
          @data[sections.first]
        else
          text
        end
      end
    end

  end

end
