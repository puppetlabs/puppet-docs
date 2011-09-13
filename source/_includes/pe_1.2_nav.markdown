<!-- 
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

find:
(?<=^<li>)(<a href="\./([\w_]+\.html)">(.+?)</a>)(?=</li>)
replace:
{% if page.url contains '\2' %}<strong>\3</strong>{% else %}\1{% endif %}

Alternately, if we're keeping the output as markdown: 
find:
^(\s*- )(\[([^\]]+)\]\(\./([\w_]+\.html)\))
replace:
\1{% if page.url contains '\4' %}**\3**{% else %}\2{% endif %}
 -->


<h4>Navigation</h4>

<ul>
<li>{% if page.url contains 'intro.html' %}<strong>Introduction</strong>{% else %}<a href="./intro.html">Introduction</a>{% endif %}</li>
<li>{% if page.url contains 'overview.html' %}<strong>Overview</strong>{% else %}<a href="./overview.html">Overview</a>{% endif %}</li>
<li>{% if page.url contains 'installing.html' %}<strong>Installing</strong>{% else %}<a href="./installing.html">Installing</a>{% endif %}</li>
<li>{% if page.url contains 'upgrading.html' %}<strong>Upgrading</strong>{% else %}<a href="./upgrading.html">Upgrading</a>{% endif %}</li>
<li>{% if page.url contains 'using.html' %}<strong>Using Puppet Enterprise</strong>{% else %}<a href="./using.html">Using Puppet Enterprise</a>{% endif %}</li>
<li>The Accounts Module
<ul>
<li>{% if page.url contains 'accounts_user_type.html' %}<strong>The <code>accounts::user</code> Type</strong>{% else %}<a href="./accounts_user_type.html">The <code>accounts::user</code> Type</a>{% endif %}</li>
<li>{% if page.url contains 'accounts_class.html' %}<strong>The <code>accounts</code> Class</strong>{% else %}<a href="./accounts_class.html">The <code>accounts</code> Class</a>{% endif %}
</li>
</ul></li>
<li>Puppet Compliance
<ul>
<li>{% if page.url contains 'compliance_basics.html' %}<strong>Puppet Compliance Basics and UI</strong>{% else %}<a href="./compliance_basics.html">Puppet Compliance Basics and UI</a>{% endif %}</li>
<li>{% if page.url contains 'using_compliance.html' %}<strong>Using the Puppet Compliance Workflow</strong>{% else %}<a href="./using_compliance.html">Using the Puppet Compliance Workflow</a>{% endif %}</li>
<li>{% if page.url contains 'compliance_tutorial.html' %}<strong>Compliance Workflow Tutorial</strong>{% else %}<a href="./compliance_tutorial.html">Compliance Workflow Tutorial</a>{% endif %}</li>
</ul></li>
<li>{% if page.url contains 'known_issues.html' %}<strong>Known Issues</strong>{% else %}<a href="./known_issues.html">Known Issues</a>{% endif %}</li>
<li>{% if page.url contains 'troubleshooting.html' %}<strong>Troubleshooting</strong>{% else %}<a href="./troubleshooting.html">Troubleshooting</a>{% endif %}</li>
<li>{% if page.url contains 'answer_file_reference.html' %}<strong>Answer File Reference</strong>{% else %}<a href="./answer_file_reference.html">Answer File Reference</a>{% endif %}</li>
</ul>


