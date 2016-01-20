---
layout: default
title: " PE 3.2 » Razor » Install Razor"
subtitle: "Install and Set Up Razor"
canonical: "/pe/latest/razor_install.html"

---
A Razor module is included with Puppet Enterprise 3.2 . To install and configure a Razor server, you must [set up your Razor test environment](./razor_prereqs.html), and then classify the pe_razor node. When PE runs and applies this Razor classification, the Razor server and a PostgreSQL database will be installed and configured.   

In addition to the Razor server, the Razor client can be installed as a Ruby gem on any machine you want to use for interacting with Razor. 
 
**Important**: Because Razor is a Tech Preview, we highly recommend that you set it up in a completely isolated test environment. This environment must have access to the internet. See [Set Up a Virtual Environment for Razor](./razor_prereqs.html) for details.
	 
### Before You Begin
Things you should know before you set up provisioning:

+ **Do not** install Razor on the puppet master.
+ The default port for Razor is 8080. This is also the default port for PuppetDB, so you cannot have PuppetDB and Razor installed on the same node.
+ Razor has been specifically validated on RHEL/CentOS 6.4, but it should work on all 6.x versions. See the [CentOS site](http://isoredirect.centos.org/centos/6/isos/x86_64/) for options.

>**Hint**: With the `export` command, you can avoid having to repeatedly replace placeholder text. The steps for installing assume you have declared a server name and the port to use for Razor with this command:
>
>     export RAZOR_HOSTNAME=<server name> 
>     export RAZOR_PORT=8080
>    
> For example: 
>
>	  export RAZOR_HOSTNAME=centos6.4 
>	  export RAZOR_PORT=8080	
>	
> The steps below therefore use `$RAZOR_HOSTNAME` and `$RAZOR_PORT` for brevity.

Install the Razor Server
-------------

The actual Razor software is stored in an external online location, so you need an internet connection. When you classify a node with the pe_razor module, the software is downloaded. This process can take several minutes. 

If you don't have access to the internet or would like to pull the PE tarball from your own location, you can use the class parameter `pe_tarball_base_url` and stipulate your own URL. Note that the code assumes that the tarball still has the same name format as on our server. 

1. Manually add the `pe-razor` class in the PE console. To do so, on the console sidebar, click the **Add classes** button. Then, in **Add classes** under **Don't see a class?** type in "pe-razor" and click the green plus (+) button. For information about adding a  class and classifying the Razor server using the PE Console, see the [Adding New Classes](./console_classes_groups.html#adding-new-classes.html) and [Editing Classes on Nodes](./console_classes_groups.html#editing-classes-on-nodes) sections of this guide. 


	**Note**: You can also add the following to site.pp:
	
		node <AGENT_CERT>{
			include pe_razor
		}
	
2. On the Razor server, run puppet with: `puppet agent -t` (otherwise you have to wait for the scheduled agent run).


### Load iPXE Software

You must set your machines to PXE boot. Without PXE booting, Razor has no way to interact with a system. This is OK if the node has already been enrolled with Razor and is installed, but it will prevent any changes on the server (for example, an attempt to reinstall the system) from having any effect on the node. Razor relies on "seeing" when a machine boots and starts all its interactions with a node when that node boots.

Razor provides a specific iPXE boot image to ensure you're using a compatible version. 

1. Download the iPXE boot image [undionly-20140116.kpxe](http://links.puppetlabs.com/pe-razor-ipxe-firmare-3.2).
2. Copy the image to `/var/lib/tftpboot`: `cp undionly-20140116.kpxe /var/lib/tftpboot`.
	
3. Download the iPXE bootstrap script from the Razor server to the `/var/lib/tftpboot` directory: 

		wget http://${RAZOR_HOSTNAME}:${RAZOR_PORT}/api/microkernel/bootstrap?nic_max=1 -O /var/lib/tftpboot/bootstrap.ipxe
		
 **Note**: Make sure you don't use `localhost` as the name of the Razor host. The bootstrap script chain-loads the next iPXE script from the Razor server. This means that it has to contain the correct hostname for clients to try and fetch that script from, or it isn't going to work.	
		
		
### Verify the Razor Server 

Test the new Razor configuration: `wget http://${RAZOR_HOSTNAME}:${RAZOR_PORT}/api -O test.out`.
	
The command should execute successfully, and the output JSON file `test.out` should contain a list of available Razor commands.


Install and Set Up the Razor Client
-------------

The Razor client is installed as a Ruby gem. 

1. Install the client:

		gem install pe-razor-client --version 0.14.0
		
2. You can verify that the Razor client is installed by printing Razor help:

		razor -u http://${RAZOR_HOSTNAME}:${RAZOR_PORT}/api

3. You'll likely get this warning message about JSON: "MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."  This message is harmless, but you can disble it with this command:

		gem install json_pure

**Note**: There is also a `razor-client` gem that contains the client for the open source Razor client. It is strongly recommended to not install the two clients simultaneously, and to only use `pe-razor-client` with the Razor shipped as part of Puppet Enterprise. If you already have `razor-client` installed, or are not sure if you do, run `gem uninstall razor-client` prior to step (1) above.

* * *

[Next: Razor Provisioning Setup](./razor_using.html)
