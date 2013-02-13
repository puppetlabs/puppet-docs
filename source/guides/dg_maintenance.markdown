VI. Maintenance
-----	


###	Cleaning things out

* Watch out for YAML reports in /opt/puppet/share/puppet-dashboard/spool/ piling up and taking up lots of space.

* The InnoDB database for the console can grow and grow in size, but the rake tasks won't actually shrink it, only free up space inside of it.