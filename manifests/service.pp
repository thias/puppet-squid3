# Class: squid3::service
#
class squid3::service (
) inherits ::squid3 {
  service { 'squid3_service':
    ensure    => $squid3::service_ensure,
    enable    => $squid3::service_enable,
    name      => $squid3::service_name,
    restart   => "service ${squid3::service_name} reload",
    path      => [ '/sbin', '/usr/sbin', '/usr/local/etc/rc.d' ],
    hasstatus => true,
    require   => Package['squid3_package'],
  }
}
