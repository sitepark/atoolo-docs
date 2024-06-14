# Runtime checks

Atoolo provides a set of runtime checks to ensure that the application is running as expected. These checks can be used to monitor the application's health and to detect potential issues early on.

There are two levels of runtime checks. The first level checks whether the basic requirements are met. These include

- **PHP version**: The minimum PHP version required is stored in the application. This is compared with the currently installed PHP version.
- **PHP extensions**: The PHP extensions required are stored in the application. These are compared with the currently installed PHP extensions.
- **Process user**: The process user that may be used for execution is stored in the application. This is compared with the currently used process user.

These first-level runtime checks are carried out for every request and every CLI command before the application is started. If one of these checks fails, an error is thrown and the application is not started.

The second level of runtime checks checks further requirements. These include

- **Workers**: Checks whether the workers are set up and can process asynchronous tasks.
- **Indexing**: It is checked whether indexing is set up and the full-text search works.
- Other application-specific checks, which can also vary depending on the application.

The runtime checks of the second level are carried out by CLI command or by request.

## Check via CLI Command

```sh
su www-data \
  -s /bin/bash \
  -c '/var/www/example.com/www/app/bin/console runtime:check'
```

(_See also [Console Command](console-command.md)_)

The check via the CLI command can also be helpful to check whether the project still works after a PHP update.
On a Debian-based system this could look like this:

Assume the project is running with PHP version `8.2` and is to be updated to `8.3`. In this case, PHP `8.3` can be installed on the system first without activating it.

Then a new PHP executable `/usr/bin/php8.3` is available. Also `php-fpm` is installed with PHP `8.3`. After starting the service, the socket `/run/php/php8.3-fpm.sock` is available.

Now the `runtime:check` command has been executed with PHP `8.3` before the project is converted.

```sh
su www-data \
  -s /bin/bash \
  -c '/usr/bin/php8.3 /var/www/example.com/www/app/bin/console runtime:check \
    --fpm-socket /run/php/php8.3-fpm.sock \
    --skip worker'
```

`--skip worker` is necessary because the worker is a separate process and the runtime check only reads and evaluates the status file created by the worker and does not execute the checks with the new PHP version.

After activating the new PHP version and restarting the worker, `runtime:check` can then be executed to display the worker checks as well.

## Check via HTTP-Request

```sh
curl -H "Authorization: Bearer ${JWT}" https://www.example.com/api/runtime-check
```

A `JWT` (Json Web Token) is required for the request. This can be created via a command line call. It is also necessary that a corresponding user has been created in the [`realm.properties`](ies-webnode.md/#realm-properties-file) file. The user must be assigned the role `SYSTEM_AUDITOR`.

`realm.properties`

```sh
systemauditor: secure-password,SYSTEM_AUDITOR
```

Once the user has been created, the JWT can be created.

```sh
su www-data \
  -s /bin/bash \
  -c '/var/www/example.com/www/app/bin/console \
    lexik:jwt:generate-token \
    --user-class "Atoolo\Security\Entity\User" \
    --ttl 3600 # in seconds \
    systemauditor'
```
