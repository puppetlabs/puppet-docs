require 'pathname'


module Rack
  class DirectoryWithIndexes < Rack::Directory
    def initialize(*args)
      super
    end

    def list_path_2x(env, path, path_info, script_name)
      stat = ::File.stat(path)

      if stat.readable?
        return @app.call(env) if stat.file?
        if stat.directory?
          index = Pathname.new(path) + 'index.html'
          if index.readable?
            env['PATH_INFO'] = env['PATH_INFO'].sub(/\/?$/, '/index.html')
            return @app.call(env)
          else
            return list_directory(path_info, path, script_name)
          end
        end

      else
        raise Errno::ENOENT, 'No such file or directory'
      end

    rescue Errno::ENOENT, Errno::ELOOP
      return entity_not_found(path_info)
    end

    def list_path
      @stat = ::File.stat(@path)

      if @stat.readable?
        return @app.call(@env) if @stat.file?
        if @stat.directory?
          index = Pathname.new(@path) + 'index.html'
          if index.readable?
            @env['PATH_INFO'] = @env['PATH_INFO'].sub(/\/?$/, '/index.html')
            return @app.call(@env)
          else
            return list_directory
          end
        end
      else
        raise Errno::ENOENT, 'No such file or directory'
      end

    rescue Errno::ENOENT, Errno::ELOOP
      return entity_not_found
    end

  end
end

puts ">>> Serving at http://localhost:9292"

run Rack::DirectoryWithIndexes.new(Pathname.new(__FILE__).parent + 'output')
