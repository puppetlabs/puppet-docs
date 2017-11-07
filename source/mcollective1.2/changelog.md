---
layout: default
title: Changelog
canonical: "/mcollective/changelog.html"
---
# {{page.title}}

 * TOC Placeholder
  {:toc}

## Version 1.2.x

|Date|Description|Ticket|
|----|-----------|------|
|2011/11/09|Unsubscribe from topics when we are done with them to optimize use in very busy environments|10670|
|*2011/06/30*|*Release 1.2.1*|8117|
|2011/06/02|Correct parsing of MCOLLECTIVE_EXTRA_OPTS in cases where no config related settings were set|7755|
|2011/05/23|Allow applications to use the exit method as would normally be expected|7626|
|2011/05/16|Allow _._ in fact names|7532|
|2011/05/16|Fix compatability issues with RH4 init system|7448|
|2011/05/15|Handle failures from remote nodes better in the inventory app|7524|
|2011/05/06|Revert unintended changes to the Debian rc script|7420|
|2011/05/06|Remove the _test_ agent that was accidentally checked in|7425|
|*2011/05/04*|*Release 1.2.0*|7227|

## Version 1.1.x

|Date|Description|Ticket|
|----|-----------|------|
|2011/05/03|Improve Red Hat RC script by using distro builtin functions|7340|
|2011/05/01|Support setting a priority on Stomp messages|7246|
|2011/04/30|Handle broken and incomplete DDLs better and improve the format of DDL output|7191|
|2011/04/23|Encode the target agent and collective in requests|7223|
|2011/04/20|Make the SSL Cipher used a config option|7191|
|2011/04/20|Add a clear method to the PluginManager that deletes all plugins, improve test isolation|7176|
|2011/04/19|Abstract the creation of request and reply hashes to simplify connector plugin development|5701|
|2011/04/15|Improve the shellsafe validator and add a Util method to do shell escaping|7066|
|2011/04/14|Update Rakefile to have a mail_patches task|6874|
|2011/04/13|Update vendored systemu library for Ruby 1.9.2 compatability|7067|
|2011/04/12|Fix failing tests on Ruby 1.9.2|7067|
|2011/04/11|Update the DDL documentation to reflect the _mco help_ command|7042|
|2011/04/11|Document the use filters on the CLI|5917|
|2011/04/11|Improve handling of unknown facts in Util#has_fact? to avoid exceptions about nil#clone|6956|
|2011/04/11|Correctly set timeout on the discovery agent to 5 seconds as default|7045|
|2011/04/11|Let rpcutil#agent_inventory supply _unknown_ for missing values in agent meta data|7044|
|*2011/04/07*|*Release 1.1.4*|6952|
|2011/03/28|Correct loading of vendored JSON gem|6877|
|2011/03/28|Show collective and sub collective info in the inventory application|6872|
|2011/03/23|Disconnect from the middleware when mcollectived disconnects|6821|
|2011/03/21|Update rpcutil ddl file to be less strict about valid fact names|6764|
|2011/03/22|Support reading configuration from configfir/plugin.d for plugins|6623|
|2011/03/21|Update default configuration files for subcollectives|6741|
|2011/03/16|Add the ability to implement actions using external scripts|6705|
|2011/03/15|Port mc-controller to the Application framework and deprecate the exit command|6637|
|2011/03/13|Only cache registration and discovery agents, handle the rest as new instances|6692|
|2011/03/08|PluginManager can now create new instances on demand for a plugin type|6622|
|*2011/03/07*|*Release 1.1.3*|6609|
|2011/03/04|Rename /usr/sbin/mc to /usr/bin/mco|6578|
|2011/03/01|Wrap rpcclient in applications ensuring that options is always set|6308|
|2011/02/28|Make communicating with the middleware more robust by including send calls in timeouts|6505|
|2011/02/28|Create a wrapper to safely run shell commands avoiding zombies|6392|
|2011/02/19|Introduce Subcollectives for network partitioning|5967|
|2011/02/19|Improve error handling when parsing arguments in the rpc application|6388|
|2011/02/19|Fix error logging when file_logger creation fails|6387|
|2011/02/17|Correctly parse MCOLLECTIVE_EXTRA_OPTS in the new unified binary framework|6354|
|2011/02/15|Allow the signing key and Debian distribution to be customized|6321|
|2011/02/14|Remove inadvertently included package.ddl|6313|
|2011/02/14|Handle missing libdirs without crashing|6306|
|*2011/02/14*|*Release 1.1.2*|6303|
|2011/02/13|Surpress replies to SimpleRPC clients who did not request results|6305|
|2011/02/11|Fix Debian packaging error due to the same file in multiple packages|6276|
|2011/02/11|The application framework will now disconnect from the middleware for consistancy|6292|
|2011/02/11|Returning _nil_ from a registration plugin will skip registration|6289|
|2011/02/11|Set loglevel to warn by default if not specified in the config file|6287|
|2011/02/10|Fix backward compatability with empty fact strings|6278|
|*2011/02/07*|*Release 1.1.1*|6080|
|2011/02/02|Load the DDL from disk once per printrpc call and not for every result|5958|
|2011/02/02|Include full Apache 2 license text|6113|
|2011/01/31|Create a new single executable application framework|5897|
|2011/01/30|Fix backward compatibility with old foo=/bar/ style fact searches|5985|
|2011/01/30|Documentation update to reflect correct default identity behavior|6073|
|2011/01/29|Let the YAML file force fact reloads when the files update|6057|
|2011/01/29|Add the ability for fact plugins to force fact invalidation|6057|
|2011/01/29|Document an approach to disable type validation in the DDL|6066|
|2011/01/19|Add basic filters to the mc-ping command|5933|
|2011/01/19|Add a ping action to the rpcutil agent|5937|
|2011/01/17|Allow MC::RPC#printrpc to print single results|5918|
|2011/01/16|Provide SimpleRPC style results when accessing the MC::Client results directly|5912|
|2011/01/11|Add an option to Base64 encode the STOMP payload|5815|
|2011/01/11|Fix a bug with forcing all facts to be strings|5832|
|2011/01/08|When using reload_agents or USR1 signal no agents would be reloaded|5808|
|2011/01/04|Use the LSB based init script on SUSE|5762|
|2011/01/04|Remove the use of a Singleton in the logging class|5749|
|2011/01/02|Add AES+RSA security plugin|5696|
|2010/12/31|Security plugins now have access to the callerid of the message they are replying to|5745|
|2010/12/30|Allow - in fact names|5727|
|2010/12/29|Treat machines that fail security validation like ones that did not respond|5700|
|*2010/12/29*|*Release 1.1.0*|5695|
|2010/12/28|Remove trailing whitespace from all source files|5702|
|2010/12/28|Adjust the logfile audit format to include local time and all on one line|5694|
|2010/12/26|Improve the SimpleRPC fact_filter helper to support new fact operators|5678|
|2010/12/25|Increase the rpcutil timeout to allow for slow facts|5679|
|2010/12/25|Allow for network and fact source latency when calculating client timeout|5676|
|2010/12/25|Remove MCOLLECTIVE_TIMEOUT and MCOLLECTIVE_DTIMEOUT environment vars in favour of MCOLLECTIVE_EXTRA_OPTS|5675|
|2010/12/25|Refactor the creation of the options hash so other tools don't need to know the internal formats|5672|
|2010/12/21|The fact plugin format has been changed and simplified, the base now provides caching and thread safety|5083|
|2010/12/20|Add parameters <=, >=, <, >, !=, == and =~ to fact selection|5084|
|2010/12/14|Add experimental sshkey security plugin|5085|
|2010/12/13|Log a startup message showing version and log level|5538|
|2010/12/13|Add a console logger|5537|
|2010/12/13|Logging is now plugable and a syslog plugin was provided|5082|
|2010/12/13|Allow libdir to be an array of directories for agents and ddl files|5253|
|2010/12/13|The progress bar will now intelligently figure out the terminal dimentions|5524|

