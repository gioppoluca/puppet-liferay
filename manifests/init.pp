# Class: liferay
#
# This module manages liferay
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class liferay (
  $catalina_home = $liferay::params::catalina_home,
  $catalina_base = $liferay::params::catalina_base,
  $version       = $liferay::params::version,
  $dbhost=$liferay::params::dbhost,
  $dbname=$liferay::params::dbname,
  $dbuser=$liferay::params::dbuser,
  $dbpass=$liferay::params::dbpass,
  ) inherits liferay::params {
  # http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.2%20GA3/liferay-portal-6.1.2-ce-ga3-20130816114619181.war/download
  $libext = "$liferay::catalina_base/lib/ext"

  file { $libext: ensure => 'directory' }

  file { "$libext/activation.jar": source => "puppet:///modules/liferay/$liferay::version/activation.jar" }

  file { "$libext/jms.jar": source => "puppet:///modules/liferay/$liferay::version/jms.jar" }

  file { "$libext/jta.jar": source => "puppet:///modules/liferay/$liferay::version/jta.jar" }

  file { "$libext/jutf7.jar": source => "puppet:///modules/liferay/$liferay::version/jutf7.jar" }

  file { "$libext/mail.jar": source => "puppet:///modules/liferay/$liferay::version/mail.jar" }

  file { "$libext/persistence.jar": source => "puppet:///modules/liferay/$liferay::version/persistence.jar" }

  file { "$libext/ccpp.jar": source => "puppet:///modules/liferay/$liferay::version/ccpp.jar" }
  file { "$libext/jtds.jar": source => "puppet:///modules/liferay/$liferay::version/jtds.jar" }
  file { "$libext/mysql.jar": source => "puppet:///modules/liferay/$liferay::version/mysql.jar" }
  file { "$libext/portal-service.jar": source => "puppet:///modules/liferay/$liferay::version/portal-service.jar" }
  file { "$libext/portlet.jar": source => "puppet:///modules/liferay/$liferay::version/portlet.jar" }
  file { "$libext/postgresql.jar": source => "puppet:///modules/liferay/$liferay::version/postgresql.jar" }
  file { "$libext/support-tomcat.jar": source => "puppet:///modules/liferay/$liferay::version/support-tomcat.jar" }
  file { "$libext/hsql.jar": source => "puppet:///modules/liferay/$liferay::version/hsql.jar" }
  file { "$libext/junit.jar": source => "puppet:///modules/liferay/$liferay::version/junit.jar" }
  
  # files on the temp folder
  $temp = "$liferay::catalina_base/temp"
  file { ["$temp/liferay", 
"$temp/liferay/com",
"$temp/liferay/com/liferay",
"$temp/liferay/com/liferay/portal",
"$temp/liferay/com/liferay/portal/deploy",
"$temp/liferay/com/liferay/portal/deploy/dependencies",]: ensure => 'directory' }
file { "$temp/liferay/com/liferay/portal/deploy/dependencies/resin.jar": source => "puppet:///modules/liferay/$liferay::version/resin.jar" }
file { "$temp/liferay/com/liferay/portal/deploy/dependencies/script-10.jar": source => "puppet:///modules/liferay/$liferay::version/script-10.jar" }

  # setting $TOMCAT_HOME/conf/Catalina/localhost
  $conf = "$liferay::catalina_base/conf"

  file { ["$conf/Catalina", "$conf/Catalina/localhost"]: ensure => 'directory' }

  file { "$conf/Catalina/localhost/ROOT.xml": content => template("liferay/$liferay::version/ROOT.xml.erb") }



# change the catalina.properties
/*
augeas{'catalina.properties':
incl => "$conf/catalina.properties",
lens => "Properties.lns",
changes => 'set common.loader ${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/lib/ext,${catalina.home}/lib/ext/*.jar'
  
}
*/
file { "$conf/catalina.properties": content => template("liferay/$liferay::version/catalina.properties.erb") }

# setenv.sh
$bin = "$liferay::catalina_base/bin"
file { "$bin/setenv.sh": content => template("liferay/$liferay::version/setenv.sh.erb") }

# setup liferay
file { "$liferay::catalina_home/portal-ext.properties": content => template("liferay/$liferay::version/portal-ext.properties.erb") }
file { "$liferay::catalina_home/portal-setup-wizard.properties": content => template("liferay/$liferay::version/portal-setup-wizard.properties.erb") }

# the war
tomcat::war { 'ROOT.war':
        catalina_base => $liferay::catalina_base,
        war_source => 'http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.2%20GA3/liferay-portal-6.1.2-ce-ga3-20130816114619181.war/download',
      }

}
