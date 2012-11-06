#!/usr/bin/env perl -n

# NF: My hacky {% iflink %} tags are hard to read, so I like to put together nav snippets as something like this inside a {% comment %} block:

# ## Hiera 1
# 
# - `"Overview", "./index.html"`
# - `"Complete Example", "./complete_example.html"`
# - `"Installation", "./installing.html"`
# - `"Configuration and hiera.yaml", "./configuring.html"`
# - `"Hierarchies", "./hierarchy.html"`
# - `"Writing Data Sources", "./data_sources.html"`
# - `"Variables and Interpolation", "./variables.html"`
# - `"Usage with Puppet", "./puppet.html"`
# - `"Usage on the Command Line", "./command_line.html"`
# - `"Writing New Backends", "./custom_backends.html"`

# Then I convert it to HTML and replace the code spans using the script below. 

s/<code>/{% iflink /g;
s/<\/code>/ %}/g;
print;
