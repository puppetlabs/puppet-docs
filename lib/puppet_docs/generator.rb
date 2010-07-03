module PuppetDocs
  class Generator
    attr_reader :output, :view_path, :view, :source_dir

    class MissingPrologueError < ::ArgumentError; end

    def initialize(output = nil)
      @source_dir = File.join(File.dirname(__FILE__), '..', '..')

      @output = output || File.join(@source_dir, "output")

      unless ENV["ONLY"]
        FileUtils.rm_r(@output) if File.directory?(@output)
        FileUtils.mkdir(@output)
      end
      create_log_directory!

      @view_path = File.join(@source_dir, "source")
    end

    def generate
      puts "Logging in #{log_filename}"
      guides = Dir[File.join(view_path, '**/*.{markdown,erb}')].reject { |p| p.include?('#') || p.include?('html') || p.include?('references') }
      refs = Dir[File.join(view_path, 'references/**/*.{markdown,erb}')].reject { |p| p.include?('#') || p.include?('html') }

      if ENV["ONLY"]
        only = ENV["ONLY"].split(",").map{|x| x.strip }.map {|o| "#{o}.markdown" }
        guides = guides.find_all {|g| only.include?(g) }
        puts "GENERATING ONLY #{guides.inspect}"
      end

      guides.each do |guide|
        generate_guide(guide)
      end

      refs.each do |ref|
        generate_ref(ref)
      end

      copy_html

      # Copy images and css files to html directory
      FileUtils.cp_r File.join(source_dir, 'images'), File.join(output, 'images')
      FileUtils.cp_r File.join(source_dir, 'files'), File.join(output, 'files')
    end

    def copy_html
      html = Dir[File.join(view_path, '**/*.html')].reject { |p| p.include?('#') }
      html.each do |filename|
        new_path = filename.sub(view_path, output)
        start_progress filename[view_path.size..-1]
        FileUtils.mkdir_p(File.dirname(new_path)) rescue nil
        FileUtils.cp filename, new_path
        stop_progress 'COPIED'
      end
    end

    def generate_ref(ref)
      ref =~ /(.*?)(\.markdown(?:\.erb))?$/
      name = $1
      ext = $2

      rel_path = ref.sub(view_path, '')[1..-1]
      slug = ext ? File.basename(rel_path, ext) : File.basename(rel_path, '.markdown')

      planned_path = File.join(output, File.dirname(rel_path), slug) + '.html'

      start_progress(name[view_path.size..-1] + (ext || ''))

      FileUtils.mkdir_p(File.dirname(planned_path)) rescue nil

      view = View.new(:to_root => '../' * rel_path.scan(/\//).size)

      File.open(planned_path, 'w') do |f|

        body = raw_body(ref, view)

        title, body = set_ref_header_section(name, body, view)
        unless title && body
          stop_progress 'MISSING PROLOGUE'
          return false
        end
        body = add_snippets(body)
        body = add_extras(body)
        body = set_index(title, body, view)

        result = view.render(markdown(body, true))
        f.write result
        warn_about_broken_links(result) if ENV.key?("WARN_BROKEN_LINKS")
        stop_progress 'GENERATED'
      end
    rescue => err
      puts err.inspect
      puts err.backtrace
      stop_progress 'ERROR'
    end

    def generate_guide(guide)
      guide =~ /(.*?)(\.markdown(?:\.erb))?$/
      name = $1
      ext = $2

      rel_path = guide.sub(view_path, '')[1..-1]
      slug = ext ? File.basename(rel_path, ext) : File.basename(rel_path, '.markdown')

      planned_path = File.join(output, File.dirname(rel_path), slug) + '.html'

      start_progress(name[view_path.size..-1] + (ext || ''))

      FileUtils.mkdir_p(File.dirname(planned_path)) rescue nil

      view = View.new(:to_root => '../' * rel_path.scan(/\//).size)

      File.open(planned_path, 'w') do |f|

        body = raw_body(guide, view)

        title, body = set_header_section(name, body, view)
        unless title && body
          stop_progress 'MISSING PROLOGUE'
          return false
        end
        body = add_snippets(body)
        body = add_extras(body)
        body = set_index(title, body, view)

        result = view.render(markdown(body, true))
        f.write result
        warn_about_broken_links(result) if ENV.key?("WARN_BROKEN_LINKS")
        stop_progress 'GENERATED'
      end
    rescue => err
      puts err.inspect
      puts err.backtrace
      stop_progress 'ERROR'
    end

    def set_header_section(name, body, view)
      header, new_body = body.split(/\*\s+\*\s+\*/, 2)
      if new_body
        if header =~ /^(\S[^\r\n]+)\r?\n=+\s*$/ms
          page_title = $1.strip
        else
          return false
        end
        header = markdown(add_snippets(header))
        view.set(:page_title, page_title)
        view.set(:header_section, header)
        [page_title, new_body]
      else
        # Did not provide a prologue separator
        false
      end
    end

    def set_ref_header_section(name, body, view)
      header, new_body = body.split(/\*\*This page .*\*\*$|\*\(last generated .*\)\*$/, 2)
      if new_body
        if header =~ /^\%\s(\S[^\r\n]+)\r?\n\%\s*$/ms
          page_title = $1.strip
          header = ''
        else
          return false
        end
        header = markdown(add_snippets(header))
        view.set(:page_title, page_title)
        view.set(:header_section, header)
        [page_title, new_body]
      else
        # Did not provide a prologue separator
        false
      end
    end

    def set_index(title, body, view)
      index = <<-INDEX
      <div id="subCol">
        <h3 class="chapter">Contents</h3>
        <ol class="chapters">
      INDEX

      html = ''
      logging do
        html = Maruku.new("#{title}\n#{'=' * title.size}\n\n#{body}\n\n* Create TOC\n{:toc}").to_html_document
      end
      doc = Nokogiri(html)
      toc = doc.css('.maruku_toc')
      children = toc.css('ul').first.children
      return body if children.empty?
      index << children.to_s

      index << '</ol>'
      index << '</div>'

      view.set(:index_section, index)

      body
    end

    def raw_body(path, view)
      body = File.read(path)
      if path =~ /\.markdown\.erb$/
        raw_content = File.read(path)
        view.set_local :page, Pathname.new(path)
        view.render(body, :layout => false)
      else
        body
      end
    end

    def markdown(body, include_settings = false)
      body = settings_content + body if include_settings
      logging do
        Maruku.new(body).to_html
      end
    end

    def add_extras(body)
      body.gsub(/^(NOTE|INFO|WARNING)(?:\.|\:)(.*?)(?:\r?\n){2,}/m) do |m|
        css_class = $1.downcase
        result = "<div class='#{css_class}'>"
        result << markdown($2.strip)
        result << "</div>\n\n"
        result
      end
    end

    def add_snippets(body)
      Snippet.process(body)
    end

    def warn_about_broken_links(html)
      anchors = extract_anchors(html)
      check_fragment_identifiers(html, anchors)
    end

    def extract_anchors(html)
      # Markdown generates headers with IDs computed from titles.
      anchors = Set.new
      html.scan(/<h\d\s+id="([^"]+)/).flatten.each do |anchor|
        if anchors.member?(anchor)
          puts "*** DUPLICATE HEADER ID: #{anchor}, please consider rewording" if ENV.key?("WARN_DUPLICATE_HEADERS")
        else
          anchors << anchor
        end
      end

      # Also, footnotes are rendered as paragraphs this way.
      anchors += Set.new(html.scan(/<p\s+class="footnote"\s+id="([^"]+)/).flatten)
      return anchors
    end

    def check_fragment_identifiers(html, anchors)
      html.scan(/<a\s+href="#([^"]+)/).flatten.each do |fragment_identifier|
        next if fragment_identifier == 'mainCol' # in layout, jumps to some DIV
        unless anchors.member?(fragment_identifier)
          guess = anchors.min { |a, b|
            Levenshtein.distance(fragment_identifier, a) <=> Levenshtein.distance(fragment_identifier, b)
          }
          puts "*** BROKEN LINK: ##{fragment_identifier}, perhaps you meant ##{guess}."
        end
      end
    end

    def log_filename
      @log_filename ||= PuppetDocs.root + 'log' + 'generator.log'
    end

    # Maruku's logging control is spotty (even using :on_error and
    # :error_stream); for now we redirect $stderr output to keep it quiet.
    def logging(&block) #:nodoc:
      result = nil
      log_filename.open('a') do |log|
        real = $stderr
        $stderr = log
        result = yield
        $stderr = real
      end
      result
    end

    def create_log_directory!
      log_filename.parent.mkpath
    end

    def settings_content
      @settings_content ||=
        begin
          settings_filename = File.join(view_path, 'settings.txt')
          if File.exist?(settings_filename)
            File.read(settings_filename)
          else
            ''
          end
        end
    end

    def start_progress(name)
      print('%-70s ' % "#{name} ...")
    end

    def stop_progress(result)
      puts "[#{result}]"
    end

  end
end
