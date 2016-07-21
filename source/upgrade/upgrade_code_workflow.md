---
layout: default
title: "Workflow for updating Puppet code"
canonical: "/upgrade/upgrade_code_workflow.html"
---

This guide is intended for anyone who needs to update their Puppet code in preparation for an upgrade from Puppet 3 to Puppet 4. It provides an opinionated workflow that uses Git to make changes in a controlled and testable manner. This workflow should be used in conjunction with an automated catalog diffing tool or static analysis tool.

For purposes of this guide we'll use the `catalog_preview` module to produce difference data and the `preview_report` module to present it in an easier to read format.

# Prerequisites

This workflow assumes you are currently running at least Puppet 3.8, have complete access to the Puppet code base, and have the ability to create new branches and deploy them as environments to a Puppet master on which you will run your tests.

# Preparation

## 1. Create your working branch

Start by creating a branch from the `production` branch in your control repository. Name the new branch something along the lines of `future_production` (This is what the catalog preview module assumes). This will be the branch in which you will do most of your work.

```
git checkout production
git checkout -b future_production
```

### Enable the future parser

In this new branch, turn the future parser on by adding `parser=future` to [`environment.conf`](https://docs.puppet.com/puppet/3.8/reference/config_file_environment.html). Create this file if it does not already exist.

```
cd "$(git rev-parse --show-toplevel)"
echo "parser=future" >> environment.conf
git add environment.conf
git commit -m "Enable the Puppet 4 parser in future_production"
```

## 2. Tooling

Set up the [catalog preview](https://forge.puppet.com/puppetlabs/catalog_preview) module and the [preview report](https://github.com/puppetlabs/prosvc-preview_report) generator on a PE 3.8 Puppet master.

### PE 3.8 master

You will need a Puppet Enterprise 3.8 master as it uses a version of Puppet (3.8.x) that can run with the Puppet 3 or 4 parser.

A quick way to create the Puppet master is to use the [Puppet Debugging Kit and spin up its 3.8.5 master](https://github.com/Sharpie/puppet-debugging-kit/blob/83871b9afffa4ca14f011bfd4c2489725eb1bb31/config/vms.yaml.example#L31-L40) in Vagrant on your laptop (as shown below). A better solution, if you have the capacity, is to create a VM or physical server on the network with access to your code base.

```
git clone https://github.com/Sharpie/puppet-debugging-kit.git
cd puppet-debugging-kit
cp config/vms.example.yaml config/vms.yaml
vagrant plugin install oscar
vagrant up pe-385-master
vagrant ssh pe-385-master
```

If you're using r10k, set up this master to be able to synchronize code from your control-repo. Using the [zack/r10k](https://forge.puppet.com/zack/r10k) module is likely the easiest way to do this. You'll also probably need to [create and authorize SSH keys](https://forge.puppet.com/zack/r10k#setup-requirements) for this new 3.8 master.

### Catalog preview

Install the catalog preview module in the global modulepath:

```
[root@pe-385-master ~]# puppet module install puppetlabs-catalog_preview --modulepath /etc/puppetlabs/puppet/modules/
Notice: Preparing to install into /etc/puppetlabs/puppet/modules ...
Notice: Downloading from https://forgeapi.puppetlabs.com ...
Notice: Installing -- do not interrupt ...
/etc/puppetlabs/puppet/modules
└── puppetlabs-catalog_preview (v2.1.0)
```

#### Get a list of all active nodes

The catalog preview module accepts a list of nodes to compile a catalog for. This list can be created to include all currently "active" nodes in a couple of ways.

Instead of trying to cover every single node individually, generate a list of nodes that is a representative cross-section of all the nodes and includes as many of the roles or profiles without too much duplication. This shortened list gives you a smaller number of catalogs to compare thus taking less time and getting you feedback on your code updates faster.

##### PuppetDB query

On the production Puppet Master, install PuppetDB Query. Version 1.6.1 is the latest to support PuppetDB 2.x.

```
puppet module install dalen-puppetdbquery --version 1.6.1 --modulepath /etc/puppetlabs/puppet/modules/
puppet plugin download
puppet query nodes "(is_pe=true or is_pe=false)" > nodes.txt
```

##### No PuppetDB query

If PuppetDB isn't available, you can scrape the YAML cache and collect the results together.

`ls -1 $(puppet config print yamldir)/node | awk -F\. 'sub(FS $NF,x)' > nodes.txt`

This list needs to be manually cleaned of nodes that are inactive or you could use the below script or something like it to looks at the time stamp of the YAML files and filters based on last write date.

You can find all YAML files that were accessed in the last hour, for instance, with:

`find $(puppet config print yamldir)/node -maxdepth 1 -type f -mmin -60`

#### Node data: YAML facts

The catalog preview module works by compiling catalogs for nodes and inspecting the resultant catalog. It compiles a catalog by using the existing node objects and their facts to simulate a Puppet run against that node. This means interacting with PuppetDB where all the data is stored.

It's likely your catalog preview server doesn't have access to PuppetDB data. You can get around that by using the cached facts and node data that are stored as YAML on the real Puppet masters.

First, collect the cached yaml fact files off of the production master.  If there's just one master, you should be able to copy them over wholesale with something like this, executed from the diff master:

```
scp -r production-master:/var/opt/lib/pe-puppet/yaml/facts/* \
  /var/opt/lib/pe-puppet/yaml/facts
```

Next, tell the diff master to use the yaml terminus when looking for nodes' facts.  If your diff master can still do a puppet agent run against itself -- and now that the customer's code is on it, it's entirely likely it can't -- you can just set the puppet_enterprise::profile::master::facts_terminus parameter in the console to "yaml".  It's in the PE Master node group.

Or you can edit the /etc/puppetlabs/puppet/routes.yaml file directly on the diff master, to look something like this:

```
master:
  facts:
    terminus: yaml
    cache: yaml
```

If you change the routes.yaml file by hand, restart pe-puppetserver afterwards.

```
systemctl restart pe-puppetserver
```

### Preview report generator

Install the catalog preview report generator (`prosvc-preview_report` on the Forge) and its requirements onto the PE 3.8 master.

```
[root@pe-385-master ~]# git clone https://github.com/puppetlabs/prosvc-preview_report.git
[root@pe-385-master ~]# /opt/puppet/bin/gem install markaby
```

## 3. Generate a baseline report

Run the catalog preview module against the `production` branch and the `future_production` branch. The first run is to generate a hit list of issues to solve. Start by fixing the issues that are most common or the ones that affect the most nodes, likely those that cause a catalog compilation error. It is important to solve compilation errors first because there could be issues hiding behind a failed catalog.

Think of this entire process as peeling back an onion. You'll need to go through layer by layer until you get to the delicious oniony center.

### Running a catalog preview

```
sudo puppet preview \
  --baseline-environment production \
  --preview-environment future_production \
  --migrate 3.8/4.0 \
  --nodes nodes.txt \
  --view overview-json | tee ~/catalog_preview_overview-baseline.json
```

> **Note:** Save this first report! It acts as the starting metric that you will compare your progress against.

### Excluding resources from a catalog preview

The `puppet preview` command can also take an `--excludes <filename.json>` argument. It reads the file supplied as <filename.json> and looks for an array of resources to ignore. You can exclude whole types, types with a particular title, certain attributes of any resource of a given type, and selected attributes of a particular type and title.

For example, the following example.json file would ignore all Augeas resources, all attributes of Service['pe-mcollective'], any File resource's 'source' attribute, and finally the Class['Puppet_enterprise::Mcollective::Server] attributes 'activemq_brokers' and 'collectives'.

````json
[
  {
    "type": "Augeas"
  },
  {
    "type": "Service",
    "title": "pe-mcollective"
  },
  {
    "type": "File",
    "attributes": [ "source" ]
  },
  {
    "type": "Class",
    "title": "Puppet_enterprise::Mcollective::Server",
    "attributes": [
                    "activemq_brokers",
                    "collectives"
                  ]
  }
]
````

>**Note:** Ignoring a particular Class resource only ignores the resource representing the Class, as it appears inside the catalog. It does not (as you might have hoped) exclude all resources declared inside that class. It just ignores the attributes (parameters) of the class itself.

### Generate a report

Taking the overview JSON output from the catalog preview module, pass it through the Preview Report generator to get a nice HTML report of the run. It might be a good idea to run a simple webserver with Apache or Nginx to be able to view these reports remotely.

```
cd ~/prosvc-preview_report
sudo ./preview_report.rb -f ~/catalog_preview_overview-baseline.json -w /var/www/catalog_preview/overview-baseline.html
```

> **Note:** Save this first report! It acts as the starting metric which you will compare your progress against.
>
> For maximum awesomeness, automate the catalog preview run and the Report processor run in a cron job or via a webhook on your control repository!

# Start fixing issues

## 1. Start with the issue that is causing the most catalog compilation failures

 For example, in Puppet 3, the `=~` operator works if the left item is `undef`, in Puppet 4 it causes a compilation failure.

  ```puppet
  $foo = undef
  if $foo =~ 'bar' { do something } # This works in Puppet 3, but not Puppet 4.
  ```

## 2. Create a new branch from `future_production` that is named after the issue being fixed

```shell
git checkout future_production
git checkout -b issue123_undef_regex_match
```

## 3. Try to solve the problem

Hopefully this can be a simple fix such as switching to a different operator or doing a pre-check like:

```puppet
if $foo and ($foo =~ 'bar') {
  do something
}
```

Either way, attempt to solve the issue in this branch. Keep the work being done in this branch strictly to the issue at hand. As tempting as it may be to fix style and other issues, leave that for a future iteration. Keep your work atomic and clear.

## 4. Commit your fix

When you think you've found a fix for the issue, commit your work into the `issue123_undef_regex_match` branch.

Make your commit messages very clear and don't be afraid of being too verbose. A decent commit message for this example would be something like:

```
Fix regex operators to support Puppet 4

Prior to this, when using the =~ operator to compare strings in Puppet 3,
if the left operand was undef the operation would succeed with the expected
output. In Puppet 4, if the left operand is undef, a catalog compilation
failure occurs.

https://docs.puppet.com/puppet/latest/reference/lang_expressions.html#regex-or-data-type-match

See this catalog diff for an example of this affecting 70% of our nodes:
http://link.to.catalog.diff.for.issue123.html

This commit fixes the issue by attempting to make sure that the left operand
is never undef, and in cases where that can't be guaranteed, we add additional
logic to first check if the variable to be used has a value.
```

## 5. Test your fix

After committing to your issue branch, deploy it to the Puppet masters and run a new diff report against the `issue123_undef_regex_match` environment and the `production` environment.

It's helpful if you're able to limit your test run to just the nodes or a subset of the nodes that the issue was affecting. This speeds up the feedback loop of whether or not your fix worked.

- **If the issue is solved:**

    Save the catalog diff report.

- **If the issue is not solved:**

    Continue attempting to solve the issue by making additional commits to the `issue123_undef_regex_match` branch and re-deploying and running your tests again.

Repeat this process until the issue is solved.

Once the issue is solved, generate a catalog report that shows the issue is not present. Attach that report to your ticket that is tracking this issue.

## 6. Merge your fix into the `future_production` branch

The `future_production` branch should be the place in which all the finished fixes are stored. This means that when you solve an issue on a fix branch, you should merge it into the `future_production` branch. Use a mixture of squashing, rebasing, and merging to have a clean history from which you can create pull requests when it comes time to incorporate your changes into production.

### Squash your fix branch into a single commit

If it took you more than 1 commit to solve the issue, you should squash those multiple commits together so that the fix is packaged as a single atomic patch.

For example, if it took you 3 commits until you landed on the fix, you can squash those 3 commits down to one:

```
[control-repo]$ git checkout issue123_undef_regex_match
[control-repo]$ git log --graph --decorate --oneline

* 67b65bf (HEAD -> issue_123_undef_regex_match) third try
* 57f6a66 second try
* 77c176f first try
* 115b3f7 (production, future_production) Initial commit
```

Perform an interactive rebase of the last 3 commits. Use `fixup` for the commits you want to squash and `reword` on the top commit. This allows you to squash the commits together and re-write the commit message into a coherent message. If there were valuable comments in any of the commits being squashed, use the `squash` command rather than `fixup` as you'll be able to preserve the message.

```
[control-repo]$ git rebase -i HEAD~3
  reword 77c176f first try
  fixup 57f6a66 second try
  fixup 67b65bf third try

  # Rebase 115b3f7..67b65bf onto 115b3f7 (3 command(s)
  #
  # Commands:
  # p, pick = use commit
  # r, reword = use commit, but edit the commit message
  # e, edit = use commit, but stop for amending
  # s, squash = use commit, but meld into previous commit
  # f, fixup = like "squash", but discard this commit's log message
  # x, exec = run command (the rest of the line) using shell
  # d, drop = remove commit
```

### Avoid merge commits

Use rebase and merge so that when you merge your fix branch into `future_production` there are no merge commits. There will be no merge commits because your clean git history will permit a fast-forward.

```
[control-repo]$ git checkout issue123_undef_regex_match
[control-repo]$ git rebase future_production
[control-repo]$ git checkout future_production
[control-repo]$ git merge issue123_undef_regex_match
```

## 7. Repeat for the rest of the issues

Take the next issue in the hit list and solve it by repeating the process. Create a tracking ticket, create a topic branch, run tests, merge into the future_production branch.

# Merging fixes into production

Decide when and how to promote solved issues from the `future_production` to the `production` environment. There are two ways that this could go:

## Cherry-pick individual fixes and make a PR

It is safer to merge in changes one fix at a time. To do this, you'll need to create a new branch from production and cherry-pick in the commit from your topic branch that fixed the issue.

```
[control-repo]$ git checkout production
[control-repo]# git pull origin production
[control-repo]$ git checkout -b "solve_issue_123"
[control-repo]$ git cherry-pick issue123_undef_regex_match
# Amend the commit message if necessary
[control-repo]$ git commit --amend
[control-repo]$ git push origin solve_issue_123
# Create a pull request from `solve_issue_123` into `production`
```

This method involves more work as a PR needs to be made and additional branches also need to be made, but this is the cleanest method and the easiest to revert should something go wrong.

## Create a PR from `future_production` into `production`

This method is faster, but there are more places where merge conflicts could pop up. If using this method, it is very important to have keep `future_production` up to date with `production` by frequently rebasing (maybe at the start of each day):

```
[control-repo]$ git checkout future_production
[control-repo]$ git fetch --all
[control-repo]$ git rebase origin/production
```

From this point, you can push `future_production` to `origin` and create a PR that merges the entire branch into `production`.

```
[control-repo]$ git checkout future_production
[control-repo]$ git push origin future_production
# Create a pull request from `future_production` into `production`
```

# Example issues and their fixes

The catalog preview module maintains [a list of common breaking changes](https://github.com/puppetlabs/puppetlabs-catalog_preview#migration-warnings) that you should be aware of when moving from Puppet 3 to Puppet 4.

You should also run through the checklist on [updating 3.x manifests for 4.x](./updating_manifests.html).

For some real-word examples of common types of issues you may encounter, and examples for how to fix them, refer to the following sections.

## Example: Unquoted file modes (MIGRATE4_AMBIGUOUS_NUMBER)

File modes need to go in quotes in Puppet 4. If you do a `puppet-lint` run with the `--fix` option, it automatically updates these for you.

## Example: File "source" of a single-item array

You can give the File resource an array for "source" and it uses whichever one it finds first. Sites that use this trick extensively will sometimes just always use an array, even if it's a single-item array. The migration tools kick out a warning that can be ignored. (Use the `--excludes` option detailed above.)

````puppet
file { '/etc/flarghies.conf':
  ensure => file,
  source => [ 'puppet:///modules/smoorghies/flarghies.conf' ],
}
````

## Example: Regular expressions against numbers

Sometimes existing code does a regular expression match against a number, for instance, to see if the os release begins with a particular digit, or a package is of at least some version. Trying to do a match against a number breaks in Puppet 4.

This makes catalog compilation fail entirely.

Switch to using Puppet's built-in versioncmp function, which is also more flexible than a regexp. For OS checks, you might also try a more specific fact, such as $operatingsystemmajrelease, which just shows the first digit.

## Example: Empty strings are not false (MIGRATE4_EMPTY_STRING_TRUE)

Empty strings used to evaluate to false, and now they don't. If you can't change what's returning the empty string to return a real boolean, you can just wrap the string in `str2bool()` from `puppetlabs-stdlib` and it'll return false on an empty string.

## Example: Variables must start with lower case letter

Puppet 4 thinks a capital letter refers to a constant. Lowercase it.

Uppercased variable names make catalog compilation fail entirely.

## Example: Ineffectual conditional cases

A conditional that would do nothing is no longer allowed, unless it's the last case in a case statement. (Makes sense, plenty of empty default cases out there.) This creeps into code when someone has commented out some things in a conditional while debugging.

Note that declaring an anchor resource counts as a conditional having an effect -- so at worst you can just throw one inside the conditional block so that it "does something" but nothing of consequence.

````puppet
if ( $starfish == 'marine' ) {
  notify { 'You are a star fish.': }
}
elsif ( $cucumber == 'sea' ) {
  # DEBUG commenting out for now.
  # file { '/etc/invertebrate':
  #   ensure => file,
  #   content => 'true',
  #  }
}
else {
  service { 'refrigerator':
    ensure => running,
  }
}
````

## Example: Class names can't have hyphens

In Puppet 2.7, the acceptability of hyphenated class names changed a few times. The root problem is that hyphens are not distinguishable from arithmetic subtraction operations in Puppet's syntax. Throughout the 3.x series, class names with hyphens were deprecated but not completely removed. Now they are completely illegal since arithmetical expressions can appear in more places.

This makes catalog compilation fail entirely.

## Example: Import no longer works

Usually this is an old-school site.pp that does something like `import nodes/*.pp`. You don't fix this in code, but instead use the `manifestdir` setting in puppet.conf to import a whole directory and all subdirectories.

This makes catalog compilation fail entirely.
