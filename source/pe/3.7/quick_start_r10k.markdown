---
layout: default
title: "PE 3.8 » Quick Start » r01k"
subtitle: "r01k Quick Start Guide"
canonical: "/pe/latest/quick_start_r10k.html"
---

## r10k Quick Start Guide

The primary purpose and benefit of r10k is that it provides a localized place in Puppet for you to manage the configuration of various environments (such as production, development, or testing), including what specific versions of modules are in each of your environments, based on code in branches of one or more Git repositories. R10k accomplishes this by seamlessly connecting the code in your Git repository's branches with the Puppet environments it has created based on those branches. So the work you do in Git is reflected in your Puppet configuration!

In this guide you'll version the code you wrote for the Hello, World! module for two different environments---one you'll call `production` and the other `test_message`. Each of these environments will map to a specific branch named after the environment in a repo called **puppet-control**. Each branch (that maps to an environment) in the **puppet-control** repo will contain a `Puppetfile` that references the Hello, World! module repo's URL and latest commit ID for the code changes. When you run r10k on the Puppet master, it will read the `Puppetfile` and pull down different versions of the Hello, World! module---in other words, a version of the module for each branch (or environment).

<!--insert image here--!>

This guide is meant to be a simple proof-of-concept primer for getting to know r10k. For more information, see the main [r10k docs](link).

> ## Assumptions and Prerequisites
>
> Before beginning please review the following assumptions and prerequisites. 
>
>- To follow this guide, we assume the following machines are available:
>
>   - A Puppet master running on a monolithic or split installation of PE 3.8 (e.g., `master.example.com`). Note that this guide uses the PE console.
>   - An admin machine for writing Puppet code and versioning it with Git (e.g., `admin.example.com`).  
>   - A Puppet agent node (e.g., `agent.example.com`) that can communicate with your 3.8 master. You'll need to ensure that time is synced between your Puppet agent node and your Puppet master, and that these machines can reach each other by name. This can be done with a local DNS server or by editing the `/etc/hosts` file on each machine.
>
>- Git should be installed on the admin machine and the Puppet master server.  
>- You have create two version-controlled repositories. Note that this guide relies heavily on some basic knowledge of Git. 
>
>   For ease of use, the repos should be called **puppet-control** and **puppet-helloworld**. The user on the admin machine will need full read/write access to these repos, and the Puppet master will need read access. Git and Github users should see Github's [Generating SSH keys](https://help.github.com/articles/generating-ssh-keys/) for details on setting up SSH access to your repos.
>- The **puppet-control** and **puppet-helloworld** repos should be cloned to a working directory on the admin machine:
>
>   - `$working-dir/puppet-control`
>   
>   - `$working-dir/puppet-helloworld`
>
>- You have completed the [Hello, World! Quickstart Guide](/quick_start_helloworld.html), and committed that module to the **puppet-helloworld** repo. 
>- The Puppet master must have the `zack-r10k` module installed on it. (From the Puppet master, run `puppet module install zack-r10k`.)

The major steps you'll perform in this guide are as follows:

- **Step 1**: Prepare the **puppet-control** repo.
- **Step 2**: Rename the master branch of the **puppet-control** repo.
- **Step 3**: Configure r10k on the Puppet master and run the `production` environment.
- **Step 4**: Version the code in the Hello, World module and create the `test_message` environment.
- **Step 5**: Deploy the `test_message` environment.
- **Step 6**: Test the environments on a Puppet agent node. 
  
 
### Step 1: Prepare the **puppet-control** repo
 
Unless otherwise indicated, you'll perform the steps in this section on your admin machine. 
 
 1. If you have not already done so, create a working directory and clone the **puppet-control** and **puppet-helloworld** repos into it. 
 2. Change into the `puppet-helloworld` directory with `cd puppet-helloworld`.
 3. Gather the most recent good commit ID, which is an sha-1 hash that is unique for every Git commit. Run `git rev-parse HEAD` and copy the ID.
 4. Navigate to the `puppet-control` directory.
 5. In the `puppet-control` directory, create a file called `Puppetfile` (e.g., run `touch Puppetfile`.) (Note that this file **must** have a capital "P"). 
 6. Open `Puppetfile` and edit it so that it contains the following Puppet code:
 
        forge "https://forge.puppetlabs.com/"
    
        mod 'helloworld',
          :git => 'https://github.com/<YOUR GITHUB ORGANIZATION or GITSERVER>/puppet-helloworld.git', 
          :ref => '<COMMIT ID YOU COPIED IN STEP 3>'
          
    >**Note**: Be sure you avoid any syntax errors when writing the code. 
      
7. Save the file.
8. Still in the `puppet-control` directory, run `mkdir manifests`.
9. **From the Puppet master**, copy `/etc/puppetlabs/puppet/environments/production/manifests/site.pp` and move it into the `manifests` directory created in Step 8 (e.g., run `scp /etc/puppetlabs/puppet/environments/production/manifests/site.pp user@admin.example.com:~/wip/puppet-control/manifests/`).
10. From the root of `puppet-control` create a file called `environment.conf` (e.g. `touch environment.conf`). 
11. Open `environment.conf` and edit it so that it contains the following Puppet code:

        modulepath = modules:$basemodulepath
        environment_timeout = 0
        
