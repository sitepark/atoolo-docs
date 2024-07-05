# Runtime Check Bundle

Symfony bundle which contains tools that can be used to check whether the current runtime environment is set up as expected.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/runtime-check-bundle](https://github.com/sitepark/atoolo-runtime-check-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/runtime-check-bundle
```

## Motivation

The bundle is an addition to the [Runtime component](../components/runtime.md). Unlike the [Runtime component](../components/runtime.md), the checks are not carried out each time they are called, but must be triggered explicitly. This can be done via a command line command or via an HTTP request. The aim is to provide a possibility to check the project for its executability. It should support PHP updates by allowing the checks to be carried out before the new PHP version is activated.

Furthermore, the project or other bundles should be able to extend the checks. The checks are also intended to be executed regularly by a monitoring system.

## Usage

The use of the bundle is described under [Operate / Runtime check](../../operate/runtime-check.md).

## Custom Checks

The bundle provides an interface `Atoolo\Runtime\Check\Service\Checker\Checker`, which can be used to implement your own checks.

Here is an example for your own check:

```php
declare(strict_types=1);

namespace Example\Service\Checker;

use Atoolo\Runtime\Check\Service\Checker;
use Atoolo\Runtime\Check\Service\CheckStatus;

class MyChecker implements Checker
{
    public function getScope(): string
    {
        return "myscope";
    }

    public function check(): CheckStatus
    {

        $success = ... // check if the check is successful

        if (!$success) {
          $status = CheckStatus::createFailure();
          $status->addReport($this->getScope(), [
            'myfield' => 'myvalue'
            // any other data
          ]);
          $status->addMessage($this->getScope(), "My error message");
          return $status;
        }

        $status = CheckStatus::createSuccess();
        $status->addReport($this->getScope(), [
          'myfield' => 'myvalue'
          // any other data
        ]);

        return $status;
    }
}
```

If the check is successful, a status is created with `CheckStatus::createSuccess()`. If the check fails, the status is created with `CheckStatus::createFailure()`. Report data can be added in both cases. In the event of an error, at least one error message should be added with `$status->addMessage()`.

The scope is any name that is assigned to the check. The checks can be grouped via the scope.

The check must still be registered as a service:

`services.yaml`

```yaml
Example\Service\Checker\MyChecker:
  tags:
    - { name: "atoolo_runtime_check.checker" }
```
