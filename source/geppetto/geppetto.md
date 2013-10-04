---
layout: default
title: "Geppetto"
subtitle: "Introduction to Geppetto"
canonical: "/geppetto/latest/geppetto.html"
---

##What is Geppetto and what does it do?

Geppetto is an integrated development environment for Puppet. In other words, it is a simplified toolset for developing and integrating Puppet modules and manifests.

Built on Eclipse, Geppetto provides a puppet module editor that provides syntax highlighting, content assistance, error tracing/debugging, and code completion features. It also includes an interface to the [Puppet Forge](http://forge.puppetlabs.com/), which allows you to create modules from existing modules on the Forge as well as easily upload your custom modules. Geppetto is even integrated with git, enabling side-by-side comparison of code from a given repo complete with highlighting, code validation, syntax error parsing, and expression troubleshooting.

Geppetto is packaged so it can be downloaded and used immediately. It contains a full installation eclipse, meaning you can install tools as you would with the regular Eclipse IDE, and it handles multiple versions of Puppet, allowing you set the version that you're working with.

##What does it consist of?

(TBW)

##Installing Geppetto
You can install Geppetto as an all-in-one download that includes GitHub or Eclipse Subversive, a project that integrates Apache Subversion with Eclipse. Or, if you're already using Eclipse, you can install Geppetto into your existing development environment.

Geppetto is available in 32 and 64-bit versions for Linux, Mac OS X, and Windows. Because the all-in-one download doesn't contain Java development tools, it's smaller than adding Geppetto to an existing Eclipse install.

###Install Geppetto as an All-In-One Download

1. Download the appropriate version of Geppetto [here](http://puppetlabs.github.io/geppetto/download.html).
2. Unzip and run Geppetto.

###Add Geppetto to an Existing Version of Eclipse

1. In Eclipse, click **Help** -> **Install New Software**.
2. In the **Work with** box, add this link: http://puppetlabs.github.io/geppetto/download.html

	This URL is for use with a download manager. It's not meaningful to visit it with a browser.

	<IMAGE Geppetto_install_1.png>

3. Select Geppetto in the available software list, and then click **Next**.

4. Accept the license agreement and click **Finish**.

5. Close and reopen Eclipse.

**Note:** Using these steps, you can get support for Ruby coding by installing the Eclipse [Dynamic Languages Toolkit](http://www.eclipse.org/dltk/). Just be aware that the DLTK isn't supported by Puppet Labs.

##Working with Puppet Projects in Geppetto

Geppetto enables you to work with Puppet projects in a variety of ways. 

**Create new projects**  Work on new Puppet projects, Puppet modules, or Puppet projects based on [Forge](http://forge.puppetlabs.com/) modules. You can also create new projects based on existing projects checked out from Apache Subversion.

**Create new repositories**  You can create new repositories on GitHub or Subversion, and then populate those repositories with new or existing Puppet projects.

**Import and export projects**  From GitHub or Subversion, import existing Puppet projects, edit them, and then export them back to the repository that they came from. You can also publish modules directly to the Forge.

The following are some basic steps to get started with Puppet projects in Geppetto.

###Create New Puppet Projects

1. In Geppetto, click **File -> New -> Project** to open the **Select a wizard** dialog box.
	If the **Select a wizard** box doesn't open, for example, if you have previously created a project, click **File -> New -> Other**.
3. Expand the **Puppet** folder, and click **Puppet Project**.

	You can choose use this step to select a Puppet Module or Puppet Module from the Forge in this location as well.
4. Click **Next**, name the project, and click **Finish**.

	Now, start coding your Puppet project in Geppetto.

###Create a New Forge Project from an Existing One

1. Click **File -> New -> Project**.
2. In the **Select a wizard** dialog box, expand the Puppet folder, click **Puppet Project from Existing Forge Module**, and then click **Next**.
3. Next to the **Module** text box, click the **Select** button, enter a keyword, such as "mongodb", and then click **OK**. 
4. Select a module and then click **OK**. 
5. Select the folder you want to import the module to, and then click **Finish**. 
	
	
###Create New Repositories

1. Click **File -> New -> Other**.
2. In the **Select a wizard** dialog box, expand the **Git** folder, click **Git Repository**, and click **Next**.
3. Browse to the path for the new repository, give it a name, and click **Finish**.


	The steps are pretty similar to set up a Subversion repository. In that case, expand the **SVN** list and click **Repository Location**. Then provide the appropriate information in the wizard.

###Editing module metadata

All Puppet modules include a metadata.json file, which contains high level information about the module (version, author, license, dependencies, etcetera). Geppetto provides an easy editor for the metadata.json file. 

If you create a module using Geppetto's Project Wizard, you will have access to the metadata editor through metadata.json. 

If you have pulled a module from the [Puppet Forge](forge.puppetlabs.com), you will have two ways of accessing the metadata editor: Modulefile and metadata.json. Upon pulling a module from the Puppet Forge, Geppetto will open the Modulefile editor automatically. 

If you have pulled a module from a Git or SVN repo, whether there will be a Modulefile or not depends upon how that module was built. 

Whether Modulefile is there or not is not important, as Modulefile and metadata.json contain and share the same information, and the metadata editor is entirely the same. 

Opening the metadata editor will bring you to the Overview screen. 
{fields}

There are also tabs for the module's dependencies, and the raw, editable json. 

###Publishing modules to the Forge (L) 

TBW