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
    'country_de myip 192.168.1.1',
    'country_fr myip 192.168.1.2',
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
Non-caching multi-homed proxy server with basic ldap authentication :

```puppet
class { '::squid3':
  acl => [
    'country_de myip 192.168.1.1',
    'country_fr myip 192.168.1.2',
    'office src 10.0.0.0/24',
  ],
  http_access => [
    'deny !squidallowed',
    'allow office',
  ],
  cache => [ 'deny all' ],
  via => 'off',
  tcp_outgoing_address => [
    '192.168.1.1 country_de',
    '192.168.1.2 country_fr',
  ],
  server_persistent_connections => 'off',
  use_auth       => true,
  auth_type      => 'basic',
  auth_options   => {
    children       => 5,
    realm          => 'Squid proxy-caching web server',
    credentialsttl => '1 minute',
    program        => '/usr/lib64/squid/squid_ldap_auth -b "ou=Users,o=Company,DC=com" -D "cn=LdapBindDN,ou=Users,o=Company,DC=com" -w "VerySecretPassword" -f "(&(cn=%s)(objectClass=person))" -h ldaps://ldapserver:636'
  }
  auth_ext_acl   => 'UserAllowed ipv4 ttl=1 %LOGIN /usr/lib64/squid/squid_ldap_group -b "ou=Users,o=Company,DC=com" -f "(&(cn=%g)(objectClass=groupOfNames)(member=%u))" -F "(&(cn=%s)(objectClass=person))" -B "ou=Users,o=Company,DC=com" -H ldaps://ldapserver:636 -v 3 -D "cn=LdapBindDN,ou=Users,o=Company,DC=com" -w "VerySecretPassword"'
  auth_acl       => [
    'squidallowed external UserAllowed GrpSquidAccess',
    'ldapauth proxy_auth REQUIRED']
  allow_localnet => false
}
```

to uninstall :

```puppet
class { '::squid3':
  package_version => 'absent'
}
```

## Caveats

Upgrading Squid3 from version 3.2 to 3.3 breaks the configuration file to fix :

```puppet
class { '::squid3':
  use_deprecated_opts => false
}
```

