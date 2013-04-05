III. Automating Your Infrastructure
-----


### How Can PE Help You?

The particulars of every admin's infrastructure will vary, but all sysadmins have some needs in common. They want to be more productive and agile, and they want keen, timely insight into their infrastructure. In this section, we identify some of these needs and provide examples of ways to meet them by using PE to automate stuff. If you've been an admin for any period of time, these wants should be all too familiar:

1. I want to learn how to use a tool that will make me a more efficient sysadmin, so I can go home earlier (or get to the pub, or my kids' soccer game, or the weekly gaming session, dragon boat race, naked knitting club meeting, etc.). If you're reading this, it's safe to assume the tool you want to learn is PE.

2. I want to know beyond a shadow of a doubt that I can always securely access any machine in my infrastructure to fix things, perform maintenance or reconfigure something. I don't want to spend much time on this. I just want it to work.

3. I don't want to get repeated requests at all hours to fix simple mistakes. I want my infrastructure to care for itself, or at least be highly resistant to stupid.

4. I want fast, accurate reporting so that I know what's going on and can recover from issues quickly, with minimal downtime. I want my post-mortems to read: "I saw what was broken, I restored it, the machine was down for 2 minutes."

5. I want to be able to implement changes quickly and repeatably. Pushing out a new website (shopping cart app, wordpress template, customer database) should be trivial, fast and reliable (see above re: getting to the pub, etc.).

Below, we'll run through some examples that will help a hypothetical admin meet all these needs by automating things with PE with the assistance of pre-built modules from the [Puppet Forge](http://forge.puppetlabs.com).  We've tried to choose things that are low-risk but high-reward so that you can try them out and can not only build your confidence working with PE, you can also actually start to get your infrastructure into a more automated, less on-fire condition relatively soon. Even if the specific services we discuss aren't identical to your particular infrastructure, hopefully these examples will help you see why PE can make you a better, less stressed admin. 

### A (not-so) Fictional Scenario

Judy is a sysadmin at a mid-sized flying car manufacturing concern, the Enterprise National Car Company (NCC). The company is undergoing yet another periodic reorganization, and Judy has been tasked with administering the marketing department's servers. Previously, the department had been maintaining their own machines and so each server has been provisioned and configured in idiosyncratic ways. This has left an infrastructure that is time-consuming to manage, hard to survey, and very brittle. While you might think that flying cars sell themselves, the fact is, as management keeps reminding Judy, the marketing department is very important and needs to be up and running 24/7.

This new responsibility is not exactly welcome. Judy already has 14 things that consistently set her hair on fire. In addition, NCC is rolling out a new model, the 1701. She needs help. That help is Puppet Enterprise, which, luckily, her manager has just approved acquiring on a trial basis. If PE can work for the marketing department, Judy will get the go-ahead to deploy it across the enterprise.

Judy downloads PE and, following the first two sections of this guide and the additional documentation it references, she gets a master installed on a spare RHEL box and agents installed on the six servers that constitute the marketing department's infrastructure. After signing the various certificates, she is able to confirm by looking at the console that all the nodes are talking to the master. 

Enough preamble, let's start automating infrastructure.

(TODO screenshot)

### Five Things (+1) You Can Configuration Manage First

If you're not familiar with the Puppet Forge and the module download and installation process, the [installing modules page](http://docs.puppetlabs.com/puppet/2.7/reference/modules_installing.html) has all the details.

Note: As of PE 2.7, the module tool is not compatible with Windows nodes. In many cases, you can install modules on Windows nodes by downloading tarballs. You may also need to go the tarball route for Forge modules if local firewall rules prevent access to the Forge.

#### Thing One: MOTD

The first thing Judy wants to do is get familiar and comfortable with the tool. She needs to do something that will show her that PE is working to automate something, anything, on the nodes she has installed it on. She needs a real-world task that will impart some basic skills and confidence in the tool. Preferably something that even her boss can see and understand. She decides to start by managing MOTD.

This is a good idea on Judy's part. MOTD is not (usually) a mission-critical service but it can be a useful tool for communicating with users. MOTD  is simple and low-risk, but automating it will give her the experience and skills to automate similar resources. It's a very small step to go from automating MOTD to other text-like sorts of files like config files, boilerplate, HTML templates, etc.  Think of this as a PE "Hello World" exercise. 

Of course, that's not to say that MOTD in some modern systems (e.g., Ubuntu) can't be complex and powerful. Puppet can automate those kinds of implementations too. But for now, Judy needs to start simple.



(TODO:*Tip:* Generally speaking, using puppet as a fileserver is a bad idea except for small text-based things such as MOTD or config files. Serving larger files will cause performance bottlenecks and delayed puppet runs. It's better to use a dedicated package manager.  Luke says this is not true any more. What is true? Puppet is not Git, but...  )

#### Thing Two: Sudoers

#### Thing Three: NTP

#### Thing Four: Syslog

#### Thing Five: Apache

####: One More Thing: SSH/Root


###	What Next?

 
After going through the 5+1 Things above, you should have the confidence and skills with PE to move on to automating larger and/or more complex parts of your infrastructure. A good way to start is by identifying your day-to-day problems, headaches and chores and then use this list as suggestions for what should get automated next.
 
 You may find it helpful to make some lists inventorying the machines (virtual or otherwise), the software they are running, and their hardware configurations. This may take a little while, but you can take solace in knowing that once PE is up and running this will never be hard again. As part of this of inventorying process, you should determine what your change management process should be: what gets managed? how often? what maintenance tasks are required and when? And so on. 

*Tip:* Don't edit manifet or templates in Notepad. It will introduce CLRF line breaks that can break things, especially in the case of templates used for config files whose applications care about whitespace.



#### Use Existing Modules
Check [the Forge](https://forge.puppetlabs.com) or run `puppet module search` first so you don't waste time writing resource definitions, classes, etc. that already exist. It doesn't hurt to do github and google searches too.

#### Working With the Built-In Modules
Changing the built-in modules that come with PE is possible, even desirable. Simply copy them into the modules folder in `/etc/` and ensure that this folder is in your module path setting. However, *Always* keep a copy of the original module in `/opt`. 

#### Separate puppet code from config data see: [this blog post](http://puppetlabs.com/blog/the-problem-with-separating-data-from-puppet-code/)

#### Use syntax checking scripts

#### Define and assign classes/groups/resources


NOTES Section:

1. MOTD A simple, non-critical thing to start out with. Good proof of concept and a way to learn while doing a useful thing that is low risk. Module: puppetlabs/motd or rcoleman/motd?
2. Sudoers: Also simple, but important to locking down infrastructure. Module: saz/sudo
3. NTP: Useful because it helps other things, including PE, run better. Module: puppetlabs/ntp or saz/ntp?
4. Syslog: Helps to collect infrastructure info in a systematic way, lets you move on to automating more things since it gives you more confidence in knowing the state of the things. Module: saz/rsyslog?
5. MySQL? Every sysadmin needs to manage one or the other at some point. Module(s)?
6. SSH/Root. With caveats that this should be done only after some confidence and experience with PE has been accumulated and that they should be sure that they have a way to recover if it goes casters up. 

Possible Things:

motd
root user
sudoers
repositories
ssh
ntp
syslog
users/groups OR ldap/auth
networking / interface settings
iptables / firewall settings 
MySQL
Apache  

Daniel P.  would bump a handful of things up: they should probably have a solution for ad-hoc change across the infrastructure fairly early on that list.
They should focus on making sure DNS, NIS, LDAP, and other directory services are solid, and that NTP is good, before they focus on some of those items.
Managing those entities is valuable, but without that solid base they are going to run into the rocky shoals of "Puppet doesn't work", and without the ad-hoc tool they are going to break something and be unable to recover
They should probably not manage networking early in the life of their work at all; I don't blame them for wanting to, but that is the area where errors have a huge cost, compared to benefit. 

NB Nigel's variant on the Pittman "greenfield" approach. Since in reality sysadmins are too busy putting out fires to build new, experimental machines, they can start with Puppet by using it to configure some machine that a dept. has been asking for that has been perennially back-burnered.

Don't forget Jeff's passwordless login example. Check email followup. 
                    
Addressing Windows users is important. Either give some alternate modules, or provide call-outs with the steps a Win Admin would take.

Recast this as "5 Whys" as in the why are we doing these five things. Use a story about a sysadmin who needs to update his company's website. 

1. I need to learn Puppet so I can use it to do tasks like this quickly, easily and efficiency. Example: MOTD is a "Hello World" learning process.
2. I want to be able to always access my machines so I can fix stuff if it goes wrong.  Example: managing SSH, root user and sudoers
3. I don't want to be interrupted to fix simple errors by my users. Example: user access privileges (via console auth?) or Apache config checks
4. I want better reporting so I can know what is happening and recover faster, reducing down-time. Example: managing syslog 
5. I want to make changes fast across several machines. Example: pushing a new site across 10 VMs running Apache.
