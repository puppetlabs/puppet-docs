---
layout: default
title: "Geppetto"
subtitle: "Introduction to Geppetto"
canonical: "/geppetto/latest/geppetto.html"
---
[geppetto_install]: ./images/geppetto_install.png
[IDE_overview]: ./images/IDE_overview.png
[prev]: ./images/geppettoprev.png
[add]: ./images/geppettoaddpuppetdb.png
[events]: ./images/geppettoevents.png
[refresh]: ./images/geppettorefresh.png

##What is Geppetto?

Geppetto is an integrated development environment for Puppet. In other words, it is a simplified toolset for developing and integrating Puppet modules and manifests.

>**Note**: Geppetto is an open-source tool that is maintained but not supported by Puppet Labs.

Built on Eclipse, Geppetto provides a puppet manifest editor that provides syntax highlighting, content assistance, error tracing/debugging, and code completion features. It also includes a puppet module editor and an interface to the [Puppet Forge](http://forge.puppetlabs.com/), which allows you to create projects from existing modules on the Forge as well as easily upload your custom modules. Geppetto is even integrated with GitHub (Git) and Subversion (SVN) with Eclipse, enabling side-by-side comparison of code from a given repo complete with highlighting, code validation, syntax error parsing, and expression troubleshooting.

Geppetto also offers [integration with Puppet Enterprise](#geppetto-and-pe), giving you an additional resource view and error information based on PuppetDB data from the last puppet run.

Geppetto is packaged so it can be downloaded and used immediately. It contains a full installation of Eclipse, meaning you can install tools as you would with the regular Eclipse IDE. Geppetto handles multiple versions of Puppet, allowing you set the version that you're working with.

##Basic Overview

Here's how Geppetto looks with a couple of projects added to a fresh or first-time install.

![IDE_overview][IDE_overview]

Your version might be a little different, either because you added Geppetto to an existing installation of Eclipse that you'd already customized, or because you changed some of the views around when you first installed. If your views are arranged a little differently, you'll still get all the same functionality.

In the image above, you can see some of the most common work areas (this description is by no means comprehensive):

* The **Project Explorer** lets you easily navigate your Puppet project's file structure.

* As its name indicates, the **editor** is where you edit your code. Geppetto takes advantage of Eclipse's editing capabilities, like syntax highlighting, content assistance, and error tracing and debugging for your Puppet code.

* The **Outline** view shows a tree version of the code you're editing. It's useful for quickly finding the elements of your classes.

* You can use the **Tasks** view to create your own tasks and to automatically add tasks from comments in code.

##Installing Geppetto
Geppetto is available as an all-in-one download that includes GitHub or Eclipse Subversive, a project that integrates SVN with Eclipse. Or, if you're already using Eclipse, you can install Geppetto into your existing development environment.

Geppetto is available in 32 and 64-bit versions for Linux, Mac OS X, and Windows. Because the all-in-one download doesn't contain Java development tools, it's smaller than adding Geppetto to an existing Eclipse install.

###Install Geppetto as an All-In-One Download
1. Download the appropriate version of Geppetto [here](http://puppetlabs.github.io/geppetto/download.html).
2. Unzip and run Geppetto.

###Add Geppetto to an Existing Version of Eclipse
1. In Eclipse, click **Help** -> **Install New Software**.
2. In the **Work with** box, add this link: https://geppetto-updates.puppetlabs.com/4.x.
This URL is for use with a download manager. It's not meaningful to visit it with a browser.

	![Geppetto install in Eclipse][geppetto_install]

3. Select Geppetto in the available software list, and then click **Next**.

4. Accept the license agreement and click **Finish**.

5. Close and reopen Eclipse.

**Note:** Using these same steps, you can get support for Ruby coding by installing the Eclipse [Dynamic Languages Toolkit](http://www.eclipse.org/dltk/). Just be aware that the DLTK isn't supported by Puppet Labs.

##Working with Puppet Projects
Geppetto provides several options for creating and editing Puppet projects.

* **Create new projects**  Work on new Puppet projects, Puppet modules, or Puppet projects based on [Forge](http://forge.puppetlabs.com/) modules. You can create new projects based on existing projects from your local file system, and from Git or SVN.

* **Create new repositories**  You can create new repositories on Git or SVN, and then populate those repositories with new or existing Puppet projects.

* **Import and commit projects**  From Git or SVN, import existing Puppet projects, edit them, and then commit them back to the repository that they came from. You can also publish modules directly to the Forge.

The following are some basic steps to get started with Puppet projects in Geppetto.

###Create New Puppet Projects
1. In Geppetto, click **File -> New -> Project** to open the **Select a wizard** dialog box.
	If the **Select a wizard** box doesn't open, for example, if you have previously created a project, click **File -> New -> Other**.

3. Expand the **Puppet** folder, and click **Puppet Project**.
	You can select a Puppet Module or Puppet Module from the Forge in this location as well.
4. Click **Next**, name the project, and click **Finish**.

Now, start coding your Puppet project in Geppetto.

###Create a New Project from an Existing Module
1. Click **File -> New -> Project**.
2. In the **Select a wizard** dialog box, expand the Puppet folder, click **Puppet Project from Existing Forge Module**, and then click **Next**.
3. Next to the **Module** text box, click the **Select** button, enter a keyword, such as "mongodb", and then click **OK**.
4. Select a module from the list that's returned, and then click **OK**.
5. Give your project a name, and then click **Finish**.
    The module is now displayed in your Project Explorer.

###Create New Repositories
1. Click **File -> New -> Other**.
2. In the **Select a wizard** dialog box, expand the **Git** folder, click **Git Repository**, and click **Next**.
3. Browse to the path for the new repository, give it a name, and click **Finish**.


	The steps are pretty similar to set up an SVN repository. In that case, expand the **SVN** list and click **Repository Location**. Then provide the appropriate information in the wizard.

####Add a Repositories Perspective to the IDE
To easily interact with Git or SVN repositories in Geppetto, add the repositories' perspective to the IDE. From the Git Repositories tab, you can:

- Search and select Git repositories on your local machine
- Clone a Git repository
- Create a new Git repository

From the SVN Repositories tab, you can:

- Set a new repository location
- Create a repository

To open the repository perspective, in Geppetto, click **Window ->Open Perspective -> Other** and then select **Git Repository Exploring** or **SVN Repository Exploring**.

For more information about interacting with Git or SVN from Geppetto, refer to the EGit and Subversive user guides. On the Geppetto Help menu, click **Help Contents** to open the guides.

###Editing Module Metadata


All Puppet modules include a metadata file, which contains high level information about the module (version, author, license, dependencies, et cetera). Geppetto's editor provides an easy way to modify this metadata.

If you create a module using Geppetto's Project Wizard, you will have access to the same metadata editor through either the Modulefile or metadata.json.

If you have pulled a module from the [Puppet Forge](forge.puppetlabs.com) or a Git/SVN repo, you may edit the metadata via Modulefile or metadata.json, whichever is available. Whether there will be a Modulefile or not depends on how that module was built. Upon pulling a module from the Puppet Forge, Geppetto will open the Modulefile or metadata.json in the editor automatically.

Opening the metadata editor will bring you to the *Overview* screen. The *Overview* screen will display your metadata in individual text fields for editing. This metadata is split into two groups: *General Information* and *Details*.

Within *General Information*:

* **Name**: This field is unique as it has two text fields separated by a '-'. If you are planning to upload your module to the Puppet Forge at any point, the first field should contain your Puppet Forge username. The second field should contain the name of your module. (For more information on module naming, see [here](/puppet/latest/reference/modules_publishing.html#a-note-on-module-names))
* **Version**: Your module's current version number. It is important that this is kept up-to-date, as it impacts the ability for your modules to connect with one another via dependencies. We highly recommend using [semver](http://semver.org/) to guide your versioning.
* **Author**: The name of the module's author.
* **License**: Any applicable license guiding the module's use.

Within *Details*:

* **Source**: The repo where the module lives. If you used Geppetto to create your module, you can ignore this.
* **Project Page**: The GitHub page where the module's source code is published.
* **Summary**: A brief description of the module's functionality.
* **Description**: Originally, this was a space to give some more detailed information about your module, but this feature is being deprecated. Information you put in this field will be lost. Please enter detailed information about your module in the [README](/puppet/latest/reference/modules_documentation.html) instead.

If your module requires capabilities or functionality provided by another module in order to run properly, your module is dependent on that other module. From the *Dependencies* tab, you can add, delete, or edit dependencies for your module.

To add a dependency:

1. Click the **Add...** button.
2. Choose the module from the list of modules in your environment, and specify the version range (for instance, `>= 0.1.6`).
3. Click the **OK** button.

To edit a dependency:

1. Select the module from the list of dependencies, and click the **Edit…** button.
2. Update the module's name or version range as appropriate, or choose an entirely different module from the list to replace it.
3. Click the **OK** button.

To remove a dependency, simply select the module from the list of dependencies and click the **Remove** button.

You also have the option of editing your module's metadata within the raw json format. If you click on the *JSON* tab, you will have access to the json information and may edit it directly as you wish.

###Publishing Modules to the Forge

The [Puppet Forge](https://forge.puppetlabs.com/) is a repository of modules written by the Puppet community. Using and contributing to the Forge is a great way to crowdsource your work, and Geppetto makes publishing your modules to the Forge easy!

Geppetto allows you to publish one or several modules, as well as allowing you to publish only specific parts of a module. To get started publishing modules to the Forge, make sure the *Project Explorer* window is open. Then,

1. Right-click (or control+click) anywhere in the *Project Explorer* window and on the shortcut menu, click **Export**. OR, choose **File** -> **Export…** to open the Export Wizard.
2. In the *Export Wizard*, you can either type 'Forge' in the text box OR expand the Puppet folder.
3. Then choose **Export Modules to Forge** and click **Next**.
4. From here, you can choose to publish one or several modules, as well as choose what parts of the modules you would like to publish.
    * To publish all of one or more modules, simply click the checkbox(es) next to the name of the project(s) housing the module.
    * To publish only part of a module:
        * Select the project name and choose the individual files to include by clicking the checkboxes next to those filenames, OR
        * Click the arrow next to the project name and choose the individual folders/files by clicking the checkboxes next to the folder or filenames.
5. Enter your Forge username and password in the text boxes below the pane where you selected your modules. (If you do not have a Forge username, see the instructions [here](/puppet/latest/reference/modules_publishing.html#create-a-puppet-forge-account).)
6. Click **Finish**.

Geppetto will generate a pop-up confirmation window when your modules have been uploaded successfully. Clicking **OK** on this confirmation message will bring you back to your main Geppetto screens. Otherwise, you will recieve a pop up stating there were problems. Clicking **OK** on this error message will bring you back to the *Export Wizard*.

##Geppetto and PE

Geppetto offers a special view for Puppet Enterprise users, the *Puppet Resource Events View*. This new view is an integration with PuppetDB which enables Geppetto to query PuppetDB instances and get information about recent events.

The *Puppet Resource Events View* lists failures and successful changes from the most recent puppet run, and enables you to view the resource, file, etc. in the source code to help determine why the failure or success is occurring.

To access the *Puppet Resource Events View*

1. Click the **Window** menu,
2. Choose **Show View** -> **Other…**.
3. Then, when the *Show View* window pops up, expand the Geppetto folder and select **Puppet Resource Events**,
4. Click **OK**.

The *Puppet Resource Events View* window should now be available next to the *Tasks* and *Problems* tabs.

![Puppet Resource Event View in Geppetto][prev]

To set up a connection to your puppet master server, click the database image with the green plus sign on it.

![Add PuppetDB connection in Geppetto][add]

A setup window will pop up with the following fields:

* **Hostname**: The hostname of your PuppetDB server
* **Port**: The port to connect to PuppetDB on, defaults to 8081.
* **SSL Directory**: (Optional) If you point to an existing directory structure where your PEM files are, the remaining fields in the setup window will be populated automatically. This is useful for default layouts.
* **CA Cert File**: (Optional) If present, this will be your Puppet Certificate Authority's public certificate. Otherwise, the client will trust self-signed certificates for validation.
* **Host Cert File**: This file behaves like a puppet agent for authentication, setting up your public key for the machine Geppetto is connecting as.
* **Host Private Key File**: This file behaves like a puppet agent for authentication, setting up your private key for the machine Geppetto is connecting as.

If any of your required information is missing, it will be listed at the top of the window next to the red button and the **OK** button will be disabled.


In the *Description* column, you should see your PuppetDB server listed. Once added, PuppetDB connections cannot be edited. However, you may delete a connection by selecting it and clicking the database icon with the red 'x'.

If you expand your connected server, you should see *Failures* and *Changes*. Each of these can be expanded to show details of the events of the most recent puppet run.

By hovering over any listed event detail, you will see additional information about the event. Double-clicking on a listed event detail will open the source file to the place where the resource or file, etc. is defined so you can look it over to see what might be going wrong.

The events you see will only be events from the most recent puppet run. If puppet runs while you are working in Geppetto, you must refresh the *Puppet Resource Events* tab. You may do so by clicking the image with the green arrow.

![Refresh Puppet Resource Events][refresh]

**NOTE:** If you refresh after another puppet run, whatever you were looking at previously will be gone forever and you will see only the most recent run.
