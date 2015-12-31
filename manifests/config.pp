# Class: squid3::config
#
class ::squid3::config (
) inherits ::squid3 {
  $use_template = $squid3::template ? {
    'short' => 'squid3/squid.conf.short.erb',
    'long'  => 'squid3/squid.conf.long.erb',
    default => $squid3::template,
  }
  if ! empty($squid3::config_hash) and $use_template == 'long' {
    fail('$config_hash does not (yet) work with the "long" template!')
  }
  file { $squid3::config_file:
    require      => Package['squid3_package'],
    notify       => Service['squid3_service'],
    content      => template($use_template),
    validate_cmd => "/usr/sbin/${squid3::service_name} -k parse -f %",
  }
}
