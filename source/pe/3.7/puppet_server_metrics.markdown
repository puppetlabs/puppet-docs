---
layout: default
title: "PE 3.8 » Deploying PE » Puppet Server Metrics"
subtitle: "Graphing Puppet Server Metrics"
canonical: "/pe/latest/puppet_server_metrics.html"
---

In Puppet Enterprise, the Puppet server, running on the Puppet master, is capable of tracking advanced metrics to give you insight into the performance and health of the application.

### Getting Started with Graphite

If you don’t already have a  [Graphite](http://graphite.wikidot.com/) server and would like to try using a metrics dashboard, we have a Puppet module that can quickly set up a test Graphite instance.  It will also set up an instance of [Grafana](http://grafana.org/), which is a nice extension to Graphite that provides an alternate web UI for creating and displaying metrics dashboards.

Install this module on a dedicated PE agent node, not on the Puppet master server, as it makes security policy changes that should not be made on a Puppet master.

> **Note**: The module referenced in this doc is not a Puppet Labs supported module; it is for test purposes only. At the time of this writing, it only supports CentOS 6. It's important to note that Selinux can cause issues with graphite/grafana, so the module temporarily disables Selinux.  If you reboot the machine after using the module to install graphite, you may need to disable Selinux again and restart the Apache service.
>
>The module also disables `iptables` and enables `CORS` on Apache.

**To install the Grafana dashboard module**:

1. [Install a *nix PE agent](./install_agents.html) to serve as the graphite server.

1. On the Puppet agent node, run `puppet module install cprice404-grafanadash`.
2. On the Puppet agent node, run `puppet apply -e 'include grafanadash::dev'`.

**To run Grafana**:

1. In a web browser on a computer that can reach the Puppet agent node, navigate to `http://<AGENT’S HOSTNAME>:10000`.

   There, you'll see a test screen that indicates whether Grafana can successfully connect to your graphite server. You may see an error message if Grafana is using a hostname that is not resolvable by the machine the browser is running on. Click **view details** and then the **Requests** tab to determine the hostname Grafana is trying to use; if needed, add the IP address and hostname to the `/etc/hosts` or `C:\Windows\system32\drivers\etc\hosts` file on the machine the browser is running on.

2. Download and edit our [sample metrics dashboard](./sample_metrics_dashboard.json).

   a. Open the JSON file in a text editor, on the same computer whose web browser you’re using.

   b. Throughout the entire file, replace our sample setting of `master.example.com` with the hostname of your Puppet master. (**Note**: This value MUST be used as the `metrics_server_id` setting, configured below).

   c. Save the file.

3. In the Grafana UI, click **search** (the folder icon), then **Import**, then **Browse**.
4. Navigate to the JSON file you just edited and confirm your choice.

This will load up a dashboard with six graphs that display various metrics exported to your Graphite server by Puppet Server. (Note that they’ll be empty until you enable Graphite metrics, as described below.)

### Enabling Puppet Server’s Graphite Support

The `/etc/puppetlabs/puppetserver/conf.d/metrics.conf` file controls Puppet Server’s metrics.  You shouldn’t edit it directly; instead, configure it with the “PE Master” node group in the PE console.

**To enable the metrics graphs**:

1. In the PE console, click **Classification** in the navigation bar.
2. On the **Classification** page, select the **PE Master** group.
3. Click the **Classes** tab.
4. Locate the **puppet_enterprise::profile::master** class.
5. Using the **Parameter name** dropdown list and **Value** fields, set the following parameters to the specified values. (To set a parameter, choose it from the drop-down list, enter the new value, and click **Add parameter**.)

   You should only need to set the first three parameters to non-default values, unless your Graphite server uses a non-standard port.

   a. **metrics_graphite_enabled**: set to **true** (**false** is the default value)

   b. **metrics_server_id**: enter the Puppet master hostname.

   c. **metrics_graphite_host**: enter the hostname for the agent node on which you’re running Graphite and Grafana.

   d. **metrics_enabled**: set to **true** (default value).

   e. **metrics_jmx_enabled**: set to **true** (default value).

   f. **metrics_graphite_port**: set to **2003** (default value) or the Graphite port on your Graphite server.

   g. **profiler_enabled**: set to **true** (default value).

6. Click **Commit 3 changes**.
7. Navigate to the live management page, ensure your Puppet master and agent nodes are selected, and select the **Control Puppet** tab.
8. Click the **runonce** action and then **Run** to trigger a Puppet run and apply the new configuration.

   You may have to wait a while for Puppet Server to restart before metrics begin appearing in your dashboard.

>**Tip**: In the Grafana UI, make sure you choose the appropriate time window from the drop-down.

#### About the Sample Grafana Dashboard

The sample dashboard you've imported into Grafana provides what we think is an interesting starting point. You can click on the title of any graph, and then click **edit** to tweak the graphs as you see fit.

Here's a quick rundown of what is happening the graphs:

- **Active Requests**: serves as a "health check" for the Puppet server. It shows a flat line that represents the number of CPUs you have in your system. It also shows a metric that indicates the total number of HTTP requests actively being processed by the server at any moment in time, and a rolling average of the number of active requests. If the number of requests being processed rises above the number of CPUs and stays there for any significant length of time, that is a good indication that your server is receiving more work than it can keep up with.

- **Request Durations**: shows a breakdown of the average response times for different types of requests made by a Puppet agent. This gives an idea of how expensive your catalog and report requests are compared to the other types of requests. It also gives you a way to see how your catalog compilation times may change when you introduce changes to your Puppet code. In addition, if your server becomes overloaded you will usually be able to see a sharp curve upward for all of the types of requests, and they should start trending back downwards if you are able to reduce the load on the server.

- **Request Ratios**: can be used to get a sense for how many requests of each type the server is handling. Under normal circumstances, you should see about the same number of catalog, node, or report requests since these all happen once per agent run. You will often see a much larger number of file/filemetadata requests, and this can give you a sense for how file-heavy your catalogs are.

- **Function Calls**: shows counts of how often various functions are being called in your catalog compilation. We have included a few common functions in the default dashboard, but you'll probably want to edit this graph to choose the functions you're most interested in for your own catalogs.

- **Function Execution Time**: focuses on execution time rather than on how frequently a function is called. This can give you insight into which of your functions are the most expensive, and where you might find potential optimizations to improve catalog compilation performance. As with the fourth graph, we've included some common default functions, but you'll want to edit this to choose your own most interesting functions.

- **Compilation**: is somewhat experimental: it breaks the catalog compilation down into various phases and shows you how expensive the various phases are compared to one another.


### Available Metrics

The following HTTP and Puppet profiler metrics are available from the Puppet server and can be added to your metrics reporting. Please note that the namespaces of these metrics may change in future releases.

#### HTTP Metrics

* `puppetlabs.<server-id>.http.active-histo`: a histogram showing statistics about the number of active HTTP requests over time
* `puppetlabs.<server-id>.http.active-requests`: a counter indicating the number of HTTP requests that are currently being processed by the server
* `puppetlabs.<server-id>.http.catalog-requests`: a counter indicating the number of Puppet catalog requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.file_content-requests`: a counter indicating the number of Puppet file content requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.file_metadata-requests`: a counter indicating the number of Puppet file metadata requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.file_metadatas-requests`: a counter indicating the number of Puppet file metadatas requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.node-requests`: a counter indicating the number of Puppet node requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.report-requests`: a counter indicating the number of Puppet report requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.other-requests`: a counter indicating the number of requests that have been processed by the server since startup that do not fall into any of the categories above
* `puppetlabs.<server-id>.http.total-requests`: a counter indicating the total number of requests that have been processed by the server since startup
* `puppetlabs.<server-id>.http.catalog-percentage`: the percentage of total requests that have been processed that were catalog requests
* `puppetlabs.<server-id>.http.file_content-percentage`: the percentage of total requests that have been processed that were file\_content requests
* `puppetlabs.<server-id>.http.file_metadata-percentage`: the percentage of total requests that have been processed that were file\_metadata requests
* `puppetlabs.<server-id>.http.file_metadatas-percentage`: the percentage of total requests that have been processed that were file_metadatas requests
* `puppetlabs.<server-id>.http.node-percentage`: the percentage of total requests that have been processed that were node requests
* `puppetlabs.<server-id>.http.report-percentage`: the percentage of total requests that have been processed that were report requests
* `puppetlabs.<server-id>.http.other-percentage`: the percentage of total requests that have been processed that were requests that do not fall into any of the categories above

### Puppet Profiler Metrics

* `puppetlabs.<server-id>.functions`: a counter and timer that tracks all function calls that occur during catalog compilations, as well as the average execution time
* `puppetlabs.<server-id>.functions.<function-name>`: for each individual function that is called during catalog compilation, a new metric will be created that tracks the number of times the functions is called and the average execution time
* `puppetlabs.<server-id>.compiler.compile`: a counter and a timer that tracks all catalog compilations and their average execution time
* `puppetlabs.<server-id>.compiler.compile.<environment>`: a counter and a timer that tracks all catalog compilations and their average execution time for a specific environment
* `puppetlabs.<server-id>.compiler.compile.<environment>.<node-name>`: a counter and a timer that tracks all catalog compilations and their average execution time for a specific node in a specific environment
* `puppetlabs.<server-id>.compiler.create_settings_scope`: a counter and a timer that tracks how much time is spent in the `create_settings_scope` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.evaluate_ast_node`: a counter and a timer that tracks how much time is spent in the `evaluate_ast_node` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.evaluate_definitions`: a counter and a timer that tracks how much time is spent in the `evaluate_definitions` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.evaluate_generators`: a counter and a timer that tracks how much time is spent in the `evaluate_generators` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.evaluate_main`: a counter and a timer that tracks how much time is spent in the `evaluate_main` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.evaluate_node_classes`: a counter and a timer that tracks how much time is spent in the `evaluate_node_classes` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.find_facts`: a counter and a timer that tracks how much time is spent in the `find_facts` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.find_node`: a counter and a timer that tracks how much time is spent in the `find_node` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.finish_catalog`: a counter and a timer that tracks how much time is spent in the `finish_catalog` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.init_server_facts`: a counter and a timer that tracks how much time is spent in the `init_server_facts` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.iterate_on_generators`: a counter and a timer that tracks how much time is spent in the `iterate_on_generators` phase of catalog compilation
* `puppetlabs.<server-id>.compiler.set_node_params`: a counter and a timer that tracks how much time is spent in the `set_node_params` phase of catalog compilation


