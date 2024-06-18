# Deployment Bundle

Symfony bundle to react to the deploy and undeploy of a project.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-deployment-bundle](https://github.com/sitepark/atoolo-deployment-bundle){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/deployment-bundle
```

## Deployment strategy

There are various strategies for deploying PHP frameworks. The strategy for deploying Atoolo projects in the IES context is described below.

The strategy is designed so that files no longer need to be loaded from a Git or Composer repository for deployment.
The deployment is carried out by providing the project with all dependencies in a `tar.gz` archive. This archive is unpacked on the target server into a directory specifically created for this archive. E.G.

```sh
/apps/myproject-1.0.0
```

This deployment bundle provides a 'deploy' command that is now executed in the project.

```sh
/apps/myproject-1.0.0/bin/console deployment:deploy
```

Execute the command for the following steps:

1. a [Platform Check](https://php.watch/articles/composer-platform-check) is performed to ensure that the required PHP version and the required PHP extensions are installed.
2. create the Symfony caches for e.g. containers, routing, etc.
3. execute bundle- and project-specific deployment task

The project may only be activated once all steps have been successfully completed. This is done by setting a symlink to the directory that the web server uses for the relevant host.

```sh
/apps/myproject -> /apps/myproject-1.0.0/
```

This enables a smooth update to a new version. It is also possible to roll back to a previous version.

By using a symlink, however, there are a few things to consider for the PHP project.

- In the standard configuration, opcache does not recognize when the real path to a PHP file changes. However, this is the case if the symlink points to a new version. The option
  ```ini
  opcache.revalidate_path = 1
  ```
  can change this behavior. This means that the opcache checks whether the real path has changed with every request. This can be done in the web server configuration. For Apache, for example, in the VirtualHost configuration.
  ```apache
  SetEnv PHP_VALUE "opcache.revalidate_path = 1"
  ```
  This means that the configuration is retained even after a PHP minor update if the system creates a new configuration directory for the PHP version.
- The configuration of the web server must also be adapted. The web server must be configured so that it follows the symlink. In Apache, for example, this can be achieved with the `FollowSymLinks` option.
- When using the Symfony message bus, there are workers that wait for the messages. These workers must be restarted after a deployment.

## Deployment-Task

You can implement your own deployment task. This bundle makes the interface `Atoolo\Deployment\Service\DeploymentExecutable` available for this purpose.

```php
namespace Example;

use Atoolo\Deployment\Service\DeploymentExecutable;

class MyDeploymentTask implements DeploymentExecutable
{
    public function execute(): void
    {
        // Do something
    }
}
```

The task must then be registered in the service configuration.

`config/services.yaml`

```yaml
services:
  Example\MyDeploymentTask:
    tags:
      - { name: "atoolo_deployment.deploy_executor" }
```

## Automated stopping of the worker after deployment

This bundle starts a listener that checks whether a deployment has taken place. This is recognized by the fact that the original path of the project has changed. If this is the case, the worker processes its current queue and is then stopped.

When using `supervisor` to manage the worker processes, the process is automatically restarted when it is terminated. This behavior can be influenced by the configuration of `supervisor`. This ensures that the worker processes are active again after a deployment.

## Run deployment via FPM

The project also provides the route `/api/admin/deploy` to start the deployment process via FPM. This is useful if the deployment process cannot be started via the console. As the deploy command must be executed before it is activated, this cannot be done via an HTTP request, as this only reaches the already active project.

The request must therefore be made directly via the FastCGI protocol, which is also used by the web server to address the FMP process.

This can be done via the script `cgi-fcgi`, for example.

Install `cgi-fcgi`:

```sh
sudo apt-get install libfcgi0ldbl
```

First of all, a JWT token is required sie also [atoolo/security-bundle](security.md):

```sh
JWT_DIR=/path/to/jwt-keys
JWT_SECRET_KEY=$JWT_DIR/private.pem
JWT_PUBLIC_KEY=$JWT_DIR/public.pem
DOCUMENT_ROOT=/apps/myproject-1.0.0/public
SCRIPT_FILENAME=$DOCUMENT_ROOT/index.php
FPM_SOCKET=127.0.0.1:9000
# Access via the unix socket must be via 'root' or the user 'www-data'
#FPM_SOCKET=/run/php/php-fpm.sock
#FPM_SOCKET=/run/php/php8.3-fpm.sock

JSON_DATA='{"username":"api", "password":"__REPLACE_WITH_PASSWORD__"}'
REQUEST_PATH=/api/login_check

echo $JSON_DATA | \
JWT_SECRET_KEY=$JWT_SECRET_KEY \
JWT_PUBLIC_KEY=$JWT_PUBLIC_KEY \
JWT_PASSPHRASE= \
SCRIPT_FILENAME=$SCRIPT_FILENAME \
DOCUMENT_ROOT=$DOCUMENT_ROOT \
CONTENT_TYPE=application/json \
CONTENT_LENGTH=${#JSON_DATA} \
REQUEST_METHOD=POST \
REQUEST_URI=$REQUEST_PATH \
cgi-fcgi -bind -connect $FPM_SOCKET
```

The deployment process can then be started with the token:

```sh
REQUEST_PATH=/api/admin/deploy
JWT=__REPLACE_WITH_JWT_TOKEN__

JWT_SECRET_KEY=$JWT_SECRET_KEY \
JWT_PUBLIC_KEY=$JWT_PUBLIC_KEY \
JWT_PASSPHRASE= \
SCRIPT_FILENAME=$SCRIPT_FILENAME \
DOCUMENT_ROOT=$DOCUMENT_ROOT \
REQUEST_METHOD=GET \
REQUEST_URI=$REQUEST_PATH \
HTTP_AUTHORIZATION="Bearer $JWT" \
cgi-fcgi -bind -connect $FPM_SOCKET
```
