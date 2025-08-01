# Security Bundle

The Atoolo Security Bundle is based on the [Security Bundle](https://symfony.com/components/Security%20Bundle){:target="\_blank"} and contains Atoolo-specific configurations and extensions for a role and user management system that can be maintained via the IES.

If necessary, it contains the necessary settings to secure individual queries of the GraphQL interface.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-security-bundle](https://github.com/sitepark/atoolo-security-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/security-bundle
```

## Description

The Atoolo security bundle extends the [Symfony security bundle](https://symfony.com/components/Security%20Bundle){:target="\_blank"}. It is used to secure API access to the website and to protect resources provided by the IES. The protection of resources via the security bundle is intended for simple cases. The CMS itself provides another option for protecting resources, which is much more powerful.

This bundle uses a user and role concept to control access. There are currently two ways to define users and roles.

1. `realm.properties` file
2. PHP files for users and roles below the `RESOURCE_ROOT/security` directory

## `realm.properties` file

The property file is loaded via the `Atoolo\Security\RealmPropertiesUserLoader`. This expects a path to the property file.

A user name and a password are expected per line in the file, separated by a colon. The roles of the user can be specified after the password, separated by a comma.

```properties
; comments are allowed
[username]: [password],[role1],[role2],...
```

## User and access PHP files

These PHP files are stored in a directory `RESOURCE_ROOT/security`. They are intended to be created by the CMS. This allows simple user administration to be realized with CMS means.

User files have the extension `.users.php` and access files have the extension `.access.php`.

User files are structured as follows:

```php
return [
    ['username' => 'a', 'password' => 'hash:a', 'roles' => ['user']],
    ['username' => 'b', 'password' => 'hash:b', 'roles' => ['user', 'admin']],
];
```

Access files are structured as follows:

```php
<?php

return [
    ['path' => '^/path-a/', 'roles' => ['a']],
    ['path' => '^/path-b/', 'roles' => ['b']],
    ['path' => '^/path-c/', 'ips' => ['192.168.0.1/24'], 'roles' => ['c']]
];
```

The roles file can be used to define which roles can access which paths.

Here this security bundle uses the `PathRequestMatcher` and `IpsRequestMatcher` from Symfony.
