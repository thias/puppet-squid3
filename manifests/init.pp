# Class: squid3
#
# Squid 3.x proxy server.
#
# Sample Usage :
#     include squid3
#
#     class { 'squid3':
#       acl => [
#         'de myip 192.168.1.1',
#         'fr myip 192.168.1.2',
#         'office src 10.0.0.0/24',
#       ],
#       http_access => [
#         'allow office',
#       ],
#       cache => [ 'deny all' ],
#       via => 'off',
#       tcp_outgoing_address => [
#         '192.168.1.1 country_de',
#         '192.168.1.2 country_fr',
#       ],
#       server_persistent_connections => 'off',
#     }
#
class squid3 (
  # Options are in the same order they appear in squid.conf
  $use_deprecated_opts  = true,
  $http_port            = [ '3128' ],
  $https_port           = [],
  $acl                  = [],
  $http_access          = [],
  $icp_access           = [],
  $tcp_outgoing_address = [],
  $cache_mem            = '256 MB',
  $cache_dir            = [],
  $cache                = [],
  $via                  = 'on',
  $ignore_expect_100    = 'off',
  $cache_mgr            = 'root',
  $forwarded_for        = 'on',
  $client_persistent_connections = 'on',
  $server_persistent_connections = 'on',
  $maximum_object_size           = '4096 KB',
  $maximum_object_size_in_memory = '512 KB',
  $config_hash                   = {},
  $refresh_patterns              = [],
  $template                      = 'long',
  $version                       = 'installed'
) inherits ::squid3::params {

  $use_template = $template ? {
    'short' => 'squid3/squid.conf.short.erb',
    'long'  => 'squid3/squid.conf.long.erb',
    default => $template,
  }

  if ! empty($config_hash) and $use_template == 'long' {
    fail('$config_hash does not (yet) work with the "long" template!')
  }


  package { 'squid3_package': ensure => $version, name => $package_name }

  service { 'squid3_service':
    enable    => true,
    name      => $service_name,
    ensure    => running,
    restart   => "service ${service_name} reload",
    path      => ['/sbin', '/usr/sbin'],
    hasstatus => true,
    require   => Package['squid3_package'],
  }

  file { $config_file:
    require => Package['squid3_package'],
    notify  => Service['squid3_service'],
    content => template($use_template),
  }

}

