# puppet-squid3

## Overview

Install, enable and configure a Squid 3 http proxy server with its main
configuration file options.

* `squid3` : Main class for the Squid 3 http proxy server.

## Examples

Basic memory caching proxy server :

```puppet
include squid3
```

Non-caching multi-homed proxy server :

```puppet
class { '::squid3':
  acl => [
    'de myip 192.168.1.1',
    'fr myip 192.168.1.2',
    'office src 10.0.0.0/24',
  ],
  http_access => [
    'allow office',
  ],
  cache => [ 'deny all' ],
  via => 'off',
  tcp_outgoing_address => [
    '192.168.1.1 country_de',
    '192.168.1.2 country_fr',
  ],
  server_persistent_connections => 'off',
}
```

Password protected proxy (basic authentication):
```puppet
  class { "::squid3":
    template      => "short",
    auth_required => true,
    config_hash   => {
      "auth_param basic program"     => "/usr/lib64/squid/ncsa_auth /etc/squid/squid.passwd",
      "auth_param basic realm"       => "proxy",
      "acl authenticated proxy_auth" => "REQUIRED",
      "http_access allow"            => "authenticated",
      "http_access deny"             => "all",
    }
  }

  file { "/etc/squid/squid.passwd":
    ensure => file,
    source => "puppet:///modules/profiles/squid.passwd",
    owner  => "root",
    group  => "squid",
    mode   => "0640",
    notify => Service["squid"],
  }
```
Here, we have installed the password file we built with `htpasswd` to the squid
directory and have updated squid to use it with the `ncsa_auth` program (this
is a centos box).  The `auth_required` attribute disables the rules allowing 
`localnet` access in squid.conf.
