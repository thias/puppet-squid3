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
    }
    'Debian': {
      $default_package_name = 'squid'
      $service_name = 'squid3'
    }
    default: {
      $default_package_name = 'squid'
      $service_name = 'squid'
    }
  }

}

