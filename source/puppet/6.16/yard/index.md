---
layout: default
title: "Generating Ruby API docs for developing extensions"
---

For documentation on Puppet's Ruby APIs for developing low-level extensions to Puppet, you can generate your own local copy of Puppet's YARD (Yay! A Ruby Documentation) content. Generating these docs ensures that you always have the correct, relevant Ruby API docs for your version of Puppet.

## Before you begin

To generate YARD content, you need:

-   Command-line access to your workstation
-   Git
-   Ruby (tested on Ruby 2.3 and later)

## Generating YARD content

To generate YARD content, you must have a local copy of the Puppet code repository and the Ruby `bundler` gem. If you're already developing Puppet extensions in Ruby, you might have already performed some of these steps, and it's safe to skip any that you've already completed.

1.  Clone the Puppet code repository to your local workstation using git.

    ```
    git clone https://github.com/puppetlabs/puppet
    ```

    This creates a directory named "puppet" in your current working directory.
2.  Enter the directory.

    ```
    cd puppet
    ```
3.  Install the `bundler` gem if it isn't already installed.

    ```
    gem install bundler
    ```
4.  Have `bundler` install this project's prerequisites.

    ```
    bundle install
    ```

    If you want to only generate YARD content and aren't interested in developing Ruby extensions using this copy of the Puppet code, you can speed up this process by adding the `--without development extra` option:

    ```
    bundle install --without development extra
    ```
5.  Run the YARD tool, which should have been installed by `bundler` automatically.

    ```
    yard doc
    ```

    The YARD tool will generate the content into a new `doc` folder inside your current working directory. The `doc` directory is already in the Puppet repository's `.gitignore` file, so they should not be exposed to git's workspace if you generate them inside of the repository. To generate the docs to a specific directory, use the `--output-dir <PATH>` option.
    
    YARD generates many warning messages. To silence these messages, run `yard doc` with the `-q` (quiet) option.

6.  Open the generated HTML in your workstation's web browser. The `_index.html` file is an alphabetical index, and `index.html` is the YARD-rendered output of the Puppet repo's README file. Both are good starting points for navigating the YARD content.