12. From the root of the `puppet-control` directory, run` git status`. This will show you the files that you've created and edited, which are ready to be committed. 
13. Run `git add --all`, and then run `git commit -m  "this is my initial commit"`.
14. Run `git push origin master`. This will push your changes to the remote **puppet-control** repo.

### Step 2: Rename the master branch of the **puppet-control** repo to production

The default Puppet environment is `production`. You need to rename the **puppet-control** repo `master` branch to `production`, and then delete the `master` branch, as it will not map to any Puppet environments when you run r10k. 

You'll perform the steps in this section on your admin machine. 

1. From the `puppet-control` directory create a new branch called `production`. Run `git checkout -b production`. This creates the `production` branch and changes to it.)

   >**Tip**: `git branch` will list all the branches in your repo, and the "*" indicates which branch you're on.
    
2. Push the new `production` branch to the remote **puppet-control** repo. Run `git push origin production:production`. 
3. Using Github.com, set the default branch to `production`. (See [Setting the default branch](https://help.github.com/articles/setting-the-default-branch/).) 
4. From the `puppet-control` directory on your admin machine, delete the `master` branch. Run `git branch -d master`. (Note that you should not have changed any files in this directory since you last committed.)

   >**Tip**: `git branch` will show that the `master` branch has been deleted, in that the branch will no longer be listed. 

5. Delete the `master` branch from the remote **puppet-control** repo. From the `puppet-control` directory on your admin machine, run `git push origin :master`. 

   > **Note**: At this point, in the **puppet-control** repo, you have a `Puppetfile`, a `production` branch with `site.pp`, and a environment config file.

### Step 3: Configure r10k on the Puppet master and deploy the `production` environment

You'll perform the steps in this section on your Puppet master.

1. On the Puppet master, cd to a temp dir (e.g., `/var/tmp/`) and create a file named `r10k.pp` (e.g., `touch r10k.pp`).
2. Open `r10k.pp` and edit it so that it contains the following Puppet code:  

        class { 'r10k':
          remote       => 'https://github.com/<YOUR GITHUB ORGANIZATION or GITSERVER>/puppet-control.git',
          r10k_basedir => '/etc/puppetlabs/puppet/environments',
        }
        
   >**Note**: Be sure you avoid any syntax errors when writing the code. 

3. Run `puppet apply <FULL PATH to r10k.pp>`.

   This Puppet run will generate `/etc/puppetlabs/r10k/r10k.yaml`. This file contains the following code:
   
       cachedir: '/var/cache/r10k'

       sources:
          puppet:
            remote: 'https://github.com/<YOUR GITHUB ORGANIZATION or GITSERVER>/puppet-control'
            basedir: '/etc/puppetlabs/puppet/environments'
    
   In this case `remote` is the **puppet-control** repo, and `basedir` maps to the `$environmentpath`, the default of which is `/etc/puppetlabs/puppet/environments`.
    
4. Change into the r10k directory (run `cd /etc/puppetlabs/r10k`), and run `r10k deploy environment -p -v`.

   This run of r10k will contact the **puppet-control** repo, and will, because of the contents of `Puppetfile`, pull the down the **puppet-helloworld** module that is on the `production` branch.

5. After the run completes, navigate to `/etc/puppetlabs/puppet/environments/` to see the `production` environment and that it contains the **puppet-helloworld** module.

6. Apply the **puppet-helloworld** module to `production` environment. Run `puppet apply -e 'include helloworld' --environment production`.

   You'll see the notify appear on the command line. In addition you can run `puppet apply -e 'include helloworld::motd'   --environment production`, and then run ` cat /etc/motd`.
   
   >**Tip**: If there are any syntax errors in your Puppet code, you will be warned at this step. If there are errors, you will need to return to your admin machine, correct the Puppet code in the **puppet-helloworld** module, commit the change, gather the commit ID, update `Puppetfile` in the **puppet-control** repo with the commit ID, commit that change, and then re-deploy r10k from the Puppet master.  

### Step 4: Version the code in the Hello, World module and create the `test_message` environment

In this step, you'll change the Hello, World! module so that it contains a new message for a new environment, and then create a new branch that maps to the new environment.

You'll perform the steps in this section on your admin machine. 
     
1. **On the admin machine**, navigate to the `manifests` directory in `puppet-helloworld`. 
2. Edit `init.pp` and `motd.pp` so that content of the message is different (e.g., change Hello, world! to Hello, world! Welcome to Puppet Enterprise!).
3. Run `git add --all`, and then run `git commit -m "this is a commit to change the motd"`. (Note that your commit message can be whatever you want, but make sure it describes the nature of the commit.)
4. Run `git push origin master`. 
5. Run `git log` and copy the most recent commit ID (which is the first commit ID listed).
6. Navigate to the `puppet-control` directory, and run `git branch` to ensure you're still on the `production` branch.
7. Run `git pull origin production` to ensure your local repo branch is up to date.
8. Still in the `puppet-control` directory, create a new branch called `test_message`. Run `git checkout -b test_message`.

   >**Tip**: Run `git branch` to ensure the `test_message` branch was created.

9. Open `Puppetfile`, and for the `ref` line, paste in the commit ID you copied in step 5. (Be sure the commit ID is in single quotes; e.g. `:ref => <'COMMIT ID'>`.)
10. Save and close `Puppetfile.`
11. Still in the `puppet-control` directory, on the `test_message` branch, run `git add --all`, and then run `git commit -m  "this is a commit to update Puppetfile for the test_message branch"`.  
12. Run `git push origin test_message:test_message`.

Once these changes are pushed up, the new `test_message` environment is available to deploy from the Puppet master.

### Step 5: Deploy the `test_message` environment

You'll perform the steps in this section on your Puppet master.

1. Change into the r10k directory (run `cd /etc/puppetlabs/r10k`), and run `r10k deploy environment -p -v`.

   This run of r10k will contact the **puppet-control** repo, and will, because of the contents of `Puppetfile` on each branch, pull the down the **puppet-helloworld** module for the `production` and `test_message` branches.
   
2. After the Puppet run completes, navigate to `/etc/puppetlabs/puppet/environments/` to see the `production` and `test_message` environments, and that they both contain the **puppet-helloworld** module. (Navigate into the `manifests` directories and note the differences between the `motd.pp` files.)

3. Apply the **puppet-helloworld** module to the `test_message` environment. Run `puppet apply -e 'include helloworld' --environment test_message`.

   On this run, you will see the new message you created for the `test_message` environment. You can also run `puppet apply -e 'include helloworld::motd' --environment test_message` followed by `cat /etc/motd`. Additionally, run the `production` environment again to see the original message. 
   
   >**Tip**: If there are any syntax errors in your Puppet code, you will be warned at this step. If there are errors, you will need to return to your admin machine, correct the Puppet code in the **puppet-helloworld** module, commit the change, gather the commit ID, update `Puppetfile` in the **puppet-control** repo with the commit ID, commit that change, and then re-deploy the r10k from the Puppet master. 
   
   At this point, you're ready to test your environments on a Puppet agent.  

### Step 6: Test the environments on a Puppet agent node

In this section, you'll use the PE console and a Puppet agent (`agent.example.com`) to verify the work you've done up to this point. Before you test the module on your Puppet agent node, you will need to use the PE console's node classifier to set up a) an environment group for the `test_message` environment and b) a few node groups you'll use to classify your agent node.

> **Tip**: Instead of using just one Puppet agent node in this section, you could use two and set each node to a different environment per the following instructions. 

1. In the PE console, create a group called **Helloworld Test Environment**. 

   a. Navigate to the **Classification** page, and in the **Node group name** field, enter **Helloworld Test Environment**, and click **Add group**. 
   
   b. Select the **Helloworld Test Environment**, and from the **Rules** tab, in the **Certname** field, add the name of your agent node (e.g., `agent.example.com`).
   
   c. Click **Pin node**.
   
   d. Click **Edit node group metadata**.
   
   e. Select the checkbox for **Override all other environments**. 
   
   f. From the **Environment** drop-down list, select **test_message**, and from the  **Parent** drop-down list, select **Production**.
   
   g. Click the **Commit changes** button. 
   
2. Create a group called **Helloworld Test Message**.

   a. In the **Node group name** field, enter **Helloworld Test Message**, from the **Environment** drop-down list, select **test_message**, and click **Add group**.
   
   b. Select the **Helloworld Test Message** group, and from the **Classes** tab, in the **Add new class** field, enter the `helloworld` and the `helloworld::motd` classes. Click **Add class** for each class.
   
   c. From the **Rules** tab, in the **Certname** field, add the name of your agent node (e.g., `agent.example.com`), and click **Pin node**. 
   
   d. Click the **Commit changes** button.

3. On the Puppet agent node, run `puppet agent -t`.

   When Puppet runs you should see the notify message for the `test_message` environment on the command line.  

4. After the agent run is complete, run `cat /etc/motd` to see your motd for the `test_message` environment. 

5. Create new node group called **Helloworld Production** and, following the steps above, assign it to the `production` environment, add the `helloworld` and `helloworld::motd` classes, pin the Puppet agent node to the group, and commit the changes.  
5. Remove the Puppet agent node from **Helloworld Test Environment** and **Helloworld Test Message** groups, and pin it to **Helloworld Production** group.  
6. On the Puppet agent node, run `puppet agent -t`.

   When Puppet runs you should see the notify for the production environment on the command line.  

7. After the agent run is complete, run `cat /etc/motd` to see your motd for the `production` environment. 

## Next Steps

As we stated at the beginning, we designed this QSG to serve as a primer for getting to know r10k. At this point, you may be ready to consider some more complicated patterns and workflows. Check out the [main r10k docs](/r10k/index.html). 






   
