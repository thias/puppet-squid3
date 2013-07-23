# Class: squid3::params
#
class squid3::params {

  case $::osfamily {
    'RedHat': {
      if $::operatingsystemrelease < 6 {
        $package_name = 'squid3'
      } else {
        $package_name = 'squid'
      }
      $service_name = 'squid'
      $config_file = '/etc/squid/squid.conf'
    }
    'Debian': {
      $package_name = 'squid3'
      $service_name = 'squid3'
      $config_file = '/etc/squid3/squid.conf'
    }
    default: {
      $package_name = 'squid'
      $service_name = 'squid'
      $config_file = '/etc/squid/squid.conf'
    }
  }

}

