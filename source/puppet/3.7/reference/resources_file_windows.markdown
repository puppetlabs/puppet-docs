---
layout: default
title: "Resource Tips and Examples: File on Windows"
---

[file]: ./type.html#file
[relationships]: /puppet/latest/reference/lang_relationships.html
[acl_module]: https://forge.puppetlabs.com/puppetlabs/acl
[mode]: ./type.html#file-attribute-mode

Puppet's built-in [`file`][file] resource type can manage files and directories on Windows, including ownership, group, permissions, and content. Symbolic links are supported in Puppet 3.4.0 / PE 3.2 and later on Windows 2008 / Vista and later; for details, [see the notes in the resource type reference under `file`'s `ensure` attribute](./type.html#file-attribute-ensure).


~~~ ruby
    file { 'c:/mysql/my.ini':
      ensure => 'file',
      mode   => '0660',
      owner  => 'mysql',
      group  => 'Administrators',
      source => 'N:/software/mysql/my.ini',
    }
~~~

The `file` resource type was originally developed for \*nix systems, and has a few unusual behaviors on Windows. Here's what you'll want to know before using it.

## Take Care With Backslashes in Paths

The issue of backslashes and forward-slashes in file paths can get complicated. It's covered in full detail in [Handling File Paths on Windows.][win_paths]

[win_paths]: ./lang_windows_file_paths.html

## Watch for Filesystem Redirection When Running 32-Bit Puppet on 64-Bit Windows

As of Puppet 3.7, Puppet can run as either a 32- or a 64-bit process. As long as you have installed an architecture-appropriate Puppet package, file system redirection is not an issue for you.

However, if you're using Windows Server 2003, have purposely installed a 32-bit package on a 64-bit version of Windows, or are writing code that must support older versions of Puppet, you will be affected by the Windows File System Redirector. This issue is covered in full detail in [Handling File Paths on Windows.][win_paths]

## Be Consistent With Case in File Names

If you need to refer to a file resource in multiple places in a manifest (e.g. when creating [relationships between resources][relationships]), be consistent with the case of the file name. If you use `my.ini` in one place, don't use `MY.INI` in another place.

Windows NTFS filesystems are case-insensitive (albeit case-preserving); Puppet is case-sensitive. While Windows itself won't get confused by inconsistent case, Puppet will think you're referring to completely different files.

## Make Sure Puppet's User Account Has Appropriate Permissions



To manage files properly, Puppet needs the "Create symbolic links" (Vista/2008 and up), "Back up files and directories," and "Restore files and directories" privileges. The easiest way to handle this is:

* When Puppet runs as a service, make sure its user account is a member of the local `Administrators` group.
* Before running Puppet interactively (on Vista/2008 and up), be sure to start the command prompt window with elevated privileges by right-clicking on the start menu and choosing "Run as Administrator."

## Always Block Source Permissions on Windows

If you set [the `source` attribute](./type.html#file-attribute-source), Puppet defaults to applying the ownership and permissions that the source files have on the Puppet master server.

This is **almost never what you want** when managing files on Windows, and the default behavior is now deprecated, scheduled for change in a future version of Puppet.

In the meantime, you can change or disable this behavior with [the `file` type's `source_permissions` attribute](./type.html#file-attribute-source_permissions); for Windows systems, you will usually want to set it to `ignore` with a resource default in site.pp:

~~~ ruby
    if $osfamily == 'windows' {
      File { source_permissions => ignore }
    }
~~~

## Managing File Permissions

The \*nix and Windows permission models are quite different. When you use [the `mode` attribute,][mode] the `file` type manages them both like \*nix permissions, and translates the mode to roughly equivalent access controls on Windows. This makes basic controls fairly simple, but doesn't work for managing really complex access rules.

### Consider Using the ACL Resource Type Instead

The `mode` attribute is a somewhat blunt instrument on Windows. If you need truly Windows-like access controls, you should install:

* [The puppetlabs/acl module][acl_module]

This module provides an optional `acl` resource type that manages permissions in a Windows-centric way. If you need to do anything complicated, leave `mode` unspecified and add an `acl` resource. See [the acl module's documentation][acl_module] for more details.

### How \*nix Modes Map to Windows Permissions

\*nix permissions are expressed as either an octal number or a string of symbolic modes. See [the reference for the `file` type's `mode` attribute](./type.html#file-attribute-mode) for more details about the syntax.

These mode expressions generally manage three kinds of permission (read, write, execute) for three kinds of user (owner, group, other). They translate to Windows permissions as follows:

* The read, write, and execute permissions are interpreted as the `FILE_GENERIC_READ`, `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights, respectively.
* The `Everyone` SID is used to represent users other than the owner and group.
* Directories on Windows can have the sticky bit, which makes it so users can only delete files if they own the containing directory.
* The owner of a file can be a group (e.g. `owner => 'Administrators'`) and the group of a file can be a user (e.g. `group => 'Administrator'`).
    * The owner and group can even be the same, but don't do that. (It can cause problems when the mode gives different permissions to the owner and group, e.g. `0750`.)
* The group can't have higher permissions than the owner. Other users can't have higher permissions than the owner or group. (That is, 0640 and 0755 are supported, but 0460 is not.)

### Extra Behavior When Managing Permissions

When you manage permissions with the `mode` attribute, it has the following side effects:

* The owner of a file/directory always has the `FULL_CONTROL` access right.
* The security descriptor is always set to _protected._ This prevents the file from inheriting any more permissive access controls from the directory that contains it.

## File Sources

The `source` attribute of a file can be a Puppet URL, a local path, or a path to a file on a mapped drive.

## Handling Line Endings

Windows usually uses CRLF line endings instead of \*nix's LF line endings. In most cases, Puppet **will not** automatically convert line endings when managing files on Windows.

* If a file resource uses the `content` or `source` attributes, Puppet will write the file in "binary" mode, using whatever line endings are present in the content.
    * If the manifest, template, or source file is saved with CRLF line endings, Puppet will use those endings in the destination file.
    * If the manifest, template, or source file is saved with LF line endings, you can use the `\r\n` escape sequence to create literal CRLFs.
* Non-`file` resource types that make partial edits to a system file (most notably the [`host`](./type.html#host) resource type, which manages the `%windir%\system32\drivers\etc\hosts` file) manage their files in text mode, and will automatically translate between Windows and \*nix line endings.

    > Note: When writing your own resource types, you can get this same behavior by using the `flat` filetype.


## Errata

### Known Issues Prior to Puppet 3.4 / PE 3.2

Prior to Puppet 3.4 / Puppet Enterprise 3.2, the `file` resource type had several limitations and problems. These were fixed as part of an NTFS support cleanup in 3.4.0. If you are writing manifests for Windows machines running an older version of Puppet, please be aware:

* If an `owner` or `group` are specified for a file, **you must also specify a `mode`.** Failing to do so can render a file inaccessible to Puppet. [See here for more details](./troubleshooting.html#file-pre-340).
* Setting a permissions mode can prevent the SYSTEM user from accessing the file (if SYSTEM isn't the file's owner or part of its group). This can make it so Puppet can access the file when run by a user, but can't access it when run as a service. In 3.4 and later, this is fixed, and Puppet will always ensure the SYSTEM user has the `FULL_CONTROL` access right (unless SYSTEM is specified as the owner or group for that file, in which case it will have the rights specified by the permissions mode).
* Puppet will copy file permissions from the remote `source`; this isn't ideal, since the \*nix permissions on the Puppet master are unlikely to match what you want on your Windows machines. The only way to prevent this is to specify ownership, group, and mode for every file (or with a resource default). In 3.4 and up, the `source_permissions` attribute provides a way to turn this behavior off.
