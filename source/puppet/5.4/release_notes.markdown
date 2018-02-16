---
layout: default
toc_levels: 1234
title: "Puppet 5.4 Release Notes"
---

This page lists the changes in Puppet 5.4 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](../5.1/release_notes.html), [Puppet 5.2](../5.2/release_notes.html), and [Puppet 5.3](../5.3/release_notes.html) release notes, because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](../4.10/release_notes.html) and [Puppet 4.9 release notes](../4.9/release_notes.html).

## Puppet 5.4.0

Released February 14, 2018.

This is a feature and bug-fix release of Puppet.

-   [All issues resolved in Puppet 5.4.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.4.0%27)

### Breaking changes (Bolt)

-   In previous versions of Puppet, tasks were Types, and you could call the `run_task()` function with a reference to the Type or an instance of the Type. Puppet 5.4.0 requires you to refer to tasks by their lowercase task names. This affects Bolt users only.

    For example, the following invocations are no longer valid:

    ``` puppet
    run_task(My_app::Deploy(), ....
    run_task(My_app::Deploy, ....
    ```

    To work in Puppet 5.4.0, convert these invocations to:

    ``` puppet
    run_task(my_app::deploy, ...
    run_task('my_app::deploy', ..
    ```

### Deprecations

-   The `puppet module generate` command is deprecated and will be removed in a future release. To create modules, use the [Puppet Development Kit](https://puppet.com/download-puppet-development-kit).

### Security fixes

-   Puppet 5.4.0 uses SHA256 to sign the CRL signature instead of SHA1.

### Bug fixes

-   Pupet 5.3.4 introduced a regression that prevented `puppet apply` from downloading files from HTTP sources when the response was compressed. (The `puppet agent` command was unaffected.) Puppet 5.4.0 resolves the issue.

-   In previous versions of Puppet, if you tried to add a value to an existing setting that had no value using `puppet config`, Puppet would place the value on the following line of puppet.conf. Attempting to edit any other setting in the file with `puppet config` would then result in a ParseError and add even more extra blank lines to the setting. Puppet 5.4.0 strips any existing newline characters on the setting before attempting to set the value.

-   Managing services with Puppet 5.4.0 on macOS no longer produces warnings for plist files that don't include a label entry.

-   Attempting to use an empty string or `undef` as the name of a class when calling `include` in Puppet 5.4.0 raises an error instead of appearing to be silently ignored.

-   Puppet 5.4.0 gracefully exits when running the Puppet module tool on a FIPS-enabled system, where MD5 checksums are not allowed.

-   Previous versions of Puppet pointed log rotation at incorrect paths by default on operating systems that are based on Red Hat Enterprise Linux, Fedora, and Debian. This prevented Puppet from rotating logs. Puppet 5.4.0 is configured to point to the correct log locations.

-   The log rotation script on previous versions of Puppet tried to own permissions for Puppet's log file, which conflicted with service restarts on Red Hat Enterprise Linux and Fedora where the Puppet service would also try to update the log file's permissions. Installing Puppet 5.4.0 on those systems sets correct permissions for log files, and the log rotation script no longer attempts to update them.

-   The filebucket application in previous versions of Puppet used the `server` setting only when connecting to remote filebuckets. Puppet 5.4.0 prefers the first entry in the `server_list` setting, and uses the `server` setting if `server_list` is not available.

-   Using the `--local` option in filebucket on previous versions of Puppet defaulted to using the server's filebucket path (`bucketdir`) instead of the local filebucket path (`clientbucketdir`), leading to errors as Puppet failed to find the files in the wrong directory. Puppet 5.4.0 changes the behavior of `--local` to instead use `clientbucketdir`.

-   Filebucket contents are atomically updated in Puppet 5.4.0, resolving a race condition where Puppet might retrieve only part of a requested file.

-   Previous versions of Puppet required the `--user=root` setting to be passed to `puppet device` when creating certificates, even if the command was being executed by root. Puppet 5.4.0 resolves this issue, and the setting is no longer required.

-   When replacing an existing file on previous versions of Puppet, `Puppet::Util.replace_file` would set the temporary file's permissions to be that of the existing file or provided default permissions. The temp file was created with insecure file permissions, but using the existing file's mode prevented Puppet from writing to the temporary file if the file being replaced was read-only. This is no longer necessary in Puppet 5.4.0, because `Puppet::FileSystem::Uniquefile` creates temporary files with mode 0600.

-   Previous versions of Puppet could not use arbitrary fully qualified variable values when testing EPP templates with `epp render` and giving values with `values_file`, preventing users from testing the result of a template with the `epp` command if it used variable references with `::` in them. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet couldn't manage the FreeBSD equivalent of the *nix `zoned` property, because the equivalent FreeBSD property name is `jailed`. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet failed to persist mounting options when remounting a `mount` resource on AIX. Puppet 5.4.0 resolves this issue.

-   When specifying `--section main` with the `puppet config set` command, Puppet 5.4.0 explicitly adds a `[main]` section header to the config file.

-   Puppet 5.4.0 uses DNF as the default package provider on Fedora 26 and newer.

-   The `Error` object in previous versions of Puppet could only accept an error message as a string. Puppet 5.4.0 also allows you to initialize the object from a hash with arguments for the object.

-   With previous versions of Puppet, you could not use a task with `sensitive` metadata on a task parameter. Puppet 5.4.0 accepts `sensitive` task metadata.

-   The precedence of the `?` selector-operator was too high and this made it difficult to use an expression on the left hand side. For example, this code would unexpectedly result in `bad` instead of `3`:

    ```puppet
    1 + 2 ? { 3 => expected, default => bad }
    ```

    Puppet 5.4.0 changes the operator's precedence to be just above `and` and `or`.

-   In previous versions of Puppet, users of the Puppet-as-A-Library (PAL) Ruby API couldn't instantiate definitions in evaluated code given to any of its evaluation methods. Puppet 5.4.0 resolves this issue.

-   The `Init[T]` data type introduced in Puppet 5.1.0 didn't work as expected with some core Puppet data types, because they were to relaxed in the specifications of the arguments they accept when creating new instances. Consequently, `Init` could match invalid values. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet allowed you to use type comparison operators (such as `<`, `>`, `<=`, `>=`, `=~`, and `!~`) would incorrectly report an empty `Variant` data type as a match for almost all other data types. In Puppet 5.4.0, an empty `Variant` correctly represents all variants and only matches itself, `Any`, and `NotUndef[Variant]`.

-   When setting `forcelocal` in previous versions of Puppet, it used local commands only when _adding_ group and user resources. In Puppet 5.4.0 with `forcelocal` set to true, the `groupadd` and `useradd` modules also use local commands for modifying and deleting user and group resources.

-   In previous versions of Puppet, data types like `String[0]` were displayed as `String[0, default]`, indicating that the maximum length was the default. This was unnecessary, and in Puppet 5.4.0, the string form for all data types that take minimum or maximum lengths has been changed to not output the maximum when it is set to `default`.

    Data types in previous versions of Puppet that described a minimum or maximum range used `default` to indicate a default minimum or maximum value when it would be more informative to use an actual value `0` or omit the text `default`. In Puppet 5.4.0, instead of displaying `String[1, default]`, it displays only `String[1]`.

-   The `tidy` resource in Puppet 5.4.0 no longer emits a log message if there are no files to delete.

-   If the `noop` metaparameter is set to true on a `tidy` resource, Puppet 5.4.0 won't purge its children.

-   When attempting to back up a file using `puppet filebucket` with a custom `--bucket` option in previous versions of Puppet, the file would not be backed up to the specified filebucket path if the file already existed in the default `$clientbucketdir` location. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet converted "rich" data types to String too early when used with defined resource types, classes, or functions. For example, a regular expression would be converted to a String. Puppet 5.4.0 drops the conversion, and defined types, classes, and functions become instances of Regexp, Version, VersionRange, Binary, Timespan, and Timestamp instead of a String representation of the value.

-   In Puppet 5.4.0, `puppet resource user` lists a unique set of groups for a user even when a user is in the same group from multiple sources.

-   A gem installation of previous versions of Puppet had unnecessary gem dependencies. The Puppet 5.4.0 gem requires `fast_gettext ~> 1.1.2`, since that is what Puppet uses.

-   Previous versions of Puppet attempted to include the default text from `gem list` as a part of the package name, resulting in failed gem installations. Puppet 5.4.0 strips the `default: ` text to allow searches for the version number only.

-   Puppet 5.4.0 honors execution of `addcmd`, `modifycmd`, and `deletecmd` when `@custom_environment` is set, and passes in the defined custom environment.

-   Previous versions of Puppet would fail to clean a certificate signing request when running `puppet cert clean` because it would try to revoke the certificate. In Puppet 5.4.0, `puppet cert clean` correctly cleans certificate signing requests.

-   The `puppet apply` command in Puppet 5.4.0 no longer attempts to enforce the server-side requirements around environment directories when retrieving its node information from the server. In previous versions of Puppet, this check could cause multiple catalog retrievals during a single run.

-   In previous versions of Puppet, calling `tree_each` without a lambda returned an `Iterable` that could not be converted to an `Array` using the new or splat operators. Puppet 5.4.0 resolves this issue.

-   When using `puppet types generate` for environment isolation, and a resource type had customized title patterns, previous versions of Puppet would not use those. Puppet 5.4.0 resolves this issue.

-   Puppet 5.4.0 only excludes `*.pot` files when downloading translations from the `locales` mount point, instead of for all pluginsync-related mount points.

-   Services using the "redhat" provider in Puppet 5.4.0 are enabled in more conditions, primarily with boot services on SUSE Linux Enterprise Server systems.

-   The `puppet config set` command no longer creates entries in the wrong section if there is a setting with the same value in multiple sections.

-   Providers that fail in prefetch on Puppet 5.4.0 cause the resources that use them to report failures and won't be evaluated. This doesn't affect other resources or providers not dependent on the failed provider and resources.

-   Exceptions in prefetch were not marked as failed in the report under previous versions of Puppet, leading to reports incorrectly suggesting that an agent run with errors was fully successful. Puppet 5.4.0 marks only transactions that finish processing as successful.

-   Puppet 5.4.0 no longer returns "invalid byte sequence" errors when parsing module translation files in non-UTF-8 environments.

-   Running `puppet apply` or `puppet resource` to modify state in previous versions of Puppet would update the transaction.yaml file used to determine corrective vs. intentional change. This could lead to Puppet reporting an unexpected correctional change status. Puppet 5.4.0 resolves this by updating transaction.yaml only during an agent run.

-   The validation of `uris` in a Hiera 5 `hiera.yaml` file by previous versions of Puppet did not allow reference or partial URIs, such as those containing only a path, despite the documentation stating that Hiera doesn't ensure that URIs are resolvable. Puppet 5.4.0 relaxes the implemented URI checking to remove these constraints.

-   The `break()` function did not break the iteration over a hash, and instead would break the container in which a lambda called `break()`. This resulted in an error about a break from an illegal context if the container was something other than a function, and would lead to early exit when invoked from a function. Puppet 5.4.0 resolves this by having the function behave like a break in an array iteration.

-   Puppet 5.4.0 updates the command used to start services on Solaris, preventing Puppet from abandoning certain services before they are properly started.

-   A regression in Puppet 5.0.0 made it impossible to reference fully qualified variables in the default value expression for a parameter. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet required that `--user=root` be passed to `puppet device` when creating certificates, even if the command was being executed by root. Puppet 5.4.0 no longer requires the flag.

-   When providing facts with the `--facts` command line option of the `puppet lookup` command in previous versions of Puppet, those facts would not appear in the `$facts` variable. Puppet 5.4.0 resolves this issue.

#### Bolt-related fixes

-   Bolt rejected tasks in previous versions of Puppet that used non-Data types in parameters' metadata. Puppet 5.4.0 allows non-Data types.

-   Previous versions of Puppet couldn't use the `run_script` function because it didn't accept any arguments or pass any on to the Bolt executor, which always resulted in an error. Puppet 5.4.0 resolves this issue by allowing arguments to be given as a hash with a key `'arguments'` holding an array of Strings. The default is an empty array. The String arguments can be any string, including empty strings.

### New features

-   Puppet 5.4.0 adds the `future_features` option to enable all in-development features that might be added to a future major release of Puppet. This setting is set to `false` by default and doesn't have any features assigned to it. Features in development are experimental and can have unexpected effects.

-   Specifying `package => latest` in Puppet 5.4.0 on Solaris also refreshes package metadata.

-   The `ldap` node terminus in Puppet 5.4.0 allows Puppet Server to retrieve node classes, parameters, and environments from LDAP.

-   Puppet 5.4.0 adds SHA224, 256, 384, and 512 hash algorithms for file checksums.

-   Puppet 5.4.0 lets you use the `user` resource attribute `password_warn_days` when creating or updating a Linux user's shadow password settings.

-   Puppet 5.4.0 lets you use cached catalogs in `puppet apply` and `puppet agent` runs with the `--noop` flag. The cached catalog isn't updated if one already exists, and isn't created if there's no previously cached catalog.

-   Puppet 5.4.0 accepts a regular expression to match against a fact value for the `defaultfor` method of providers.

-   Error messages raised for Puppet data type string from Puppet 4.x Ruby functions did not indicate the problem's location. Puppet 5.4.0 provides more informative error messages.

-   In Puppet 5.4.0, the Puppet Module Tool warns users when interacting with Puppet Forge modules that have been deprecated by their author.

-   The `puppet master` command in Puppet 5.4.0 listens on both IPv4 and IPv6 network interfaces.

-   Puppet 5.4.0 lets you set an expiration warning for passwords on the user type, which is raised a number of days configured by the `:password_warn_days` property. The default value is 15 days.

-   Puppet 5.4.0 lets developers who write tools in Ruby on top of Puppet to use Puppet's Ruby API to query loaders for an enumeration of all loadable elements of a particular kind.

-   Puppet 5.4.0 adds the new `transaction_completed` flag to the report schema for serialization and deserialization.

-   Puppet 5.4.0 supports the `payload_gpgcheck` option to the yum package provider.

-   Puppet 5.4.0 lets you skip the braces around a literal hash when giving one as arguments to a function call or operator. For example, Puppet interprets a sequence of `key => value` statements as a single hash. For example, the `Struct[a => Integer]` is the same struct as `Struct[{a=>Integer}]`, so `notice(a => 10, b => 20)` outputs a single hash with the keys `a` and `b`.

-   Group resources in Puppet 5.4.0 are set to `ensure => 'present'` by default.

-   You can parameterize the `Boolean` data type with either `true` or `false` in Puppet 5.4.0, which lets you limit a set of Booleans to those that have that value. For example, `Boolean[false]` only matches the Boolean value `false`.

-   Puppet 5.4.0 lets you create a case-independent `Enum` data type by adding a Boolean `true` value last in the list of enum String values. This was difficult to achieve in previous versions of Puppet and required regular expressions. In Puppet 5.4.0, this example results in true: `"bAnAnA" =~ Enum['banana', 'apple', true]`.

-   In Puppet 5.4.0, systemd is the default service provider for Amazon Linux 2.

-   Puppet 5.4.0 settings can be deleted from the `puppet.conf` file using the `puppet config delete` command. For example: `puppet config delete <SETTING> --section <SECTION>`.

-   In Puppet 5.4.0, `acltype` is a valid ZFS property.

#### New Puppet functions

-   Puppet 5.4.0 adds the `module_directory` function, which finds a module by name and returns the file system path to its root directory, or `undef` if the module is not found on the `modulepath`.

-   Puppet 5.4.0 adds the `convert_to` function, which lets you write clearer code when transforming one data type to another with transformations that occur in a sequence, such as `"abc".convert_to(Array)`.

#### New data types

-   Puppet 5.4.0 adds the new data type `Target`, which lets Puppet describe a target node with a host string (a host name or complete URI) and a hash of options.

    Use this data type for parameters of plans that take references to nodes or hosts and should that accept one or more hosts, such as `Target` or `Array[Target]`.

-   Puppet 5.4.0 adds the new data type `URI`, which allows you to create hierarchical and opaque URIs in string form as well as creating them from a hash of URI attributes. The type allows advanced type matching and supports merging of URIs using the `+` operator.

-   Puppet 5.4.0 adds the new data type `Error[K, I]`, which lets Puppet handle return values that describe an error. An `Error` is parameterized with a `K` for "kind", a string that describes a class of error as determined by an authority (such as `puppet/parse_error`) and a parameter `I` for issue-code, a string mnemonic for the message (such as "SYNTAX_ERROR").

    Instances of `Error` have additional attributes for the error message, and the ability to describe freeform error related information, such as an exit code and stack trace.

-   Puppet 5.4.0 allows you to access the attributes of an `Error` object.

#### FIPS support

-   Puppet 5.4.0 adds a new `puppet-agent` package for FIPS-enabled nodes. The new package is linked against system OpenSSL instead of the `puppet-agent` vendored version. This affects only the `puppet-agent` package. Future releases will provide FIPS compliance for `puppetserver` and certificate authorities.

-   When running Puppet 5.4.0 on a FIPS-enabled platform, Puppet modifies its default `digest_algorithm` and `supported_checksum_types` settings to exclude MD5, which is not a FIPS-compliant algorithm. By default, Puppet on FIPS uses SHA256 when managing file resources, including filebuckets. This behavior also affects values returned by the `fqdn_rand` function. Puppet also emits errors and gracefully exits if configured to use MD5 algorithms on FIPS-enabled nodes.

-   Some Puppet Module Tool actions, such as `install`, are unsupported when FIPS is enabled due to the module tools' reliance on MD5.

#### Puppet-As-a-Library (PAL), tasks, and scripting

-   Puppet 5.4.0 adds a new Ruby API named Puppet-As-a-Library (PAL) for writing Ruby applications that make use of Puppet. This initial implementation is focused on scripting, such as running tasks and plans.

-   Puppet 5.4.0 supports scripting — a subset of the Puppet language that does not include expressions/statements that deal with resources and a catalog — when used with Bolt to run tasks and plans. This subset of the language is available to Bolt by using `puppet script`, and via the Puppet-As-a-Library (PAL) API.

-   The `plan` keyword is reserved in Puppet 5.4.0 to describe a task plan. Avoid using this keyword in Puppet code, because a future major Puppet version might add it as part of the Puppet language for compiling catalogs.

    For more information about task plans, see the Bolt documentation.

-   When using Puppet 5.4.0 for scripting with Bolt (tasks and plans), logged output uses shortened paths inside of the `Scope()` identifier found in every logged message. Instead of showing the full path, a path to a module on the `modulepath` is shown as `<MODULE>/name/<REST-OF-PATH>.pp`, or the same using `<ENV>` for a path to a `.pp` file in an environment.

-   For Ruby functions dealing with Puppet scripting or Bolt, Puppet 5.4.0 can get the ScriptCompiler in use in the function's implementation by defining a parameter with `script_compiler_param` in the function's dispatcher.

-   When running Puppet 5.4.0 with the `--tasks` option, the `--strict_variables` and `--strict=error` flags are always enabled for tasks and plans support.

-   Puppet 5.4.0 adds the `sourceaddress` setting, which specifies the interface that the agent should use for outbound HTTP requests. This setting might be necessary for agents on systems with multiple network interfaces.

-   Puppet 5.4.0 adds the `runtimeout` setting, which can cancel agent runs after the specified period. The setting defaults to 0, which preserves the behavior in previous version of Puppet of allowing an unlimited amount of time for agent runs to complete.

-   Puppet 5.4.0 allows agents to download each module's translations from the master during pluginsync, along with the rest of the module's files. This downloads all available translations for all languages, not only those for the agent's locale, and does so for the version of the module in the requested environment only.

    If a master runs an older version of Puppet that doesn't support this feature (Puppet 5.3.3, Puppet Server 5.1.3, or PE 2017.3.2), the 5.4.0 agent detects this and will not request locale files.

-   A type alias to an iterable type did not allow the alias to be iterated in previous versions of Puppet. Puppet 5.4.0 resolves this issue.

-   Previous versions of Puppet did not support using named format arguments for `sprintf`. Puppet 5.4.0 lets you use a hash with string values as the `sprintf` format argument.

    For example, `notice sprintf("%<x>s : %<y>d", { 'x' => 'value is', 'y' => 42 })` would produce a notice of `value is : 42`.

### Improvements

-   Puppet 5.4.0 adds additional debug output when creating directories with the SSH authorized key parsed provider.

-   In Puppet 5.4.0, the `:source` attribute to a package resource using the yum provider can be an http or file URL pointing to a remote or local file, and the provider uses yum's built-in support for installing the file directly with dependency management.

-   Puppet 5.4.0 adds SELinux attributes and ownership information to the `5klogin` native type.

-   Puppet 5.4.0 can retrieve file sources from web servers when the associated MIME type is not "binary". This particularly affects IIS webservers.

-   Certain Puppet subcommands, such as `puppet help` and `puppet config`, no longer require a local environment to exist in Puppet 5.4.0. They now can fall back to assuming the defined environment exists on the master filesystem after checking for the local environment.

-   If `environment.conf` contains unknown settings, Puppet 5.4.0 warns only once per unknown setting.

-   Puppet 5.4.0 sorts the output of `puppet config` lexicographically.

-   More warning and error messages are translated for Japanese locales.

-   Error messages from `Puppet::Face` objects now include the face's name and version number.

-   Error messages now provide simpler text when identifying error locations, such as line and character numbers, which makes them easier and clearer to translate.

-   To specify an environment when running Puppet from the command line, Puppet 5.4.0 lets you use the short flag `-E` in addition to the long flag `--environment`.
