This is a list of all of the built-in facts that ship with Facter, which includes both legacy facts and newer structured facts.

Not all of them apply to every system, and your site might also use [custom facts](./custom_facts.html) delivered via Puppet modules. To see the full list of structured facts and values on a given system (including plugin facts), run `puppet facts` at the command line. If you are using Puppet Enterprise, you can view all of the facts for any node on the node's page in the console.

You can access facts in your Puppet manifests as `$fact_name` or `$facts[fact_name]`. For more information, see [the Puppet docs on facts and built-in variables.]({{puppet}}/lang_facts_and_builtin_vars.html)

> **Legacy Facts Note:** As of Facter 3, legacy facts such as `architecture` are hidden by default to reduce noise in Facter's default command-line output. These older facts are now part of more useful structured facts; for example, `architecture` is now part of the `os` fact and accessible as `os.architecture`. You can still use these legacy facts in Puppet manifests (`$architecture`), request them on the command line (`facter architecture`), and view them alongside structured facts (`facter --show-legacy`).

* * *

