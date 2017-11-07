---
layout: default
title: EC2 Demo Creation
disqus: true
canonical: "/mcollective/reference/development/ec2_demo.html"
---
[Bundling]: http://support.rightscale.com/12-Guides/01-RightScale_Dashboard_User_Guide/02-Clouds/01-EC2/08-EC2_Image_Locator/Register_an_AMI#Step_2.3a_Bundle_the_Instance
[Console]: https://console.aws.amazon.com/ec2

# {{page.title}}
Things to improve in next build:

 * set _plugin.urltest.syslocation_ to the availability zone the AMI is running on to improve mc-urltest output

## RightScale AMI
Start up ami _ami-efe4cf9b_ or a newer RightScale EC2 image

## Packages Needed
Install the following RPMs:

{% highlight console %}
facter
tanukiwrapper
activemq
mcollective
mcollective-client
mcollective-common
rubygem-stomp
rubygems
ruby-shadow
puppet
net-snmp-libs
lm_sensors
net-snmp
perl-Socket6
nrpe
perl-Crypt-DES
perl-Digest-SHA1
nagios-plugins
perl-Digest-HMAC
perl-Net-SNMP
xinetd
dialog
rubygem-rdialog
{% endhighlight %}

Gram and install _passmakr-1.0.0.gem_ from _http://passmakr.googlecode.com/_

## File modifications
Most of the files needed are in SVN in the _ext/ec2demo_ directory.

{% highlight console %}
.
|-- etc
|   |-- activemq
|   |   `-- activemq.xml.templ
|   |-- mcollective
|   |   |-- client.cfg.templ
|   |   `-- server.cfg.templ
|   |-- nagios
|   |   |-- command-plugins.cfg
|   |   |-- nrpe.cfg
|   |   `-- nrpe.d
|   |       |-- check_disks.cfg
|   |       |-- check_load.cfg
|   |       |-- check_swap.cfg
|   |       |-- check_totalprocs.cfg
|   |       `-- check_zombieprocs.cfg
|   |-- rc.d
|   |   `-- rc.local
|   `-- xinetd.d
|       `-- nrpe
|-- opt
|   `-- rightscale
|       `-- etc
|           `-- motd-complete
|-- root
|   `-- README.txt
`-- usr
    |-- lib
    |   `-- ruby
    |       `-- site_ruby
    |           `-- 1.8
    |               `-- facter
    |                   `-- rightscale.rb
    `-- local
        |-- bin
        |   `-- start-mcollective-demo.rb
        `-- etc
            `-- mcollective-node.motd
{% endhighlight %}

## Bundling Changes
Bundling up is based on [RightScale docs][bundling].

You need to copy your key, cert and have your credentials all into _/mnt_:

{% highlight console %}
% cp /dev/null /root/.bash_history
% rm -rf /var/tmp/mcollective1.2/

% ec2-bundle-vol -d /mnt -k pk-xx.pem -c cert-xx.pem -u 481328239245 -r i386
% ec2-upload-bundle -b mcollective-041-demo -m image.manifest.xml -a xx -s xxx
{% endhighlight %}

Now register the AMI in the [AWS console][Console] then make public after testing
