---
layout: default
title: "Future Parser: Visual Index"
canonical: "/puppet/latest/reference/future_lang_visual_index.html"
---


[resource]: ./future_lang_resources.html
[type]: ./future_lang_resources.html#type
[title]: ./future_lang_resources.html#title
[attribute]: ./future_lang_resources.html#attributes
[value]: ./future_lang_resources.html#attributes
[string]: ./future_lang_datatypes.html#strings
[function]: ./future_lang_functions.html
[rvalue]: ./future_lang_functions.html#behavior
[template_func]: /guides/templating.html
[module]: modules_fundamentals.html
[argument]: ./future_lang_functions.html#arguments
[relationship_meta]: ./future_lang_relationships.html#relationship-metaparameters
[refs]: ./future_lang_datatypes.html#resource-references
[chaining]: ./future_lang_relationships.html#chaining-arrows
[variable]: ./future_lang_variables.html
[array]: ./future_lang_datatypes.html#arrays
[hash]: ./future_lang_datatypes.html#hashes
[interpolation]: ./future_lang_datatypes.html#variable-interpolation
[class_def]: ./future_lang_classes.html#defining-classes
[class_decl]: ./future_lang_classes.html#declaring-classes
[defined_type]: ./future_lang_defined_types.html
[namespace]: ./future_lang_namespaces.html
[defined_resource]: ./future_lang_defined_types.html#declaring-an-instance
[node]: ./future_lang_node_definitions.html
[regex_node]: ./future_lang_node_definitions.html#regular-expression-names
[comments]: ./future_lang_comments.html
[if]: ./future_lang_conditional.html#if-statements
[expressions]: ./future_lang_expressions.html
[built_in]: ./future_lang_variables.html#facts-and-built-in-variables
[facts]: ./future_lang_variables.html#facts
[regex]: ./future_lang_datatypes.html#regular-expressions
[regex_match]: ./future_lang_expressions.html#regex-match
[in]: ./future_lang_expressions.html#in
[case]: ./future_lang_conditional.html#case-statements
[selector]: ./future_lang_conditional.html#selectors
[collector]: ./future_lang_collectors.html
[export_collector]: ./future_lang_collectors.html#exported-resource-collectors
[export]: ./future_lang_exported.html
[defaults]: ./future_lang_defaults.html
[override]: ./future_lang_classes.html#overriding-resource-attributes
[inherits]: ./future_lang_classes.html#inheritance
[coll_override]: ./future_lang_resources.html#amending-attributes-with-a-collector
[virtual]: ./future_lang_virtual.html

This page can help you find syntax elements when you can't remember their names.


{% highlight ruby %}
    file {'ntp.conf':
      path    => '/etc/ntp.conf',
      ensure  => file,
      content => template('ntp/ntp.conf'),
      owner   => 'root',
      mode    => '0644',
    }
{% endhighlight %}

↑ A [resource declaration][resource].

* `file`: The [resource type][type]
* `ntp.conf`: The [title][]
* `path`: An [attribute][]
* `'/etc/ntp.conf'`: A [value][]; in this case, a [string][]
* `template('ntp/ntp.conf')`: A [function][] call that [returns a value][rvalue]; in this case, the [`template`][template_func] function, with the name of a template in a [module][] as its [argument][]

{% highlight ruby %}
    package {'ntp':
      ensure => installed,
      before => File['ntp.conf'],
    }
    service {'ntpd':
      ensure    => running,
      subscribe => File['ntp.conf'],
    }
{% endhighlight %}

↑ Two resources using the `before` and `subscribe` [relationship metaparameters][relationship_meta] (which accept [resource references][refs]).

{% highlight ruby %}
    Package['ntp'] -> File['ntp.conf'] ~> Service['ntpd']
{% endhighlight %}

↑ [Chaining arrows][chaining] forming relationships between three resources, using [resource references][refs].

{% highlight ruby %}
    $package_list = ['ntp', 'apache2', 'vim-nox', 'wget']
{% endhighlight %}

↑ A [variable][] being assigned an [array][] value.

{% highlight ruby %}
    $myhash = { key => { subkey => 'b' }}
{% endhighlight %}

↑ A [variable][] being assigned a [hash][] value.

{% highlight ruby %}
    ...
    content => "Managed by puppet master version ${serverversion}"
{% endhighlight %}

↑ A master-provided [built-in variable][built_in] being [interpolated into a double-quoted string][interpolation] (with optional curly braces).


{% highlight ruby %}
    class ntp {
      package {'ntp':
        ...
      }
      ...
    }
{% endhighlight %}

↑ A [class definition][class_def], which makes a class avaliable for later use.

{% highlight ruby %}
    include ntp
    require ntp
    class {'ntp':}
{% endhighlight %}

↑ [Declaring a class][class_decl] in three different ways: with the `include` function, with the `require` function, and with the resource-like syntax. Declaring a class causes the resources in it to be managed.


