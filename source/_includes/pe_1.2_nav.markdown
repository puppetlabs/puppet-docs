{% comment %}

#### Navigation

- [Introduction](./intro.html)
- [Overview](./overview.html)
- [Installing](./installing.html)
- [Upgrading](./upgrading.html)
- [Using Puppet Enterprise](./using.html)
- The Accounts Module
    - [The `accounts::user` Type](./accounts_user_type.html)
    - [The `accounts` Class](./accounts_class.html)
- Puppet Compliance
    - [Puppet Compliance Basics and UI](./compliance_basics.html)
    - [Using the Puppet Compliance Workflow](./using_compliance.html)
    - [Compliance Workflow Tutorial](./compliance_tutorial.html)
- [Known Issues](./known_issues.html)
- [Troubleshooting](./troubleshooting.html)
- [Answer File Reference](./answer_file_reference.html)

Menus with conditional links have to be statically generated with a plain old regex find+replace before you generate the site. This only needs to be re-done if you're changing the text of the menu. 

MARKDOWN VERSION:
find:
^(\s*- )(\[([^\]]+)\]\(\./([\w_]+\.html)\))

replace:
\1{% if page.url contains '\4' %}**\3**{% else %}\2{% endif %}

HTML VERSION:
find:
(?<=^<li>)(<a href="\./([\w_]+\.html)">(.+?)</a>)(?=</li>)

replace:
{% if page.url contains '\2' %}<strong>\3</strong>{% else %}\1{% endif %}

{% endcomment %}

{% include warnings/old_pe_version.html %}

#### Navigation

- {% if page.url contains 'intro.html' %}**Introduction**{% else %}[Introduction](./intro.html){% endif %}
- {% if page.url contains 'overview.html' %}**Overview**{% else %}[Overview](./overview.html){% endif %}
- {% if page.url contains 'installing.html' %}**Installing**{% else %}[Installing](./installing.html){% endif %}
- {% if page.url contains 'upgrading.html' %}**Upgrading**{% else %}[Upgrading](./upgrading.html){% endif %}
- {% if page.url contains 'using.html' %}**Using Puppet Enterprise**{% else %}[Using Puppet Enterprise](./using.html){% endif %}
- The Accounts Module
    - {% if page.url contains 'accounts_user_type.html' %}**The `accounts::user` Type**{% else %}[The `accounts::user` Type](./accounts_user_type.html){% endif %}
    - {% if page.url contains 'accounts_class.html' %}**The `accounts` Class**{% else %}[The `accounts` Class](./accounts_class.html){% endif %}
- Puppet Compliance
    - {% if page.url contains 'compliance_basics.html' %}**Puppet Compliance Basics and UI**{% else %}[Puppet Compliance Basics and UI](./compliance_basics.html){% endif %}
    - {% if page.url contains 'using_compliance.html' %}**Using the Puppet Compliance Workflow**{% else %}[Using the Puppet Compliance Workflow](./using_compliance.html){% endif %}
    - {% if page.url contains 'compliance_tutorial.html' %}**Compliance Workflow Tutorial**{% else %}[Compliance Workflow Tutorial](./compliance_tutorial.html){% endif %}
- {% if page.url contains 'known_issues.html' %}**Known Issues**{% else %}[Known Issues](./known_issues.html){% endif %}
- {% if page.url contains 'troubleshooting.html' %}**Troubleshooting**{% else %}[Troubleshooting](./troubleshooting.html){% endif %}
- {% if page.url contains 'answer_file_reference.html' %}**Answer File Reference**{% else %}[Answer File Reference](./answer_file_reference.html){% endif %}

