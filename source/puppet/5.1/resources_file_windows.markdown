---
layout: default
title: "Resource tips and examples: File on Windows"
---

[file]: ./type.html#file
[relationships]: /puppet/latest/lang_relationships.html
[acl_module]: https://forge.puppetlabs.com/puppetlabs/acl
[mode]: ./type.html#file-attribute-mode

Puppet's built-in [`file`][file] resource type can manage files and directories on Windows, including ownership, group, permissions, and content. Symbolic links are supported in Puppet 3.4.0 / PE 3.2 and later on Windows 2008 / Vista and later; for details, [see the notes in the resource type reference under `file`'s `ensure` attribute](./type.html#file-attribute-ensure).


``` puppet
file { 'c:/mysql/my.ini':
  ensure => 'file',
  mode   => '0660',
  owner  => 'mysql',
  group  => 'Administrators',
  source => 'N:/software/mysql/my.ini',
}
```

Here's what you'll want to know before using the `file` resource type.

## Take care with backslashes in paths

The issue of backslashes and forward-slashes in file paths can get complicated. It's covered in full detail in [Handling File Paths on Windows.][win_paths]

[win_paths]: ./lang_windows_file_paths.html

## Running 32-bit Puppet on 64-bit Windows is now deprecated

As of December 31, 2016, running 32-bit Puppet on 64-bit Windows is deprecated. Update your Puppet installation to match the architecture of your operating system.

## Be consistent with case in file names

If you need to refer to a file resource in multiple places in a manifest (e.g. when creating [relationships between resources][relationships]), be consistent with the case of the file name. If you use `my.ini` in one place, don't use `MY.INI` in another place.

Windows NTFS filesystems are case-insensitive (albeit case-preserving); Puppet is case-sensitive. While Windows itself won't get confused by inconsistent case, Puppet will think you're referring to completely different files.

## Make sure Puppet's user account has appropriate permissions

To manage files properly, Puppet needs the "Create symbolic links" (Vista/2008 and up), "Back up files and directories," and "Restore files and directories" privileges. The easiest way to handle this is:

* When Puppet runs as a service, make sure its user account is a member of the local `Administrators` group.  When you use the [`PUPPET_AGENT_ACCOUNT_USER` parameter](./install_windows.html#puppetagentaccountuser) with the MSI installer, the user will automatically be added to the administrators group.
* Before running Puppet interactively (on Vista/2008 and up), be sure to start the command prompt window with elevated privileges by right-clicking on the start menu and choosing "Run as Administrator."

## Managing file permissions

The \*nix and Windows permission models are quite different. When you use [the `mode` attribute,][mode] the `file` type manages them both like \*nix permissions, and translates the mode to roughly equivalent access controls on Windows. This makes basic controls fairly simple, but doesn't work for managing really complex access rules.

### Consider using the ACL resource type instead

The `mode` attribute is a somewhat blunt instrument on Windows. If you need truly Windows-like access controls, you should install:

* [The puppetlabs/acl module][acl_module]

This module provides an optional `acl` resource type that manages permissions in a Windows-centric way. If you need to do anything complicated, leave `mode` unspecified and add an `acl` resource. See [the acl module's documentation][acl_module] for more details.

### How \*nix modes map to Windows permissions

\*nix permissions are expressed as either a quoted octal number, e.g. "755", or a string of symbolic modes, e.g. "u=rwx,g=rx,o=rx". See [the reference for the `file` type's `mode` attribute](./type.html#file-attribute-mode) for more details about the syntax.

These mode expressions generally manage three kinds of permission (read, write, execute) for three kinds of user (owner, group, other). They translate to Windows permissions as follows:

* The read, write, and execute permissions are interpreted as the `FILE_GENERIC_READ`, `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights, respectively.
* The `Everyone` SID is used to represent users other than the owner and group.
* Directories on Windows can have the sticky bit, which makes it so users can only delete files if they own the containing directory.
* The owner of a file can be a group (e.g. `owner => 'Administrators'`) and the group of a file can be a user (e.g. `group => 'Administrator'`).
    * The owner and group can even be the same, but don't do that. (It can cause problems when the mode gives different permissions to the owner and group, e.g. `0750`.)
* The group can't have higher permissions than the owner. Other users can't have higher permissions than the owner or group. (That is, 0640 and 0755 are supported, but 0460 is not.)

### Extra behavior when managing permissions

When you manage permissions with the `mode` attribute, it has the following side effects:

* The owner of a file/directory always has the `FULL_CONTROL` access right.
* The security descriptor is always set to _protected._ This prevents the file from inheriting any more permissive access controls from the directory that contains it.

## File sources

The `source` attribute of a file can be a Puppet URL, a local path, a UNC path, or a path to a file on a mapped drive.

## Handling line endings

Windows usually uses CRLF line endings instead of \*nix's LF line endings. In most cases, Puppet **will not** automatically convert line endings when managing files on Windows.

* If a file resource uses the `content` or `source` attributes, Puppet will write the file in "binary" mode, using whatever line endings are present in the content.
    * If the manifest, template, or source file is saved with CRLF line endings, Puppet will use those endings in the destination file.
* Non-`file` resource types that make partial edits to a system file (most notably the [`host`](./type.html#host) resource type, which manages the `%windir%\system32\drivers\etc\hosts` file) manage their files in text mode, and will automatically translate between Windows and \*nix line endings.

    > Note: When writing your own resource types, you can get this same behavior by using the `flat` filetype.


## Errata

### Known issues prior to Puppet 4.0

* Prior to Puppet 4.0, Puppet will copy file permissions from the remote `source`. See below for more details. In Puppet 4.0, Puppet will not copy file permissions. The previous behavior can be enabled by specifying `source_permissions` as `use`.