{% highlight ruby %}
    define apache::vhost ($port, $docroot, $servername = $title, $vhost_name = '*') {
      include apache
      include apache::params
      $vhost_dir = $apache::params::vhost_dir
      file { "${vhost_dir}/${servername}.conf":
          content => template('apache/vhost-default.conf.erb'),
          owner   => 'www',
          group   => 'www',
          mode    => '644',
          require => Package['httpd'],
          notify  => Service['httpd'],
      }
    }
{% endhighlight %}

↑ A [defined type][defined_type], which makes a new resource type available. Note that the name of that resource type has two [namespace segments][namespace].

{% highlight ruby %}
    apache::vhost {'homepages':
      port    => 8081,
      docroot => '/var/www-testhost',
    }
{% endhighlight %}

↑ [Declaring an instance][defined_resource] of the resource type defined above.

{% highlight ruby %}
    Apache::Vhost['homepages']
{% endhighlight %}

↑ A [resource reference][refs] to the defined resource declared above. Note that every [namespace segment][namespace] must be capitalized.

{% highlight ruby %}
    node 'www1.example.com' {
      include common
      include apache
      include squid
    }
{% endhighlight %}

↑ A [node definition][node].

{% highlight ruby %}
    node /^www\d+$/ {
      include common
    }
{% endhighlight %}

↑ A [regular expression node definition][regex_node].

{% highlight ruby %}
    # comment
    /* comment */
{% endhighlight %}

↑ Two [comments][].


{% highlight ruby %}
    if str2bool("$is_virtual") {
      warning( 'Tried to include class ntp on virtual machine; this node may be misclassified.' )
    }
    elsif $operatingsystem == 'Darwin' {
      warning( 'This NTP module does not yet work on our Mac laptops.' )
    else {
      include ntp
    }
{% endhighlight %}

↑ An [if statement][if], whose conditions are [expressions][] that use agent-provided [facts][].


{% highlight ruby %}
    if $hostname =~ /^www(\d+)\./ {
      notify { "Welcome web server #$1": }
    }
{% endhighlight %}

↑ An [if statement][if] using a [regular expression][regex] and the [regex match operator][regex_match].

{% highlight ruby %}
    if 'www' in $hostname {
      ...
    }
{% endhighlight %}

↑ An [if statement][if] using an [`in` expression][in]

{% highlight ruby %}
    case $operatingsystem {
      'Solaris':          { include role::solaris }
      'RedHat', 'CentOS': { include role::redhat  }
      /^(Debian|Ubuntu)$/:{ include role::debian  }
      default:            { include role::generic }
    }
{% endhighlight %}

↑ A [case statement][case].

{% highlight ruby %}
    $rootgroup = $osfamily ? {
        'Solaris'          => 'wheel',
        /(Darwin|FreeBSD)/ => 'wheel',
        default            => 'root',
    }
{% endhighlight %}

↑ A [selector statement][selector] being used to set the value of the `$rootgroup` [variable][].

{% highlight ruby %}
    User <| groups == 'admin' |>
{% endhighlight %}

↑ A [resource collector][collector], sometimes called the "spaceship operator."

{% highlight ruby %}
    Concat::Fragment <<| tag == "bacula-storage-dir-${bacula_director}" |>>
{% endhighlight %}

↑ An [exported resource collector][export_collector], which works with [exported resources][export]

{% highlight ruby %}
    Exec {
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      environment => 'RUBYLIB=/opt/puppet/lib/ruby/site_ruby/1.8/',
      logoutput   => true,
      timeout     => 180,
    }
{% endhighlight %}

↑ A [resource default][defaults] for the `exec` resource type.

{% highlight ruby %}
    Exec['update_migrations'] {
      environment => 'RUBYLIB=/usr/lib/ruby/site_ruby/1.8/',
    }
{% endhighlight %}

↑ A [resource override][override], which will only work in an [inherited class][inherits].

{% highlight ruby %}
    Exec <| title == 'update_migrations' |> {
      environment => 'RUBYLIB=/usr/lib/ruby/site_ruby/1.8/',
    }
{% endhighlight %}

↑ A [resource override using a collector][coll_override], which will work anywhere. Dangerous, but very useful in rare cases.


{% highlight ruby %}
    @user {'deploy':
      uid     => 2004,
      comment => 'Deployment User',
      group   => www-data,
      groups  => ["enterprise"],
      tag     => [deploy, web],
    }
{% endhighlight %}

↑ A [virtual resource][virtual].


{% highlight ruby %}
    @@nagios_service { "check_zfs${hostname}":
      use                 => 'generic-service',
      host_name           => "$fqdn",
      check_command       => 'check_nrpe_1arg!check_zfs',
      service_description => "check_zfs${hostname}",
      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
      notify              => Service[$nagios::params::nagios_service],
    }
{% endhighlight %}

↑ An [exported resource][export] declaration.

