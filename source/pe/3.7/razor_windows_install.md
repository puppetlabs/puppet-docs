---
layout: default
title: " PE 3.7 » Razor » Setting Up and Installing Windows "
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

It takes a while for the build script to run. Eventually, an image will be output that matches `razor-winpe\*.wim` under the current working directory.  This is your custom WinPE image with the required components to work with the Razor server.

### Create a Repo
Next, create the repository from your Windows installer with the command `razor create-repo --name=<repo name> --iso-url <URL> --task <task name>`.

If your Windows DVD image triggers a bug in `libarchive` that prevents unpacking, you can use a tool like `7zip` to unpack the Windows ISO image without going through libarchive.

To work around the incompatibility between some Windows DVD images, and the `libarchive` code used in Razor to unpack them, perform the following steps:

1. First, verify that your Windows image requires this workaround by trying to create a repository using it.
Razor will emit log messages indicating that the task of unpacking the repository has been pushed into the background. If unpacking fails, the logs say that unpacking needs to be retried. You must delete the repository before you go on to the next steps.
2. Have a normal installation of Razor ready to go, up to the point that you are ready to create the Windows repository. Make sure creating a repository is working correctly, for example, by creating a repository with a Linux CD or DVD image.
3. Run the `create-repo` command again but with the `--no_content` argument rather than `--iso-url` or `--url`. This creates a blank repo directory and skips the `libarchive` unpacking stage. Keep the rest of the details (for example, the repo's name) the same.
4. Install the `p7zip` or `p7zip-full` package for your platform, with ISO image support.
Alternatively, anything that can unzip the ISO file will do. For example, you could mount(1) the CD or DVD image using the standard mount Linux command, and then use cp(1) to copy the files into the repository, or you could use another tool to extract the content of the image.
5. Unpack the Windows image into the repo directory, for example, using the command, `7z x .../windows.iso`. To find the directory, look in your config.yaml for the `repo_store_root` directory. The repo's directory should match the repo's name.
6. Copy the WinPE WIM you created earlier to the root of your repo, located by default at `/var/lib/razor/repo-store/<repo name>` and rename the image to `razor-winpe.wim`.

### Create SMB Share

Next, configure a server message block (SMB) server on the Razor server, exporting the Razor repositories. This is necessary because the WinPE environment can't use an HTTP source for installation, and neither can the Windows 8 installer software.

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

>**Note**: When the WinPE image gets booted, the Windows installer assumes that the default drive for a fresh install is D: when setting the broker to run. If this assumed default is wrong, then all you need to modify is the script in second-stage.ps1.erb.

# Using Your Windows Installation

Once you have policies set up, your Windows installation should just work if your policy binds a node.  If provisioning fails, you'll get a message at the command prompt.