## Version 1.0.x

|Date|Description|Ticket|
|----|-----------|------|
|*2011/02/16*|*Release 1.0.1*|6342|
|2011/02/02|Include full Apache 2 license text|6113|
|2011/01/29|The YAML fact plugin kept deleted facts in memory|6056|
|2011/01/04|Use the LSB based init script on SUSE|5762|
|2010/12/30|Allow - in fact names|5727|
|2010/12/29|Treat machines that fail security validation like ones that did not respond|5700|
|2010/12/25|Allow for network and fact source latency when calculating client timeout|5676|
|2010/12/25|Increase the rpcutil timeout to allow for slow facts|5679|
|*2010/12/13*|*Release 1.0.0*|5453|

## Version 0.4.x

|Date|Description|Ticket|
|----|-----------|------|
|2010/12/04|Remove the LSB requirements for RedHat systems|5451|
|2010/11/23|Make the YAML fact source thread safe and force all facts to strings|5377|
|2010/11/23|Add get_config_item to rpcutil to retrieve a running config value from a server|5376|
|2010/11/20|Convert mc-facts into a SimpleRPC client|5371|
|2010/11/18|Added GPG signing to Rake packaging tasks (SIGNED=1)|5355|
|2010/11/17|Improve error messages from clients in the case of failure|5329|
|2010/11/17|Add helpers to disconnect from the middleware and update all bundled clients|5328|
|2010/11/16|Correct LSB provides and requires in default init script|5222|
|2010/11/16|Input validation on rpcutil has been improved to match all valid facts|5320|
|2010/11/16|Add the ability to limit the results to a subset of hosts|5306|
|2010/11/15|Add fire and forget mode to SimpleRPC custom_request|5305|
|2010/11/09|General connection settings to the Stomp connector was ignored|5245|
|*2010/10/18*|*Release version 0.4.10*| |
|2010/10/18|Document exit command to mc-controller|152|
|2010/10/13|Log messages that don't pass the filters at debug level|149|
|2010/10/03|Preserve options in cases where RPC::Client instances exist in the same program|148|
|2010/09/30|Add the ability to set different types of callerid in the PSK plugin|145|
|2010/09/30|Improve Ruby 1.9.x compatibility|142|
|2010/09/29|Improve error handling in registration to avoid high CPU usage loops|143|
|*2010/09/21*|*Release version 0.4.9*| |
|2010/09/20|Improve Debian packaging task|140|
|2010/09/20|Add :boolean type support to the DDL|138|
|2010/09/19|Refactor MCollective::RPC to add less unneeded stuff to Object|137|
|2010/09/18|Prevent duplicate config loading with multiple clients active|136|
|2010/09/18|Rotate the log file by default, keeping 5 x 2MB files|135|
|2010/09/18|Write a overview document detailing security of the collective|131|
|2010/09/18|Add MCollective.version, set it during packaging and include it in the rpcutil agent|134|
|2010/09/13|mc-inventory now use SimpleRPC and the rpcutil agent and display server stats|133|
|2010/09/13|Make the path to the rpc-help.erb configurable and set sane default|130|
|2010/09/13|Make the configfile used available in the Config class and add to rpcutil|132|
|2010/09/12|Rework internal statistics and add a rpcutil agent|129|
|2010/09/12|Fix internal memory structures related to agent meta data|128|
|2010/08/24|Update the OpenBSD port for changes in 0.4.8 tarball|125|
|2010/08/23|Fix indention/block error in M:R:Stats|124|
|2010/08/23|Fix permissions in the RPM for files in /etc|123|
|2010/08/23|Fix language in two error messages|122|
|*2010/08/20*|*Release version 0.4.8*| |
|2010/08/19|Fix missing help template in debian packages|90|
|2010/08/18|Clean up some hardlink warnings in the Rakefile|117|
|2010/08/18|Include the website in the main repo and add a simple Rake task|118|
|2010/08/17|Handle exceptions for missing plugins better|115|
|2010/08/17|Add support for ~/.mcollective as a config file|114|
|2010/08/07|SSL security plugin can use either YAML or Marshal|94|
|2010/08/06|Multiple YAML files can now be used as fact source|112|
|2010/08/06|Allow log level to be adjusted at run time with USR2|113|
|2010/07/31|Add basic report scripting support to mc-inventory|111|
|2010/07/06|Removed 'rpm' from the default rake task|109|
|2010/07/06|Add redhat-lsb to the server RPM dependencies|108|
|*2010/06/29*|*Release version 0.4.7*| |
|2010/06/27|Change default factsource to Yaml|106|
|2010/06/27|Added VIM snippets to create DDLs and Agents|102|
|2010/06/26|DDL based help now works better with Symbols in in/output|105|
|2010/06/23|Whitespace at the end of config lines are now stripped|100|
|2010/06/22|printrpc will now inject some colors into results|99|
|2010/06/22|Recover from syntax and other errors in agents|98|
|2010/06/17|The agent a MC::RPC::Client is working on is now available|97|
|2010/06/17|Integrate the DDL with data display helpers like printrpc|92|
|2010/06/15|Avoid duplicate topic subscribes in complex clients|95|
|2010/06/15|Catch some unhandled exceptions in RPC Agents|96|
|2010/06/15|Fix missing help template file from RPM|90|
|*2010/06/14*|*Release version 0.4.6* | |
|2010/06/12|Qualify the Process class to avoid clashes in the discovery agent|88|
|2010/06/12|Add mc-inventory which shows agents, classes and facts for a node|87|
|2010/06/11|mc-facts now supports standard filters|86|
|2010/06/11|Add connection pool retry options and ssl for connection|85|
|2010/06/11|Add support for specifying multiple stomp hosts for failover|84|
|2010/06/10|Tighten up handling of filters to avoid nil's getting into them|83|
|2010/06/09|Sort the mc-facts output to be more readable|82|
|2010/06/08|Fix deprecation warnings in newer Stomp gems|81|
|*2010/06/03*|*Release version 0.4.5* | |
|2010/06/01|Improve the main discovery agent by adding facts and classes to its inventory action|79|
|2010/05/30|Add various helpers to get reports as text instead of printing them|43|
|2010/05/30|Add a custom_request method to call SimpleRPC agents with your own discovery|75|
|2010/05/30|Refactor RPC::Client to be more generic and easier to maintain|75|
|2010/05/29|Fix a small scoping issue in Security::Base|76|
|2010/05/25|Add option --no-progress to disable progress bar for SimpleRPC|74|
|2010/05/23|Add some missing dependencies to the RPMs|72 |
|2010/05/22|Add an option _:process_results_ to the client|71|
|2010/05/13|Fix help output that still shows old branding|70|
|2010/04/27|The supplied generic stompclient now accepts STOMP_PORT in the environment|68 |
|2010/04/26|Add a SimpleRPC Client helper to reset filters|64 |
|2010/04/26|Listen for signal USR1 and reload all agents from disk|65 |
|2010/04/12|Add SimpleRPC Authorization support|63|
|*2010/04/03*|*Release version 0.4.4* | |
|2010/03/27|Make it easier to construct SimpleRPC requests to use with the standard client library|60 |
|2010/03/27|Manipulating the filters via the helper methods will force rediscovery|59 |
|2010/03/23|Prevent Activesupport when brought in by Facter from breaking our logs|57 |
|2010/03/23|Clean up logging for messages not targeted at us|56 |
|2010/03/19|Add exception handling to the registration base class|55 |
|2010/03/03|Use /usr/bin/env ruby instead of hardcoded paths|54|
|2010/02/17|Improve mc-controller and document it|46|
|2010/02/08|Remove some close coupling with Stomp to easy creating of other connectors|49|
|2010/02/01|Made the discovery agent timeout configurable using plugin.discovery.timeout|48|
|2010/01/25|mc-controller now correctly loads/reloads agents.|45|
|2010/01/25|Building packages has been improved to ensure rdocs are always included|44 |
|*2010/01/24*|*Release version 0.4.3* | |
|2010/01/23|Handle ctrl-c during discovery without showing exceptions to users|34 |
|2010/01/21|Force all facts in the YAML fact source to be strings|41 |
|2010/01/19|Add auditing to SimpleRPC clients and Agents | |
|2010/01/18|The SRPM we provide will now build outside of the Rake environment|40|
|2010/01/18|Add a _fail!_ method to RPC::Agent|37|
|2010/01/18|mc-rpc can now be used without supplying arguments|38 |
|2010/01/18|Don't raise an error if no user/pass is given to the stomp connector, try unauthenticated mode|35|
|2010/01/17|Improve error message when Regex validation failed on SimpleRPC input|36|
|*2010/01/13*|*Release version 0.4.2* | |
|2010/01/13|New packaging for Debian provided by Riccardo Setti|29|
|2010/01/07|Improved LSB compliance of the init script - thanks Riccardo Setti|32|
|2010/01/07|Multiple calls to SimpleRPC client would reset discovered hosts|31|
|2010/01/04|Timeouts can now be changed with MCOLLECTIVE_TIMEOUT and MCOLLECTIVE_DTIMEOUT environment vars|25|
|2010/01/04|Specify class and fact filters easier with the new -W or --with option|27 |
|2010/01/04|Added COPYING file to RPMs and tarball|28|
|2010/01/04|Make shorter filter options -C, -I, -A and -F|26|
|*2010/01/02*|*Release version 0.4.1* | |
|2010/01/02|Added hooks to plug into the processing of requests, also enabled setting meta data and timeouts|14|
|2010/01/02|Created readers for @config and @logger in the SimpleRPC agent|23|
|2009/12/30|Don't send out any requests if no nodes were discovered|17|
|2009/12/30|Added :discovered and :discovered_nodes to client stats|20|
|2009/12/30|Add a empty_filter? helper to the RPC mixin|18|
|2009/12/30|Fix formatting bug with progress bar|21|
|2009/12/29|Simplify mc-rpc command line|16|
|2009/12/29|Fix layout issue when printing hosts that did not respond|15|
|*2009/12/29*|*Release version 0.4.0* | |
|2009/12/28|Add support for other configuration management systems like chef in the --with-class filters|13|
|2009/12/28|Add a <em>Util.empty_filter?</em> to test for an empty filter| |
|2009/12/27|Create a new client framework - SimpleRPC|6|
|2009/12/27|Add support for multiple filters of the same type|3|

## Version 0.3.x

|Date|Description|Ticket|
|----|-----------|------|
|*2009/12/17*|*Release version 0.3.0* | |
|2009/12/16|Improvements for newer versions of Ruby where TERM signal was not handled|7|
|2009/12/07|MCollective::Util is now a module and plugins can drop in util classes in the plugin dir| |
|2009/12/07|The Rakefile now works with rake provided on Debian 4 systems|2|
|2009/12/07|Improvements in the RC script for Debian and older Ubuntu systems|5|

## Version 0.2.x

|Date|Description|Ticket|
|2009/12/01|Release version 0.2.0| |
