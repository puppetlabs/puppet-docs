---
layout: default
title: "Puppet Ruby DSL Statements and Expressions"
---

[metaparameters]: /references/3.0.latest/metaparameter.html
[relationship_metaparameters]: ./lang_relationships.html#relationship-metaparameters

## Resource Declarations

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td rowspan="2" style="vertical-align:middle;">
{% highlight ruby %}

file {['a', 'b']:
ensure => present
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
file "a", "b",
:ensure => :present
{% endhighlight %}
      
</td>
</tr>
<tr>

<td>
{% highlight ruby %}
file "a", "b" do |f|
  f.ensure = :present
end
{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
exec { 'cmd':
  x => 1
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
exec "cmd" do |e|
  e.x => 1
end
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>



## Resource Defaults

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
Notify {
  message => "foobar"
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
Notify.defaults :message => "foobar"
{% endhighlight %}
</td>
</tr>
</tbody>
</table>



## Resource Overrides

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td rowspan="2" style="vertical-align:middle;">
{% highlight ruby %}
Notify["foo"] {
  message => "foobar"
}

{% endhighlight %}</td>
<td>
{% highlight ruby %}
Notify["foo"].override :message => "foobar"
{% endhighlight %}      
</td>
</tr>
<tr>

<td>
{% highlight ruby %}
Notify["foo"].override do |o|
  o.message => "foobar"
end
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>

## Relationships

All of Puppet's [relationship metaparameters][relationship_metaparameters] (as well as the [rest of the metaparameters][metaparameters]) are available, and can be declared like any resource attribute. 

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>


<tr> <!-- notify -->

<td>
{% highlight ruby %}
rtype {'x':
  notify => Stype['y']
}
{% endhighlight %}
</td>

<td>
{% highlight ruby %}
rtype "x", :notify => Stype["y"]
{% endhighlight %}
</td>
</tr>



<tr>
<td>
{% highlight ruby %}
rtype {'x':
  require => Stype['y']
}
{% endhighlight %}
        
</td>

<td>
{% highlight ruby %}
rtype "x" do |x|
  x.require => Stype["y"]
end
{% endhighlight %}
</td>
</tr>



</tbody>
</table>

There is no support for the Puppet DSL's chaining operators (`->`, `<-`,  `~>`, `<~`) in the Puppet Ruby DSL.


## Class Definitions

Values are expressed with objects responding to `#to_s` (Strings, symbols, etc.)

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
class baz {
  #
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
hostclass :baz do
  #
end
{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
class baz ($p) {
  #
}
{% endhighlight %}        
</td>
<td>
{% highlight ruby %}
hostclass :baz, :arguments => { :p => nil } do
  #
end
{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
class baz ($p='42') {
  #
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
hostclass :baz, :arguments => { :p => "42" } do
  #
end
{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
class baz inherits foo {
  #
}
{% endhighlight %}        
</td>
<td>
{% highlight ruby %}
hostclass :baz,
:inherits => :foo do
  #
end
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>


### Referencing Class Parameters

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
class foo ($p) {
  notify {something:
    message => "Parameter was $p",
  }
}
{% endhighlight %}</td>
<td>
{% highlight ruby %}
hostclass :baz, :arguments => { :p => nil } do
  notify "something" do |sm|
    sm.message = "Parameter was #{params["p"]}"
  end
end
{% endhighlight %}</td>
</tr>
</tbody>
</table>


## Class Declarations

### Include and Require

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
include a::b
{% endhighlight %}</td>
<td>{% highlight ruby %}

include 'a::b'
{% endhighlight %}
</td>
</tr>
<tr>
<td>
{% highlight ruby %}

require a::b
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
call_function "require", 'a::b'
{% endhighlight %}
</td>
</tr>
</tbody>

</table>



### Resource-Like (With Parameters)

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
class { 'baz':
  p => '42'
}
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
use :baz, :p => 42
{% endhighlight %}
</td>
</tr>
</tbody>
</table>



## Defined Type Definitions

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
define foo($a, $b=1) {
  notice $a
}
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
define "foo", :arguments => {:a => nil, :b => 1} do
  notice params[:a]
end
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>


## Node Definitions

Just as in the Puppet DSL, the logic in the node's body is executed when a host matching the node name (either by literal hostname or matching regular expression) has requested evaluation.

In the Puppet Ruby DSL, the node name is any object responding to `#to_s` or is a Regexp.

<table>
<tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
node default {
  #
}
{% endhighlight %}
</td>

<td>

{% highlight ruby %}
node "default" do
  #
end
{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
node x inherits y {
  #
}
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
node "x", :inherits => "y" do
  #
end
{% endhighlight %}
</td>
</tr>
<tr>
<td>

{% highlight ruby %}
node /.*foo.com/ {
  #
}
{% endhighlight %}
        
</td>
<td>

{% highlight ruby %}
node /.*foo.com/i do
  #
end
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>



## Virtual Resources

Making an instance of resource of type Rtype virtual: 

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td rowspan="3" style="vertical-align:middle;">
{% highlight ruby %}
@rtype { 'a': }
@rtype { 'b': }
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
virtual do
  rtype "a"
  rtype "b"
end
{% endhighlight %}

      
</td>
</tr>
<tr>

<td>
{% highlight ruby %}
rtype "a"
rtype "b"
virtual Rtype["a"]
virtual Rtype["b"]
{% endhighlight %}

      
</td>
</tr>
<tr>

<td>
{% highlight ruby %}
virtual rtype "a"
virtual rtype "b"
{% endhighlight %}
</td>
</tr>
</tbody>
</table>

Realizing virtual resources of type Rtype: 



<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
Rtype <| |>
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
Rtype.realize

{% endhighlight %}
      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
Rtype <| name == 'x' |>
{% endhighlight %}

{% highlight ruby %}
realize Rtype['x']
{% endhighlight %}

</td>
<td>
{% highlight ruby %}
Rtype['x'].realize

{% endhighlight %}        
</td>
</tr>
</tbody>
</table>

Lookup by name is supported, but the Puppet Ruby DSL has no syntax for [collecting virtual resources](lang_collectors.html) based on other attributes. 

## Exported Resources

Export of a resource of type Rtype.

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td rowspan="3" style="vertical-align:middle;">
{% highlight ruby %}
@@rtype { 'a': }
@@rtype { 'b': }
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
export do
  rtype "a"
  rtype "b"
end
{% endhighlight %}
      
</td>
</tr>
<tr>

<td>
{% highlight ruby %}
rtype "a"
rtype "b"
export Rtype["a"]
export Rtype["b"]
{% endhighlight %}</td>
</tr>
<tr>

<td>
{% highlight ruby %}
export rtype "a"
export rtype "b"
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>

Collecting exported resources of type Rtype:

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
Rtype <<| |>>
{% endhighlight %}

        
</td>
<td>
{% highlight ruby %}
Rtype.collect
{% endhighlight %}      
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
Rtype <<| name == 'x' |>>
{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
Rtype['x'].collect
{% endhighlight %}        
</td>
</tr>
</tbody>
</table>


Lookup by name is supported, but the Puppet Ruby DSL has no syntax for [collecting exported resources](lang_collectors.html) based on other attributes. 


## Access to Puppet Variables

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
$p

{% endhighlight %}
        
</td>
<td>
{% highlight ruby %}
scope["p"]
{% endhighlight %}
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
$::p
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
::p
{% endhighlight %}
</td>
</tr>

<tr>
<td>
{% highlight ruby %}
$p = 10

{% endhighlight %}
</td>
<td>
{% highlight ruby %}
scope["p"] = 10
{% endhighlight %}
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
$p += 10

{% endhighlight %}
</td>
<td>
{% highlight ruby %}
scope.setvar("p", "10", :append => true)

{% endhighlight %}
</td>
</tr>
<tr>
<td>
{% highlight ruby %}
$p = undef

{% endhighlight %}
</td>
<td>
{% highlight ruby %}
scope.unsetvar("p")

{% endhighlight %}
</td>
</tr>
</tbody>
</table>



## Calling Functions

Unlike templates, the Puppet Ruby DSL does not require arguments to be passed in an array:

<table><tbody>
<tr>
<th>
          Puppet

        
</th>
<th>
          Ruby DSL

      
</th>
</tr>
<tr>
<td>
{% highlight ruby %}
notice "hello"
notice("hello")
{% endhighlight %}
</td>
<td>
{% highlight ruby %}
notice "hello"
notice("hello")
call_function "notice", "hello"
{% endhighlight %}
</td>
</tr>
</tbody>
</table>

Most functions can be called directly. The alternative `call function` form where the name of the function is given
as a string makes it possible to call functions with a name that clash with a ruby keyword
(`require` is one such example).

<!-- todo: link to example repo once we have something in there --> 
