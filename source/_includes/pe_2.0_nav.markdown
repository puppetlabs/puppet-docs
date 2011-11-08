{% comment %}
THE TEXT:

- **Welcome to Puppet Enterprise**
    - [Getting Started](./getting_started.html)
    - What Can Puppet Enterprise Do?
    - Components and Roles
    - What's New
    - Known Issues
    - Getting Help and Learning More
- **Installing Puppet Enterprise**
    - [System Requirements](./install_system_requirements.html)
    - [Preparing to Install](./install_preparing.html)
    - [Basic Installation](./install_basic.html)
    - [Upgrading](./install_upgrading.html)
    - Non-interactive Installation
    - Advanced Installation
    - [Answer File Reference](./install_answer_file_reference.html)
- **The Console**
    - Navigating the Console
    - Viewing Reports and Inventory Data
    - Grouping and Classifying Nodes
    - Live Management: Controlling Puppet
    - Live Management: Editing Resources
    - Live Management: Advanced Tasks
- **Puppet For New PE Users**
    - Overview <!-- How do I shot configuration to a node? -->
    - Creating Your First Module
    - Assigning a Module to an Agent Node
    - Next Steps
- **MCollective For New PE Users**
    - Overview
    - Using the MCollective Client
    - Managing MCollective with Puppet <!-- What's this entail now that we use PSK? -->
    - Next Steps
- **The Compliance Workflow**
    - [Puppet Compliance Basics and UI](./compliance_basics.html)
    - [Using the Puppet Compliance Workflow](./using_compliance.html)
    - [Compliance Workflow Tutorial](./compliance_tutorial.html)
- **The Accounts Module**
    - [The `accounts::user` Type](./accounts_user_type.html)
    - [The `accounts` Class](./accounts_class.html)
- **Maintenance and Troubleshooting**
    - Common Configuration Errors
    - Console Database Maintenance


---------------
To work in the layout sidebar, this has to be compiled HTML.

HTML VERSION:
\1 is the entire link construct
\2 is the URL of the page being linked
\3 is the name of the page being linked

FIND:

<li>(<a href="\./([\w_-]+\.html)">(.+?)</a>)(?=</li>)

REPLACE:

{% if page.url contains '\2' %}<li class="currentpage"><strong><em>\3:</em></strong>{{ content | toc }}{% else %}<li>\1{% endif %}

{% endcomment %}

<ul>
  <li><strong>Welcome to Puppet Enterprise</strong>
    <ul>
      {% if page.url contains 'getting_started.html' %}<li class="currentpage"><strong><em>Getting Started:</em></strong>{{ content | toc }}{% else %}<li><a href="./getting_started.html">Getting Started</a>{% endif %}</li>
      <li>What Can Puppet Enterprise Do?</li>
      <li>Components and Roles</li>
      <li>What&rsquo;s New</li>
      <li>Known Issues</li>
      <li>Getting Help and Learning More</li>
    </ul>
  </li>
  <li><strong>Installing Puppet Enterprise</strong>
    <ul>
      {% if page.url contains 'install_system_requirements.html' %}<li class="currentpage"><strong><em>System Requirements:</em></strong>{{ content | toc }}{% else %}<li><a href="./install_system_requirements.html">System Requirements</a>{% endif %}</li>
      {% if page.url contains 'install_preparing.html' %}<li class="currentpage"><strong><em>Preparing to Install:</em></strong>{{ content | toc }}{% else %}<li><a href="./install_preparing.html">Preparing to Install</a>{% endif %}</li>
      {% if page.url contains 'install_basic.html' %}<li class="currentpage"><strong><em>Basic Installation:</em></strong>{{ content | toc }}{% else %}<li><a href="./install_basic.html">Basic Installation</a>{% endif %}</li>
      {% if page.url contains 'install_upgrading.html' %}<li class="currentpage"><strong><em>Upgrading:</em></strong>{{ content | toc }}{% else %}<li><a href="./install_upgrading.html">Upgrading</a>{% endif %}</li>
      <li>Non-interactive Installation</li>
      <li>Advanced Installation</li>
      {% if page.url contains 'install_answer_file_reference.html' %}<li class="currentpage"><strong><em>Answer File Reference:</em></strong>{{ content | toc }}{% else %}<li><a href="./install_answer_file_reference.html">Answer File Reference</a>{% endif %}</li>
    </ul>
  </li>
  <li><strong>The Console</strong>
    <ul>
      <li>Navigating the Console</li>
      <li>Viewing Reports and Inventory Data</li>
      <li>Grouping and Classifying Nodes</li>
      <li>Live Management: Controlling Puppet</li>
      <li>Live Management: Editing Resources</li>
      <li>Live Management: Advanced Tasks</li>
    </ul>
  </li>
  <li><strong>Puppet For New PE Users</strong>
    <ul>
      <li>Overview <!-- How do I shot configuration to a node? --></li>
      <li>Creating Your First Module</li>
      <li>Assigning a Module to an Agent Node</li>
      <li>Next Steps</li>
    </ul>
  </li>
  <li><strong>MCollective For New PE Users</strong>
    <ul>
      <li>Overview</li>
      <li>Using the MCollective Client</li>
      <li>Managing MCollective with Puppet <!-- What's this entail now that we use PSK? --></li>
      <li>Next Steps</li>
    </ul>
  </li>
  <li><strong>The Compliance Workflow</strong>
    <ul>
      {% if page.url contains 'compliance_basics.html' %}<li class="currentpage"><strong><em>Puppet Compliance Basics and UI:</em></strong>{{ content | toc }}{% else %}<li><a href="./compliance_basics.html">Puppet Compliance Basics and UI</a>{% endif %}</li>
      {% if page.url contains 'using_compliance.html' %}<li class="currentpage"><strong><em>Using the Puppet Compliance Workflow:</em></strong>{{ content | toc }}{% else %}<li><a href="./using_compliance.html">Using the Puppet Compliance Workflow</a>{% endif %}</li>
      {% if page.url contains 'compliance_tutorial.html' %}<li class="currentpage"><strong><em>Compliance Workflow Tutorial:</em></strong>{{ content | toc }}{% else %}<li><a href="./compliance_tutorial.html">Compliance Workflow Tutorial</a>{% endif %}</li>
    </ul>
  </li>
  <li><strong>The Accounts Module</strong>
    <ul>
      {% if page.url contains 'accounts_user_type.html' %}<li class="currentpage"><strong><em>The <code>accounts::user</code> Type:</em></strong>{{ content | toc }}{% else %}<li><a href="./accounts_user_type.html">The <code>accounts::user</code> Type</a>{% endif %}</li>
      {% if page.url contains 'accounts_class.html' %}<li class="currentpage"><strong><em>The <code>accounts</code> Class:</em></strong>{{ content | toc }}{% else %}<li><a href="./accounts_class.html">The <code>accounts</code> Class</a>{% endif %}</li>
    </ul>
  </li>
  <li><strong>Maintenance and Troubleshooting</strong>
    <ul>
      <li>Common Configuration Errors</li>
      <li>Console Database Maintenance</li>
    </ul>
  </li>
</ul>
