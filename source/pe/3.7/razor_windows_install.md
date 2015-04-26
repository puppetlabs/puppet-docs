---
layout: default
title: " PE 3.8 » Razor » Setting Up and Installing Windows on Nodes"
subtitle: "Set Up Windows Installations"
canonical: "/pe/latest/razor_windows_install.html"
---

In order to provision machines with Windows, you must first create the Windows install. For licensing reasons, you need to have your own copies of Windows available: both the installer content, and the [Windows Assessment and Deployment](http://msdn.microsoft.com/en-us/library/windows/hardware/hh825486.aspx) toolkit, containing the Windows Preinstallation Environment (WinPE) that's used to automate the Windows installer.

The Windows installer support has been tested with:

 * WinPE 4 AMD64 built on Windows 8.0 AMD64
 * VMWare Fusion virtual machine
 * Windows 8 Professional installed to virtual machine

## Prerequisites

Before you begin, ensure that your DHCP server and your Razor server are on the same IP address, or that you HTTP forward on port 8150 from the DHCP server to the Razor server. If your DHCP server and Razor server are not on the same IP Address, you must hard code the IP Address or FQDN in the razor-client.ps1 file before building your WinPE image.

## Setting Up a Windows Installation

Making Windows installable by Razor is a multi-step process. Licensing on WinPE requires that you build your own custom WinPE WIM image containing Razor scripts, because we cannot redistribute a pre-built image.  The first stage is to build your own WinPE image suitable for use with Razor, as described below.

1. Install the [Windows Assessment and Deployment](http://msdn.microsoft.com/en-us/library/windows/hardware/hh825486.aspx) in the default location.
2. Copy the `build-winpe` directory content to a Windows machine.
3. Change into that directory, for example, `c:\build`.
4. Run this build script: `powershell -executionpolicy bypass -noninteractive -file build-razor-winpe.ps1 -razorurl http://razor:8150/svc`

It takes a while for the build script to run. Eventually, an image will be output that matches `razor-winpe*.wim` under the current working directory.  This is your custom WinPE image with the required components to work with the Razor server.

### Create a Repo

Ordinarily, you would create a repository with the command `razor
create-repo --name=<repo name> --iso-url <URL> --task <task
name>`. Unfortunately, Windows DVD images can generally not be unpacked by
Razor because of a limitation of the `libarchive` library that Razor uses
for that purpose.

As a workaround, create a stub repository and fill it manually
with content.

1. First, issue the following command with the Razor
client:

		razor create-repo --name win2012r2 --task windows/2012r2
           --no-content true

2. Once this command completes successfully, log into your Razor server as
root and cd into your server's `repo_store_root` set in `config.yaml`. Then
run:

      # mount -o loop /path/to/windows_server_2012_r2.iso /mnt
      # cp -pr /mnt/* win2012r2
      # umount /mnt
      # chown -R razor: win2012r2

### Add the WinPE image to your repo

Copy the `razor-winpe*.wim` image that you built onto your Razor server
and place it into the repository directory created in the previous step as
the file `razor-winpe.wim`.

In the previous example, you would simply run this command:

      # cp /some/where/razor-winpe*.wim win2012r2/razor-winpe.wim

### Create SMB Share

Next, configure a server message block (SMB) server on the Razor server, exporting the Razor repositories. This is necessary because the WinPE environment can't use an HTTP source for installation, and neither can the Windows installer.

This is a fairly simple share: allow anonymous access, call it `razor`, and point it to your repo store root, for example, the one from your config.yaml file. The file, smb.conf, at  `/etc/samba/smb.conf`, should look like this:


	[razor]
  		comment   = Windows Installers
 		 # this is, by default, under /var/lib/razor/repo-store/
  		path      = /var/lib/razor/repo-store/
  		guest ok  = yes
  		writable  = no
  		browsable = yes

You may also have to set your SMB server to "share" level security, as follows:

	[global]
  		security = share


### Create Razor Policies

Finally, [create your policies](./razor_using.html#create-policies) as normal.

>**Note**: When the WinPE image gets booted, the Windows installer assumes that the default drive for a fresh install is D: when setting the broker to run. If this assumed default is wrong, you need to modify the script `second-stage.ps1.erb` and rebuild your WinPE image.

# Using Your Windows Installation

Once you have policies set up, your Windows installation should just work if your policy binds a node.

* * *


[Next: Razor Command Reference](./razor_reference.html)
