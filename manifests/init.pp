# Class: squid3
#
class squid3 (
  # Options are in the same order they appear in squid.conf
  $use_deprecated_opts           = true,
  $http_port                     = [ '3128' ],
  $https_port                    = [],
  $acl                           = [],
  $ssl_ports                     = [ '443' ],
  $safe_ports                    = [ '80', '21', '443', '70', '210', '1025-65535', '280', '488', '591', '777', ],
  $http_access                   = [],
  $icp_access                    = [],
  $tcp_outgoing_address          = [],
  $cache_mem                     = '256 MB',
  $cache_dir                     = [],
  $cache                         = [],
  $via                           = 'on',
  $ignore_expect_100             = 'off',
  $cache_mgr                     = 'root',
  $forwarded_for                 = 'on',
  $client_persistent_connections = 'on',
  $server_persistent_connections = 'on',
  $maximum_object_size           = '4096 KB',
  $maximum_object_size_in_memory = '512 KB',
  $config_hash                   = {},
  $refresh_patterns              = [],
  $template                      = 'long',
  $package_version               = 'installed',
  $package_name                  = $::squid3::params::package_name,
  $service_ensure                = 'running',
  $service_enable                = $::squid3::params::service_enable,
  $service_name                  = $::squid3::params::service_name,
  $use_auth                      = $::squid3::params::use_auth,
  $auth_type                     = $::squid3::params::auth_type,
  $auth_options                  = $::squid3::params::auth_options,
  $auth_ext_acl                  = $::squid3::params::auth_ext_acl,
  $auth_acl                      = $::squid3::params::auth_acl,
  $access_log                    = $::squid3::params::access_log,
  $allow_localnet                = $::squid3::params::allow_localnet,
) inherits ::squid3::params {
  class { '::squid3::install': }
  if $package_version == 'installed' {
    class { '::squid3::service': }
    class { '::squid3::config': }
  }
}
