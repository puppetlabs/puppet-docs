---
layout: default
title: "Language: Using templates"
---

[interpolate]: ./lang_data_string.html#interpolation
[heredoc]: ./lang_data_string.html#heredocs
[augeas]: /guides/augeas.html
[concat]: https://forge.puppetlabs.com/puppetlabs/concat
[file_line]: https://forge.puppetlabs.com/puppetlabs/stdlib
[functions]: ./lang_functions.html
[epp]: ./lang_template_epp.html
[man epp]: ./man/epp.html
[erb]: ./lang_template_erb.html
[module]: ./modules_fundamentals.html
[string]: ./lang_data_string.html
[hash]: ./lang_data_hash.html
[valid local variable names]: ./lang_reserved.html#variables
[heredoc]: ./lang_data_string.html#heredocs
[iteration functions]: ./lang_iteration.html
[stdlib]: https://forge.puppetlabs.com/puppetlabs/stdlib

Templates are documents that combine code, data, and literal text to produce a final rendered output. The goal of a template is to manage a complicated piece of text with simple inputs.

In Puppet, you'll usually use templates to manage the content of configuration files (via the `content` attribute of the `file` resource type).

## Templating languages

Templates are written in a _templating language_, which is specialized for generating text from data.

Puppet supports two templating languages:

* [Embedded Puppet (EPP)][epp] uses Puppet expressions in special tags. It's easy for any Puppet user to read, but only works with newer Puppet versions. (≥ 4.0, or late 3.x versions with future parser enabled.)
* [Embedded Ruby (ERB)][erb] uses Ruby code in tags. You need to know a small bit of Ruby to read it, but it works with all Puppet versions.

## Using templates

Once you have a template, you can pass it to a [function][functions] that will evaluate it and return a final [string][].

The actual template can be either a separate file or a [string][] value. You'll use different functions depending on the template's language and how the template is stored.

Template Language     | File       | String
----------------------|------------|------------------
Embedded Puppet (EPP) | `epp`      | `inline_epp`
Embedded Ruby (ERB)   | `template` | `inline_template`

### With a template file: `template` and `epp`

You can put template files in the `templates` directory of a [module][]. EPP files should have the `.epp` extension, and ERB files should have the `.erb` extension.

To use a template file, evaluate it with the `template` (ERB) or `epp` function as follows:

``` puppet
# epp(<FILE REFERENCE>, [<PARAMETER HASH>])
file { '/etc/ntp.conf':
  ensure  => file,
  content => epp('ntp/ntp.conf.epp', {'service_name' => 'xntpd', 'iburst_enable' => true}),
  # Loads /etc/puppetlabs/code/environments/production/modules/ntp/templates/ntp.conf.epp
}

# template(<FILE REFERENCE>, [<ADDITIONAL FILES>, ...])
file { '/etc/ntp.conf':
  ensure  => file,
  content => template('ntp/ntp.conf.erb'),
  # Loads /etc/puppetlabs/code/environments/production/modules/ntp/templates/ntp.conf.erb
}
```

#### Referencing files

The first argument to these functions should be a string like `'<MODULE>/<FILE>'`, which will load `<FILE>` from `<MODULE>`'s `templates` directory.

File Reference                  | Actual File
--------------------------------|---------------------------------------------------------------
`ntp/ntp.conf.epp`              | `<MODULES DIRECTORY>/ntp/templates/ntp.conf.epp`
`activemq/amq/activemq.xml.erb` | `<MODULES DIRECTORY>/activemq/templates/amq/activemq.xml.erb`

#### EPP parameters

{% capture epp_params %}
EPP templates can declare parameters, and you can provide values for them by passing a parameter [hash][] to the `epp` function.

The keys of the hash must be [valid local variable names][] (minus the `$`). Inside the template, Puppet will create variables with those names and assign their values from the hash. (With a parameter hash of `{'service_name' => 'xntpd', 'iburst_enable' => true}`, an EPP template would receive variables called `$service_name` and `$iburst_enable`.)

* If a template declares any mandatory parameters, you _must_ set values for them with a parameter hash.
* If a template declares any optional parameters, you can choose to provide values or let them use their defaults.
* If a template declares **no** parameters, you can pass any number of parameters with any names; otherwise, you can only choose from the parameters requested by the template.
{% endcapture %}

{{ epp_params }}

#### Extra ERB files

The `template` function can take any number of additional template files, and will concatenate their outputs together to produce the final string.

