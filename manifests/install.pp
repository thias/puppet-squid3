# Class: squid3::install
#
class squid3::install (
) inherits ::squid3 {
  package { 'squid3_package':
    ensure => $squid3::package_version,
    name   => $squid3::package_name,
  }
}
