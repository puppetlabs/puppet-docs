---
layout: default
title: "PE 1.2 Manual: Puppet Compliance Workflow Tutorial"
canonical: "/pe/latest/compliance_alt.html"
---

{% include pe_1.2_nav.markdown %}

Compliance Workflow Tutorial
--------

This brief walkthrough shows a compliance workflow auditing the state of the following resources:

* `File['/etc/profile']`
* `File['/etc/syslog.conf']`
* `Service['crond']`
* `Service['sshd']`
* `User['nick']`

Morning, July 14, 2011
-----

![tutorial_overview][]

On Thursday morning, the admin notices unreviewed changes in a group of three nodes and a pair of ungrouped nodes. She checks the group first. 

![tutorial_group][]

There, she notices that a user was completely deleted from all three nodes, and something odd happened with a file. She immediately rejects the deletion of the user...

![tutorial_reject_user][]

...and manually SSHes to the affected nodes to re-instate the account. 

![tutorial_group_reject_user_nodes_link][]

![tutorial_group_reject_user_nodes][]

    [root@hawk1.example.com ~]# puppet resource group nick ensure=present gid=506
    [root@hawk1.example.com ~]# puppet resource user nick ensure=present uid=506 gid=506
    ...

Then she takes a look at the file. It looks like two nodes had the ctime and mtime of the `/etc/profile` file changed, but no edits were made. This was probably nothing, but it piques her interest and she'll ask around about it later; in the meantime, she approves the change, since there's no functional difference. The other node, however, had its content changed. She drills down into the node view and checks the contents before and after:

![tutorial_profile_before][]

![tutorial_profile_after][]

That's not OK. It looks like someone was trying to resolve a DNS problem or something, but that's definitely not how she wants this machine configured. She rejects and manually reverts, and makes a note to find out what the problem they were trying to fix was. 

Next, the admin moves on to the individual nodes. 

![tutorial_osprey][]

On the osprey server, something has stopped crond, which is definitely not good, and someone has made an edit to `/etc/syslog.conf`. She rejects the cron stoppage and restarts it, then checks the diff on the syslog config: 

    7c7
    < *.info;mail.none;authpriv.none;cron.none      /var/log/messages
    ---
    > *.info;mail.none;authpriv.none;cron.none      /etc/apache2/httpd.conf

That looks actively malicious. She rejects and reverts, then moves on to the eagle server to check on a hunch.

![tutorial_eagle][]

![tutorial_eagle_diff][]

Yup: same dangerous change. She rejects and reverts, then spends the rest of her day figuring out how the servers got vandalized.

Morning, July 15, 2011
-----

The next day, the admin's previous fixes to the syslog.conf and profile files on the various servers have caused changes to the ctime and mtime of those files. She approves her own changes, then decides that she should probably edit her manifests so that all but a select handful of file resources use `audit => [ensure, content, owner, group, mode, type]` instead of `audit => all`, in order to suppress otherwise meaningless audit events.

It's an otherwise uneventful day.

[tutorial_eagle_diff]: ./images/baseline/tutorial_eagle_diff.png
[tutorial_eagle]: ./images/baseline/tutorial_eagle.png
[tutorial_group_reject_user_nodes_link]: ./images/baseline/tutorial_group_reject_user_nodes_link.png
[tutorial_group_reject_user_nodes]: ./images/baseline/tutorial_group_reject_user_nodes.png
[tutorial_group]: ./images/baseline/tutorial_group.png
[tutorial_osprey]: ./images/baseline/tutorial_osprey.png
[tutorial_profile_after]: ./images/baseline/tutorial_profile_after.png
[tutorial_profile_before]: ./images/baseline/tutorial_profile_before.png
[tutorial_reject_user]: ./images/baseline/tutorial_reject_user.png
[tutorial_overview]: ./images/baseline/tutorial_overview.png