### With a template string: `inline_template` and `inline_epp`

If you have a [string][] value that contains template content, you can evaluate it with the `inline_template` (ERB) or `inline_epp` functions as follows:

``` puppet
$ntp_conf_template = @(END)
...template content goes here...
END

# inline_epp(<TEMPLATE STRING>, [<PARAMETER HASH>])
file { '/etc/ntp.conf':
  ensure  => file,
  content => inline_epp($ntp_conf_template, {'service_name' => 'xntpd', 'iburst_enable' => true}),
}

# inline_template(<TEMPLATE STRING>, [<ADDITIONAL STRINGS>, ...])
file { '/etc/ntp.conf':
  ensure  => file,
  content => inline_template($ntp_conf_template),
}
```

In older versions of Puppet, `inline_template` was mostly used to get around limitations --- tiny Ruby fragments were useful for transforming and manipulating data before Puppet had [iteration functions][] like `map` or [puppetlabs/stdlib][stdlib] functions like `chomp` and `keys`.

In modern versions of Puppet, inline templates are usable in some of the same situations template files are. Since the [heredoc][] syntax makes it easy to write large and complicated strings in a manifest, you can use `inline_template` and `inline_epp` to reduce the number of files needed for a simple module that manages a small config file.

#### EPP parameters

{{ epp_params }}

#### Extra ERB strings

The `inline_template` function can take any number of additional template strings, and will concatenate their outputs together to produce the final value.

## Validating and previewing templates

Before deploying a template, you should validate its syntax and render its output to ensure it's producing the results you expect.

Puppet 4 includes the [`puppet epp`][man epp] command-line tool for EPP templates, while Ruby can check ERB syntax after trimming the template with its `erb` command.

### EPP validation

`puppet epp validate <TEMPLATE NAME>`

The [`puppet epp`][man epp] command includes an action that checks EPP code for syntax problems. The `<TEMPLATE NAME>` can be a file reference or can refer to a `<MODULE NAME>/<TEMPLATE FILENAME>` as the `epp` function. If a file reference can also refer to a module, Puppet validates the module's template instead.

You can also pipe EPP code directly to the validator:

`cat example.epp | puppet epp validate`

The command is silent on a successful validation. It reports and halts on the first error it encounters; to modify this behavior, check the command's [man page][man epp].

### EPP rendering

`puppet epp render <TEMPLATE NAME>`

You can render EPP from the command line with [`puppet epp render`][man epp]. If Puppet can evaluate the template, it outputs the result.

If your template relies on specific parameters or values to function, you can simulate those values by passing a [hash][] to the `--values` option:

`puppet epp render example.epp --values '{x => 10, y => 20}'`

You can also render inline EPP by using the `-e` flag or piping EPP code to `puppet epp render`, and even simulate facts using YAML. For details, see the command's [man page][man epp].

### ERB validation

`erb -P -x -T '-' example.erb | ruby -c`

You can use Ruby to check the syntax of ERB code by piping output from the `erb` command into `ruby`. The `-P` switch ignores lines that start with '%', the `-x` switch outputs the template's Ruby script, and the `-T '-'` sets the trim mode to be consistent with Puppet's behavior. This output gets piped into Ruby's syntax checker (`-c`).

If you need to validate many templates quickly, you can implement this command as a shell function in your shell's login script, such as `.bashrc`, `.zshrc`, or `.profile`:

``` bash
validate_erb() {
  erb -P -x -T '-' $1 | ruby -c
}
```

You can then use `validate_erb example.erb` to validate an ERB template.

## When to use (and not use) templates

Templates are more powerful than normal strings, and less powerful than modeling individual settings as resources.

Strings in the Puppet language already allow you to [interpolate variables and expressions][interpolate] into text. So if you're managing a short and simple config file, you can often use a [heredoc][] and interpolate a few variables, or even something like `${ $my_array.join(', ') }`.

However, if you're doing complex transformations (especially iterating over collections) or working with very large config files, you might need the extra capabilities of a template.

Finally: Sometimes you end up in a situation where several different modules need to manage parts of the same config file, which is incredibly difficult to coordinate with either templates or interpolated strings. For shared configuration like this, you should try to model each setting in that file as an individual resource, with either a custom resource type or an [Augeas][], [concat][], or [`file_line`][file_line] resource. (This approach is similar to how core resource types like `ssh_authorized_key` and `mount` work.)
