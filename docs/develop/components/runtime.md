# Runtime Component

Composer plugin for initializing bootstrapping logic such as initialization and requirement validation.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-runtime](https://github.com/sitepark/atoolo-runtime){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/runtime
```

## Motivation

### `php.ini`

In a project, it may be necessary to set certain `php.ini` settings for the project to function correctly. An example of this could be the time zone, as PHP does not use the system time zone, but sets its own.

These settings can be made in the `php.ini` file. On Debian-based systems, the PHP configurations are located in a directory such as `/etc/php/8.3/`. There is a separate directory for each PHP minor version.

If the settings are made under this directory, it should be noted that after a PHP Minor update the settings are transferred to the new configuration directory. This can be difficult if individual settings have been made in different files and it is no longer possible to recognize which settings have been made.

On Debian systems, the configurations for `fpm` and `cli` are also separated. They are located under the directories `/etc/php/8.3/fpm` and `/etc/php/8.3/cli`. A `bin/console` command is also provided for Symfony projects. Here it may be necessary that the configurations for `cli` and `fpm` are identical and it must be noted that the configuration must be carried out twice. Here it can be difficult to synchronize the configurations.

To avoid these problems, the `atoolo/runtime` package can be used to store ini settings in the project, which are then set at runtime. This ensures that the settings are always correct and are not forgotten.

### Process user

If the message bus system is used for Symfony projects, there are workers that wait for messages. These workers are separate processes that also write files, depending on the use case. It may be necessary for the worker process to be executed with a specific user so that the files can also be read by other processes, such as the `fpm` process. The same applies to processes that are executed via the console. For example, the `bin/console` command in Symfony projects. Here, too, it should be possible to ensure that the process is executed with a specific user.

The `atoolo/runtime` package can also be used for this. It can define users for the project and validate that the processes are executed with the correct user.

### umask

If different system users need to have access to files, this can be solved in such a way that the users are in a common group. It must then be ensured that the files also have read and write permissions for the group. This can be achieved by setting the umask so that the files can also be read and written for the group. In this case, the umask would have to be set to `0002`.

The `atoolo/runtime` package can also be used for this. An umask can be defined for the project, which is then set at runtime so that all new files created by PHP have the corresponding rights.

### HTTP client via proxy

If an HTTP client is used in the project, it may be necessary to use a proxy.

On Linux systems, the proxy to be used is often set as an environment variable in the `/etc/environment` file. However, this file is not taken into account by FPM, for example. The [Worker processes](../../operate/worker.md) started by Supervisor do not take this file into account either.

One possibility would be to configure the individual services in the `systemd` configuration via `EnvironmentFile`. However, this will not survive a PHP-FPM update to a new PHP minor version, for example, as the configuration file for Debian systems is `/etc/systemd/system/multi-user.target.wants/php8.3-fpm.service`. It is easy to forget to adjust the configuration after an update.

The `atoolo/runtime` package therefore offers the option of defining an environment file in the project, which is then read in with every request and console execution. This ensures that, for example, the proxy settings are always correct.

## Usage

The necessary configurations for the project are stored in the `composer.json` file. The `extra` area is used for this. The settings for the runtime of the project can be stored below `atoolo.runtime`.

`composer.json`

```json
{
  "extra": {
    "atoolo": {
      "runtime": {
        ...
      }
    }
  }
}
```

The configurations are read from all dependencies and the project.

Changes to the Atoolo runtime configuration do not take effect immediately. A `composer dump-autoload` must be executed for the changes to take effect. See also [Functionality](#functionality).

As the settings are made at runtime, the settings are reset with every request or console executions. Errors that occur due to incorrect configurations or failed validation affect all requests and console executions.

The configuration can also be carried out via `composer config ...`, for example.

Example for setting the configuration via `composer config`:

```sh
composer config --json extra.atoolo.runtime \
'{'\
'    "env": {'\
'        "file": "/etc/environment"'\
'    },'\
'    "ini": {'\
'        "set": {'\
'            "date.timezone": "Europe/Berlin"'\
'        }'\
'    },'\
'    "umask": "0002",'\
'    "users": ['\
'        "www-data",'\
'        "{SCRIPT_OWNER}"'\
'    ]'\
'}'
composer dump-autoload
```

### `ini.set`

The `php.ini` settings can be stored in the `ini.set` section. The name of the `php.ini` parameter is used as the key and the value as the value.

Example for setting the time zone:
`composer.json`

```json
{
  "extra": {
    "atoolo": {
      "runtime": {
        "ini": {
          "set": {
            "date.timezone": "Europe/Berlin"
          }
        }
      }
    }
  }
}
```

If the same keys with different values are set via the dependent packages and the project, the execution is aborted and an error message is issued.

### `users`

Nutzer können in der `users` Sektion als Array angegeben werden. Es wird bei jedem Request oder console Ausführung geprüft, ob der aktuelle Prozess mit einem der Nutzer ausgeführt wird. Ist dies nicht der Fall, wird ein Fehler ausgegeben und der prozess abgebochen.

Es existert noch ein Platzhalter `{SCRIPT_OWNER}`, der verwendet werden kann, wenn geprüft werden soll, ob der Nutzer des Prozesses identisch mit dem Owner des aktuell ausgeführten Scriptes ist. Das Skript ist in Symfony-Projekten in der Regel `public/index.php` für Requests und `bin/console` für console Ausführungen.

Durch diesen Platzhalter ist der Nutzer z.B. auch in der Entwicklungsumgebung valide, wenn der Ausführende Nutzer identsch mit dem Nutzer ist über das das Projekt ausgescheckt wurde.

Example for setting users:
`composer.json`

```json
{
  "extra": {
    "atoolo": {
      "runtime": {
        "users": ["www-data", "SCRIPT_OWNER"]
      }
    }
  }
}
```

### `umask`

The umask can be set in the `umask` section. The value is a string that is converted to an octal number. This ensures that the file permissions are set correctly for all requests and console executions.

```json
{
  "extra": {
    "atoolo": {
      "runtime": {
        "umask": "0002"
      }
    }
  }
}
```

### `env.file`

This can be used to specify an environment file such as `/etc/environment`. This is read in with every request and console execution. The values are saved in `$_ENV` and `$_SERVER`. Existing values are not overwritten.

```json
{
  "extra": {
    "atoolo": {
      "runtime": {
        "env": {
          "file": "/etc/environment"
        }
      }
    }
  }
}
```

If the same Variable with different values are set via the dependent packages and the project, the execution is aborted and an error message is issued.

## Functionality

The `atoolo/runtime` package is a Composer plugin that is executed before the `autoload` process. The configurations are read from all dependencies and the project. All settings are determined and a file `vendor/atoolo_runtime.php` is created. This file is automatically included in the `autoload` configuration of `composer.json`. See also [Composer Autoloading Files](https://getcomposer.org/doc/04-schema.md#files){:target="\_blank"}.

`composer.json`

```json
{
  "autoload": {
    "files": ["vendor/atoolo_runtime.php"]
  }
}
```

The `atoolo/runtime` is executed before the actual project is executed.

However, this also means that changes to the Atoolo runtime configuration do not take effect immediately. A `composer dump-autoload` must be executed for the changes to take effect.

## Extensions

### RuntimeExecutable

The `atoolo/runtime` package can be extended with additional functionality. For this purpose, the interface `Atoolo\Runtime\Executor\RuntimeExecutor` is available. This interface must be implemented and the implementation must be registered in the project.

```php

declare(strict_types=1);

namespace Example;

use Atoolo\Runtime\Executor\RuntimeExecutor;

class MyExecutor implements RuntimeExecutor
{
    /**
     * @param RuntimeOptions $options
     */
    public function execute(string $projectDir, array $options): void
    {
      foreach ($options as $package => $packageOptions) {
        if (!isset($packageOptions['myoptions'])) {
          continue;
        }
        // Do something
      }
    }
}
```

The executor must be registered in `composer.json` for it to be executed.

`composer.json`

```json
"extra": {
    "atoolo" : {
        "runtime" : {
            "executor" : [
                "Example\\MyExecutor"
            ]
        }
    }
}
```

### Runtime class

The `atoolo/runtime` package can be extended with additional functionality. For this purpose, the class `Atoolo\Runtime\Runtime` is available. This class must be extended and the implementation must be registered in the project.

```php

declare(strict_types=1);

namespace Example;

use Atoolo\Runtime\AtooloRuntime;

class MyAtooloRuntime extends AtooloRuntime
{
    public function run(): void
    {
        parent::run();
        // Do something
    }
}
```

For the class to be executed, it must be registered in `composer.json`.

```json
"extra": {
    "atoolo" : {
        "runtime" : {
            "class" : "Example\\MyAtooloRuntime"
        }
    }
}
```

### Runtime template

Atoolo-Execution is executed via the file `vendor/atoolo_runtime.php`. See also [Functionality](#functionality). This file is created via a [Template](https://github.com/sitepark/atoolo-runtime/blob/main/src/Composer/atoolo_runtime.template). The template can be overwritten to implement additional functionalities.

The template can be stored in the project for this purpose. The path to the template must be specified in `composer.json`.

`composer.json`

```json
"extra": {
    "atoolo" : {
        "runtime" : {
            "template" : "src/my_atoolo_runtime.template"
        }
    }
}
```
