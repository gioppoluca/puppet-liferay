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
class liferay(
  $catalina_home = $liferay::params::catalina_home,
  $catalina_base = $liferay::params::catalina_base,
  $version = $liferay::params::version,
) inherits liferay::params {
  
  #http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.2%20GA3/liferay-portal-6.1.2-ce-ga3-20130816114619181.war/download
  $libext = "$liferay::catalina_base/lib/ext"
  file {$libext:
ensure => 'directory'}
  
  file{"$libext/activation.jar":
    source => "puppet:///modules/liferay/$liferay::version/activation.jar"
  }
  file{"$libext/jms.jar":
    source => "puppet:///modules/liferay/$liferay::version/jms.jar"
  }
  file{"$libext/jta.jar":
    source => "puppet:///modules/liferay/$liferay::version/jta.jar"
  }
  file{"$libext/jutf7.jar":
    source => "puppet:///modules/liferay/$liferay::version/jutf7.jar"
  }
  file{"$libext/mail.jar":
    source => "puppet:///modules/liferay/$liferay::version/mail.jar"
  }
  file{"$libext/persistence.jar":
    source => "puppet:///modules/liferay/$liferay::version/persistence.jar"
  }
  file{"$libext/ccpp.jar":
    source => "puppet:///modules/liferay/$liferay::version/ccpp.jar"
  }
  

}
