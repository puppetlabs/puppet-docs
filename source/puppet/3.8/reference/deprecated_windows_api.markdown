---
layout: default
title: "Breaking Changes to Private Windows APIs"
---


In Puppet 3.8, we re-arranged many of Puppet's private Windows-related APIs. These changes were a side effect of 64-bit support for Windows.

In some places, we were able to add deprecation warnings instead of making hard changes. In other cases, this was impractical and we had to make breaking changes.

These changes shouldn't affect most users, but they **may affect Ruby plugins for Windows that call native code.** If you maintain any Windows-specific resource types and providers, you should read through the changes and deprecations on this page and update your code to support Puppet 3.8 and 4.0.

All of these changes affected code that was not marked as a public API.

Breaking Changes
-----

### sys-admin Gem and `Admin` Class are Gone

Puppet used to vendor the sys-admin gem. It's been removed, so calls to the `Admin` class are no longer valid.

### Task Scheduler API Has Moved

We replaced the win32-taskscheduler gem with an internal FFI-compatible implementation of the Windows v1 COM taskscheduler API.

If you were using Puppet's interface to the win32-taskscheduler gem, the new implementation should be backwards-compatibile, but you'll need to change the require statement that loads that interface. The new API can be loaded with `require 'puppet/util/windows/taskscheduler'`.

### Updated Gems and Moved Constants

The win32-dir, win32-eventlog, win32-process, win32-security and win32-service gems have all been updated to newer FFI compatible versions.  In some cases, these gems have made API changes and have moved constants to new locations.  For constants, it's suggested to locally namespace them and define them in your own module where practical to do so.

### `Puppet::Util::ADSI` Has Moved

The ADSI class has moved from `Puppet::Util::ADSI` to `Puppet::Util::Windows::ADSI`. The new file location can be referenced with `require 'puppet/util/windows/adsi'`.

### `Windows::` Namespace Removed; Several Mixins No Longer Used

The windows-pr, windows-api and win32-api gems have all been removed. They all contained Win32 API definitions that were not x64 compatible.

This caused the following changes:

- Most classes that were included with a `require 'windows/xxxxx'` are no longer possible to include, but similar functionality should be maintained in classes within the `Puppet::Util::Windows` namespace.
- Constants within the `Windows::` namespace are no longer available.  Many of the same constants are available within the `Puppet::Util::Windows` namespaced classes that use them.
- `Puppet::Util::Windows::User` no longer mixes in the windows-pr class `Windows::Security`.
- `Puppet::Util::Windows::Error` no longer mixes in the windows-pr class `Windows::Error`.
- `Puppet::Util::Windows::Process` no longer mixes in the windows-pr class `Windows::Process`, `Windows::Handle` or `Windows::Synchronize`.
- `Puppet::Util::Windows::Security` no longer mixes in the windows-pr classes `Windows::File`, `Windows::Handle`, `Windows::Security`, `Windows::Process`, `Windows::Memory`, `Windows::MSVCRT::Buffer` or `Windows::Volume`.
- `Puppet::Util::Windows::SID` no longer mixes in the windows-pr classes `Windows::Security` or `Windows::Memory`.
- `Windows::Error` constants may have moved --- for instance, `ERROR_FILE_NOT_FOUND` is now found within `Puppet::Util::Windows::Error`.
- The `WideString` class no longer exists, but similar functionality is present in `Puppet::Util::Windows::String.wide_string` and through an extension we've made to FFI, as `FFI::Pointer.from_string_to_wide_string`.
- Generally, calls that show up as `API::` or `API.new` are no longer valid and should be replaced with equivalent FFI definitions.

### Win32API Class is Gone

Should you need to make Win32 API calls, always use FFI and never the Win32API class.

There are plenty of examples in the Puppet code to look at. Further, the code includes helpers around FFI usage, including dealing with properly freeing native memory that must have `LocalFree` or `CoTaskMemFree` used on it --- see <https://github.com/puppetlabs/puppet/blob/master/lib/puppet/util/windows/api_types.rb>.

FFI can be relied on as being a part of Puppet as far back as 3.3.0 (PE 3.1.0), though the helpers above are not.  Please take this into consideration if it's necessary to make native Win32 calls, and when expressing your module compatibility.


Deprecations
-----

### SID-related Methods Have Moved

The following methods have been moved from `Puppet::Util::Windows::Security` to `Puppet::Util::Windows::SID`:

* `name_to_sid`
* `name_to_sid_object`
* `octet_string_to_sid_object`
* `sid_to_name`
* `sid_ptr_to_string`
* `string_to_sid_ptr`
* `valid_sid?`

The old locations will still work for now, but will log deprecation warnings. The stubs will be removed in Puppet 4.0. ([Relevant section of code.](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/util/windows/security.rb#L669-L703))


### `Puppet::Util::Windows::File.get_file_attributes` Renamed to `get_attributes`

The `get_file_attributes` method of `Puppet::Util::Windows::File` has been renamed to `get_attributes`. You can use the old name, but it will log a deprecation warning. It will be removed in Puppet 4.0.

### Attributes Methods from `Puppet::Util::Windows::Security` Moved to `Puppet::Util::Windows::File`

The following methods of `Puppet::Util::Windows::Security` have been moved to the `Puppet::Util::Windows::File` module:

* `get_attributes`
* `add_attributes`
* `remove_attributes`
* `set_attributes`

The old locations will still work for now, but will log deprecation warnings. The stubs will be removed in Puppet 4.0. ([Relevant section of code.](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/util/windows/security.rb#L183-L201))

