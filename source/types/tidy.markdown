tidy

Remove unwanted files based on specific criteria. Multiple criteria
are OR'd together, so a file that is too large but is not old
enough will still get tidied.

If you don't specify either 'age' or 'size', then all files will be
removed.

This resource type works by generating a file resource for every
file that should be deleted and then letting that resource perform
the actual deletion.

### Parameters

#### age

Tidy files whose age is equal to or greater than the specified
time. You can choose seconds, minutes, hours, days, or weeks by
specifying the first letter of any of those words (e.g., '1w').

Specifying 0 will remove all files.

#### backup

Whether tidied files should be backed up. Any values are passed
directly to the file resources used for actual file deletion, so
use its backup documentation to determine valid values.

#### matches

One or more (shell type) file glob patterns, which restrict the
list of files to be tidied to those whose basenames match at least
one of the patterns specified. Multiple patterns can be specified
using an array.

Example:

    tidy { "/tmp":
        age => "1w",
        recurse => false,
        matches => [ "[0-9]pub*.tmp", "*.temp", "tmpfile?" ]
    }

This removes files from /tmp if they are one week old or older, are
not in a subdirectory and match one of the shell globs given.

Note that the patterns are matched against the basename of each
file -- that is, your glob patterns should not have any '/'
characters in them, since you are only specifying against the last
bit of the file.

#### path

-   **namevar**

The path to the file or directory to manage. Must be fully
qualified.

#### recurse

If target is a directory, recursively descend into the directory
looking for files to tidy. Valid values are `true`, `false`, `inf`.
Values can match `/^[0-9]+$/`.

#### rmdirs

Tidy directories in addition to files; that is, remove directories
whose age is older than the specified criteria. This will only
remove empty directories, so all contained files must also be
tidied before a directory gets removed. Valid values are `true`,
`false`.

#### size

Tidy files whose size is equal to or greater than the specified
size. Unqualified values are in kilobytes, but *b*, *k*, and *m*
can be appended to specify *bytes*, *kilobytes*, and *megabytes*,
respectively. Only the first character is significant, so the full
word can also be used.

#### type

Set the mechanism for determining age. Valid values are `atime`,
`mtime`, `ctime`.


* * * * *

