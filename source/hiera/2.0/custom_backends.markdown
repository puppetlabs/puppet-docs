---
layout: default
title: "Hiera 2: Writing Custom Backends"
---

{% partial /hiera/_hiera_update.md %}

Custom Hiera backends must be written in Ruby, must conform to certain API requirements, and must be available in Ruby's load path; when using Hiera with Puppet, you can load backends from the `lib` directory of Puppet modules. Backends that retrieve data from multiple files on disk (similar to the default `yaml` and `json` backends) can take advantage of [extra helper methods](#available-helper-methods) provided by the `Backend` Ruby module.

Backend API Versions
-----

This page describes the updated custom backend API used in Hiera 2.0. If you define a `lookup()` method that takes **five arguments,** as described below, your backend will behave as described on this page.

If you define a `lookup()` method that takes **four arguments,** your backend will behave [as described in the Hiera 1 docs.](/hiera/1/custom_backends.html)

[The main differences are described in the Hiera 2.0 release notes.](./release_notes.html#api-change-for-custom-backends-backwards-compatible)

Backend API and Requirements
-----

### Namespace and Name

Each Hiera backend must be a Ruby class under the `Hiera::Backend` namespace. This most often means nesting the class inside `class Hiera` and `module Backend` statements.

You must choose a unique **short common name** for your backend, and derive a **class name** from that short name. The class name should be the backend name with a capitalized first letter and a `_backend` suffix. So a backend named `file` would have a class name of `File_backend`.

~~~ ruby
    class Hiera
      module Backend
        class File_backend
          # ...
        end
      end
    end
~~~

### Filename/Path

By standard Ruby code loading conventions, the file containing a backend should be located in a Ruby lib directory with a sub path of `hiera/backend/<LOWERCASED CLASS NAME>.rb`.

When using Hiera with Puppet, you can load backends from the `lib` directory of a Puppet module; however, these backends won't be loaded when you run Hiera from the command line unless you specify that directory in your `RUBYLIB` environment variable.

A backend named `file` would be located in a lib directory at `hiera/backend/file_backend.rb`.

### `initialize` Method

If you have any setup to do in your backend before you can look up data --- for example, loading a library necessary for interfacing with a database --- you should put it in an `initialize` method. From the crayfishx/hiera-mysql backend:

~~~ ruby
    def initialize
      begin
        require 'mysql'
      rescue LoadError
        require 'rubygems'
        require 'mysql'
      end

      Hiera.debug("mysql_backend initialized")
    end
~~~

### `lookup` Method

Every backend must define a `lookup(key, scope, order_override, resolution_type, context)` method, which must either return a value or throw the symbol `:no_such_key`.

The returned value can be a string, number, boolean, array, hash, or `nil`.

If no value is found, the lookup method should call `throw(:no_such_key)` to indicate this.

The lookup method can do basically anything to acquire its value, but usually uses [the `Backend.datasources` method][datasources] to iterate over the hierarchy (see below).

When Hiera calls the lookup method, it passes five pieces of data as arguments:

* `key` is the lookup key.
* `scope` is the set of [variables](./variables.html) available to make decisions about the hierarchy and perform data interpolation.
* `order_override` is a requested first hierarchy level, which can optionally be inserted at the top of the hierarchy.
* `resolution_type` is the requested [lookup type](./lookup_types.html). Values can be either a Symbol (`:priority`, `:array`, or `:hash`) or a Hash like `{:behavior => 'deeper', 'knockout_prefix' => 'xx'}`. If you pass a Hash, the configured values for `:merge_behavior` and `:deep_merge_options` will be ignored. Passing a Hash gives you the same `resolution_type` as `:hash`, but with the option to allow the deep_merge options on a per-call basis.
* `context` is a hash that contains a key named `:recurse_guard`. You never need to call methods on this object, but you'll need to pass it along later if you make any calls to `Backend.parse_answer` or `Backend.parse_string`. This parameter helps Hiera correctly propagate the order_override and the recursion guard used for detecting endless lookup recursions in interpolated values.

~~~ ruby
    class Hiera
      module Backend
        class File_backend
          def lookup(key, scope, order_override, resolution_type, context)
            answer = nil
            # ...
            return answer
          end
        end
      end
    end
~~~


### Available Helper Methods

Index of methods:

- [`Backend.datasources`][datasources]
- [`Backend.datafile`][datafile]
- [`Backend.parse_answer`][parse_answer]
- ['Backend.parse_string`][parse_string]
- [`Backend.merge_answer`][merge_answer]
- [`Hiera.debug` and `Hiera.warn`][logging]

A backend's lookup method can construct its own arbitrary hierarchy and do anything to retrieve data. However:

* You usually want to iterate over Hiera's normal configured [hierarchy](./hierarchy.html).
* You might want to locate data files in a directory.
* You might want to allow values in the looked-up data to [interpolate dynamic values](./variables.html#in-data).
* You might want to accommodate hash merge lookups.
* You might want to log messages to assist debugging.

The Hiera::Backend module provides helper methods for the first four, and the Hiera class provides logging methods.

#### `Backend.datasources(scope, [order_override], [hierarchy]) {|source| ... }`

[datasources]: #backenddatasourcesscope-orderoverride-hierarchy-source--

The `Backend.datasources` method finds a [hierarchy](./hierarchy.html) (usually from the config file), interpolates any dynamic values, removes any empty hierarchy levels, then iterates over it with a provided block of code, calling the block once for each hierarchy level. You will almost always want to use this method, as it's the easiest way to take advantage of the configured hierarchy.

The **block** passed to this method must take one argument (which will be a hierarchy level, with any interpolation already performed). It does not need to return anything, and will usually modify an existing variable outside its scope in order to set an answer. This block will do most of the heavy lifting in your backend, accessing any data sources you need to consult.

The **arguments** passed to this method are a scope, an order override (optional), and a replacement hierarchy (optional). Usually, you will pass along the `scope` and `order_override` values that your `lookup` method received and omit the hierarchy argument, so that you can use the normal hierarchy from the config file.

When doing a priority lookup, you should generally use a `break` statement in your block once you get a valid answer, in order to exit early and not overwrite the highest priority answer with a lower priority answer.


~~~ ruby
    class Hiera
      module Backend
        class File_backend
          def lookup(key, scope, order_override, resolution_type, context)
            answer = nil
            Backend.datasources(scope, order_override) do |source|
              # ...
              break if answer = ...
            end
            return answer
          end
        end
      end
    end
~~~


#### `Backend.datafile(:<BACKEND NAME>, scope, source, "<EXTENSION>")`

[datafile]: #backenddatafilebackend-name-scope-source-extension

The `Backend.datafile` method returns a string, representing the complete path to a file on disk corresponding to a provided hierarchy level. The backend author is in charge of deciding what to do with this path and the file it represents.

It is optional, and is only useful when your backend is searching files on disk. It provides facilities similar to those in the `yaml` and `json` backends. To use this, you must set a `:datadir` setting in hiera.yaml under a key named for your backend:

    :file:
      :datadir: /etc/puppetlabs/code/hieradata/

The arguments you must provide are the **name of the backend** (as a symbol), the **scope** (usually just passed on from the lookup method's arguments), the **current hierarchy level** (usually passed to the current block by the `Backend.datasources` method), and the **file extension** to expect.

~~~ ruby
    class Hiera
      module Backend
        class File_backend
          def lookup(key, scope, order_override, resolution_type, context)
            answer = nil
            Backend.datasources(scope, order_override) do |source|
              file = Backend.datafile(:file, scope, source, "d") or next
              path = File.join(file, key)
              next unless File.exist?(path)
              data = File.read(path)
              next unless data
              break if answer = data
            end
            return answer
          end
        end
      end
    end
~~~


#### `Backend.parse_answer(data, scope, extra_data={}, context={:recurse_guard => nil, :order_override => nil})`

[parse_answer]: #backendparseanswerdata-scope

The `Backend.parse_answer` method returns its first argument, but with any [interpolation tokens](./variables.html) replaced by variables from the scope passed as its second argument. Use it if you want to support interpolation of dynamic values into data with your backend. (This is optional.)

~~~ ruby
    class Hiera
      module Backend
        class File_backend
          def lookup(key, scope, order_override, resolution_type, context)
            answer = nil
            Backend.datasources(scope, order_override) do |source|
              file = Backend.datafile(:file, scope, source, "d") or next
              path = File.join(file, key)
              next unless File.exist?(path)
              data = File.read(path)
              next unless data
              break if answer = Backend.parse_answer(data, scope, extra_data, context)
            end
            return answer
          end
        end
      end
    end
~~~

You can also pass a hash of extra data as an optional third argument. This hash is used like the scope to provide variables for interpolation, but _only_ if the scope fails to produce a match for that variable. Your backend can use this to provide fallback data from some other source.

Context is an optional hash with two keys --- `:recurse_guard` and `:order_override`. This allows your backend to take advantage of bug fixes that preserve your order override and prevent recurse loops. Your lookup method should have already received a partial context hash, plus a separate `order_override` argument, so you should be able to just add that `order_override` to the existing hash:

	`context[:order_override] = order_override`

Note that the `context` parameter must be the fourth argument called on this helper, so if you use it, you'll also need to use the `extra_data` parameter, even if you just give `extra_data` an empty hash.

#### `Backend.parse_string(data, scope, extra_data={}, context={:recurse_guard => nil, :order_override => nil})`

[parse_string]: #backendparsestringdata-scope

You won't normally need to call the `Backend.parse_string` method. Instead, if you pass a string argument to `Backend.parse_answer`, it delegates that call to `Backend.parse_string` for resolution. (If the value is an array or a hash, then `Backend.parse_answer` iterates and recursively calls itself for each element. This ensures that all interpolations are found and resolved, even if the string is deeply nested into hashes and arrays.)

The `Backend.parse_string` method resolves interpolated strings. For example, 'Hello %{somekey}' becomes 'Hello world' if a lookup with the key 'somekey' yields the string 'world'. A Hiera lookup can produce values that are strings, hashes, arrays, booleans, or numbers, but only values of type string can be passed to `Backend.parse_string`.

If you do need to explicitly call `Backend.parse_string` for some reason, you'll want to use the context parameter as described in [Backend.parse_answer][parse_answer] above.

#### `Backend.merge_answer(new_answer, answer, resolution_type=nil)`

[merge_answer]: #backendmergeanswernewansweranswer

The `Backend.merge_answer` method expects three arguments, and returns a merged hash using the [configured hash merge behavior](./lookup_types.html#hash-merge). If your backend supports hash merge lookups, you should always use this helper method to do the merging.

In passing `resolution_type` to `Backend.merge_answer`, you'll need to pass, verbatim, the `resolution_type` value you received in your `lookup` method.

From the json backend:

~~~ ruby
    new_answer = Backend.parse_answer(data[key], scope, extra_data{}, context[:recurse_guard])
    case resolution_type
    when :array
      raise Exception, "Hiera type mismatch: expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
      answer ||= []
      answer << new_answer
    when :hash
      raise Exception, "Hiera type mismatch: expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
      answer ||= {}
      answer = Backend.merge_answer(new_answer,answer, resolution_type=nil)
    else
      answer = new_answer
      break
    end
~~~

#### `Hiera.debug(msg)` and `Hiera.warn(msg)`

[logging]: #hieradebugmsg-and-hierawarnmsg

These two methods log messages at the debug and warn loglevels, respectively.

~~~ ruby
    def initialize
      Hiera.debug("Hiera File backend starting")
    end
~~~

Tips
----

### Handling Lookup Types

Your backend should generally support all three [lookup types](./lookup_types.html). In Hiera 2, the lookup type passed to your `lookup` method (as the fourth argument) will always be one of:

- `:priority`
- `:array`
- `:hash`

Usually, the block you pass to `Backend.datasources` will contain a case statement that decides what to do based on the lookup type. [An example of this is shown above in the description of the `Backend.merge_answer` method.][merge_answer]

* Priority lookups should stop iterating over the hierarchy as soon as a valid value is found.
* Array lookups should continue iterating and append any new answers onto an array of existing answers.
* Hash lookups should continue iterating and use [the `Backend.merge_answer` method][merge_answer] to merge any new answers into a hash of existing answers.

### What To Do and Not Do in the Datasources Block

In our examples here, the block passed to the [`Backend.datasources` method][datasources] is doing all of the data lookup work and is directly modifying the answer that will eventually be returned by the `lookup` method. This makes sense for simple file-based backends, where lookups are resource-cheap.

It may make less sense if both of the following are true:

- Lookups are relatively resource-expensive compared to local text files, such as anything requiring a request over the network.
- It's possible to construct complex requests (think SQL) which aren't significantly more expensive than simple requests.

In this case, you might want to use the hierarchy iterator block to construct a complex request, then issue that request outside the block after the `Backend.datasources` call has finished.

This way, you could get answers for every hierarchy level at once, and make decisions about which answer(s) to use once you have the full results in your hand. If your data is highly hierarchical and you frequently have lookup misses at the top of the hierarchy (say most of your data is in fact-based hierarchy levels, and only a few answers are ever assigned directly to individual nodes), this might double your backend's performance.


Complete Example
-----

This backend was written as an example by Reid Vandewiele. It only handles priority lookups, and only handles string values. It expects a collection of `hierarchy_level.d` directories containing files named after lookup keys; when looking up a key, the contents of the file corresponding to that key will be returned as a string.

### Terse Version

~~~ ruby
class Hiera
  module Backend
    class File_backend

      def initialize
        Hiera.debug("Hiera File backend starting")
      end

      def lookup(key, scope, order_override, resolution_type, context)
        answer = nil

        Hiera.debug("Looking up #{key} in File backend")

        Backend.datasources(scope, order_override) do |source|
          Hiera.debug("Looking for data source #{source}")
          file = Backend.datafile(:file, scope, source, "d") or next
          path = File.join(file, key)
          next unless File.exist?(path)
          data = File.read(path)
          next unless data
          break if answer = Backend.parse_answer(data, scope, extra_data, context)
        end
        return answer
      end

    end
  end
end
~~~

### Annotated Version

~~~ ruby
# This is an annotated walkthrough of a *very* simple custom backend for Hiera,
# which uses a directory-based file lookup scheme.
#
# First: skip the rest of this comment block and take a dive into the code.
#
# Then:  read the following note about additional resources
#
# Additional Resources:
#
# If after reading through this you would like some additional resources, example
# code is currently pretty good documentation since Hiera is fundamentally simple
# under the hood. If you check out a few existing backends you're quite likely to
# pick up other tricks and ideas. A few good backends to take a look at include:
#
# https://github.com/puppetlabs/hiera/blob/master/lib/hiera/backend/yaml_backend.rb
# https://github.com/puppetlabs/puppet/blob/master/lib/hiera/backend/puppet_backend.rb
# https://github.com/adrienthebo/hiera-file (the grown-up version of this example)
# https://github.com/binford2k/hiera-rest
#
# See also https://github.com/puppetlabs/hiera/blob/master/lib/hiera/backend.rb for
# other included utility functions.
#

# Filename: lib/hiera/backend/file_backend.rb

class Hiera
  module Backend

    # The naming convention here is the backend name ("file"), first letter
    # upcased, and given the suffix "_backend".
    class File_backend

      # This method contains any code necessary to start using the backend. In
      # a network-based backend perhaps this method might contain code to
      # establish a connection to a database or API, for example.
      def initialize
        Hiera.debug("Hiera File backend starting")
      end

      # The lookup function is the most important part of a custom backend.
      # The lookup function takes five arguments which are:
      #
      # @param key [String]             The lookup key specified by the user
      #
      # @param scope [Hash]             The variable scope. Contains fact
      #                                 values and all other variables in
      #                                 scope when the hiera() function was
      #                                 called. Most backends will not make
      #                                 use of this data directly, but it will
      #                                 need to be passed in to a variety of
      #                                 available utility methods within Hiera.
      #
      # @param order_override [String]  Like scope, a parameter that is
      #                                 primarily simply passed through
      #                                 to Hiera utility methods.
      #
      # @param resolution_type [Symbol] Hiera's default lookup method is
      #                                 :priority, in which the first value
      #                                 found in the hierarchy should be
      #                                 returned as the answer. Other lookup
      #                                 resolution methods exist. For example,
      #                                 :array returns all answers found from
      #                                 all levels of the hierarchy in an
      #                                 array. This parameter allows the
      #                                 backend to implement multiple
      #                                 resolution types. This particular
      #                                 example does not support multiple
      #                                 resolution types, and will only do
      #                                 priority lookups.
      #
      # @param context [Hash]           Contains a key named `:recurse_guard`. This hash
      #                                 is passed to `Backend.parse_answer` and
      #                                 `Backend.parse_string` to help Hiera correctly
      #                                 propagate the order_override and prevent endless
      #                                 lookup recursions in interpolated values.
      #

      def lookup(key, scope, order_override, resolution_type, context)

        # Set the default answer. Returning nil from the lookup() method
        # indicates that no value was found. In this example hiera backend,
        # we start by assuming no match, and will then try to find a match at
        # each level of the hierarchy. If by the time we complete our
        # traversal of the hierarchy and have not found an answer, then this
        # default value of nil will be returned.
        answer = nil

        Hiera.debug("Looking up #{key} in File backend")

        # Calling this method constructs a list of data sources to search. By
        # default, for a hierarchy such as:
        #
        #     ---
        #     :hierarchy:
        #       - "%{clientcert}"
        #       - "%{environment}"
        #       - global
        #
        # The datasources() method, being given the scope parameter and a nil
        # order_override parameter, will return something like:
        #
        #     [ "client01.example.com", "development", "global" ]
        #
        # Note that interpolation of the %{clientcert} and %{environment}
        # tokens has been performed, using values from the scope
        # parameter. If a value is given for order_override that value will be
        # inserted at the top of the hierarchy. For example, given an
        # order_override value of "custom", the datasources() method will return
        # something like:
        #
        #     [ "custom", "client01.example.com", "development", "global" ]
        #
        # Once we have this hierarchy list, we will perform some kind of
        # lookup, starting with the top of the hierarchy and continuing
        # until either we find a match or reach the end of the hierarchy
        # list.
        Backend.datasources(scope, order_override) do |source|
          Hiera.debug("Looking for data source #{source}")

          # datafile() is a utility method to check for the existence of an
          # approprate datafile for the current datasource and if it exists,
          # return the full path to it. This utility method may be used if the
          # custom backend adheres to a couple of conventions. The datafile()
          # method assumes that:
          #
          #   1. As part of the lookup, the custom backend expects a file to
          #      exist which corresponds to the current datasource.
          #   2. The configuration setting :datadir: is used in the custom
          #      backend.
          #   3. Each datafile, located under :datadir:, has a standard
          #      extension.
          #
          # The arguments given to datafile are
          #
          # @param backend [Symbol]   The name of the backend. This is used to
          #                           refer to the appropriate setting key in
          #                           hiera.yaml.
          #
          # @param scope [Hash]       The current scope. Interpolation could
          #                           be performed on the value of :datadir:,
          #                           and interpolation requires a scope.
          #
          # @param source [String]    The current datasource, or level in the
          #                           hierarchy, for which a datafile is being
          #                           searched.
          #
          # @param extension [String] The extension used by all datafiles. The
          #                           datafile() method will search for the
          #                           file by cat'ing "#{source}.#{extension}".
          #
          # In example form, the datafile() method works for a custom backend
          # "foo" if hiera.yaml contains something like:
          #
          #     ---
          #     :backends:
          #       - foo
          #     :hierarchy:
          #       - "%{clientcert}"
          #       - global
          #     :foo:
          #       :datadir: /etc/puppetlabs/puppet/hieradata
          #
          # And the hieradata directory contains something like:
          #
          #     `-- hieradata
          #         |-- client1.example.com.foo
          #         |-- client2.example.com.foo
          #         |-- client3.example.com.foo
          #         `-- global.foo
          #
          # And the datafile() method is called something like:
          #
          #     Backend.datafile(:foo, scope, source, "foo")
          #
          # In this example backend called "file" we expect there to exist a
          # *.d directory for each datasource, and we will use the datafile()
          # method to check for and return its path if it exists. Custom
          # backends that do not use files for anything will probably not use
          # this method.
          file = Backend.datafile(:file, scope, source, "d") or next

          # For this example file backend we expect every source to be a *.d
          # directory, and we will look for a file in the directory with the
          # name of the specified key. The next few lines in essence take the
          # file name determined by using the datafile() method and check to
          # see if that directory contains a file named with the key. E.g. if
          # the user passed the key "myvalue1", and for a given datasource
          # (level in the hierarchy) the file path was "/hieradata/global.d",
          # these next few lines will check to see if
          # "/hieradata/global.d/myvalue1" exists and contains data. If any of
          # these preconditions fails, we will abort and move on to the next
          # datasource.
          path = File.join(file, key)
          next unless File.exist?(path)
          data = File.read(path)
          next unless data

          # Using the parse_answer() method is important if we want to be able
          # to use templated or scoped data. Calling parse_answer() on the data
          # will cause Hiera to perform interpolation, looking for
          # instances of the %{} syntax. Any instance found will be replaced
          # with the value from the scope. Finally, the "break" statement is
          # used to stop traversing datasources, as we have found and set our
          # answer.
          break if answer = Backend.parse_answer(data, scope, extra_data, context)
        end
        # The return value of this method is the result of the hiera lookup.
        return answer
      end
    end
  end
end
~~~

More Examples
-----

Read the code for Hiera's built-in yaml and json backends to learn more about looking up data from files on disk:

- [json](https://github.com/puppetlabs/hiera/blob/master/lib/hiera/backend/json_backend.rb)
- [yaml](https://github.com/puppetlabs/hiera/blob/master/lib/hiera/backend/yaml_backend.rb)

Read the code of various third-party backends to learn more about accessing various other sources of data:

- [crayfishx/hiera-mysql](https://github.com/crayfishx/hiera-mysql)
- [crayfishx/hiera-http](https://github.com/crayfishx/hiera-http)
- [binford2k/hiera-rest](https://github.com/binford2k/hiera-rest)
