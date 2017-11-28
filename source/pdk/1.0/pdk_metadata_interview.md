---
layout: default
title: "Navigating the metadata interview within the Puppet Development Kit"
canonical: "/pdk/1.0/pdk_get_started.html"
description: "How to sucessfully navigate the interview to create a valid metadata.json for your module."
---

[metadata]: {{puppet}}/modules_metadata.html

{:.concept}
## Metadata Interview

To create module metadata, PDK asks you a series of questions. Each question has a default response that PDK uses if you skip the question. The answers you provide to these questions are stored and used as the new defaults for subsequent module creations or conversions. PDK also adds a default set of supported operating systems to your metadata, which you can manually edit after module creation. For details about editing `metadata.json`, see the related topic about module metadata.

Optionally, you can skip the interview step and use the default answers for all metadata.

When you run the `pdk new module` or `pdk convert` command, the tool may request the following information:

* If your module does not have a name associated with it you will be prompted to provide one.
* Your Puppet Forge user name. If you don't have a Forge account, you can accept the default value for this question. If you create a Forge account later, edit the module metadata manually with the correct value. 
* Module version. We use and recommend semantic versioning for modules.
* Your name.
* The license under which your module is made available, an identifier from [SPDX License List](https://spdx.org/licenses/).
* A list of operating systems your module supports.
* A one-sentence summary about your module.
* The URL to your module's source code repository, so that other users can contribute back to your module.
* The URL to a web site that offers full information about your module, if you have one.
* The URL to the public bug tracker for your module, if you have one.


Related topics:
* [Module metadata][metadata]