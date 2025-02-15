# Class: squid3::params
#
class squid3::params {

  case $facts['os']['family'] {
    'RedHat': {
      if versioncmp($facts['os']['release']['major'],'6') < 0 {
        $package_name = 'squid3'
      } else {
        $package_name = 'squid'
      }
      $service_name   = 'squid'
      $service_enable = true
      $config_file    = '/etc/squid/squid.conf'
      $log_directory  = '/var/log/squid'
      $coredump_dir   = '/var/spool/squid'
    }
    'Debian': {
      if $facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['full'],'16.04') >= 0 {
        $package_name   = 'squid'
        $service_name   = 'squid'
        $service_enable = false
        $config_file    = '/etc/squid/squid.conf'
        $log_directory  = '/var/log/squid'
        $coredump_dir   = '/var/spool/squid'
      } else {
        $package_name   = 'squid3'
        $service_name   = 'squid3'
        $service_enable = false
        $config_file    = '/etc/squid3/squid.conf'
        $log_directory  = '/var/log/squid3'
        $coredump_dir   = '/var/spool/squid3'
      }
    }
    'FreeBSD': {
      $package_name   = 'squid'
      $service_name   = 'squid'
      $service_enable = true
      $config_file    = '/usr/local/etc/squid/squid.conf'
      $log_directory  = '/var/log/squid'
      $coredump_dir   = '/var/spool/squid'
    }
    default: {
      $package_name   = 'squid'
      $service_name   = 'squid'
      $service_enable = true
      $config_file    = '/etc/squid/squid.conf'
      $log_directory  = '/var/log/squid'
      $coredump_dir   = '/var/spool/squid'
    }
  }

  $access_log      = [ "stdio:${log_directory}/access.log squid" ]
  $cache_log       = "${log_directory}/cache.log"
  $cache_store_log = "stdio:${log_directory}/store.log"

}
