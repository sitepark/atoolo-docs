# Extranet Bundle

Secures GraphQL and controller requests against unauthorized access.

See also: [Extranet](../../concepts/extranet.md)

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-extranet-bundle](https://github.com/sitepark/atoolo-extranet-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/extranet-bundle
```

Diese Bundle setzt Zugriffsregeln für alle GraphQL-Root-Resolver und Controller, die keinen eigenen Zugriffschutz definieren.

## Access-Control

### GraphQL-Root-Resolver

The [overblog/GraphQLBundle](https://github.com/overblog/GraphQLBundle) offers the option of defining access protection for the GraphQL root resolvers. See [Expression Language](https://github.com/overblog/GraphQLBundle/blob/master/docs/definitions/expression-language.md)

If no access rules are defined for a root resolver, the access protection of the extranet bundle takes effect. This checks whether the user is authenticated. If this is not the case, an error message is returned.

To enable access for unauthenticated users, the access rules of the root resolver can be defined accordingly. For example, a PHP attribute `GQL\Access('true')` can be used for this purpose:

```php
use Overblog\GraphQLBundle\Annotation as GQL;

#[GQL\Provider]
class Authentication

    #[GQL\Mutation(name: 'webAccountAuthenticationWithPassword', type: 'AuthenticationResult!')]
    #[GQL\Access('true')] // Allow this even in extranet scenarios without authorization
    public function authenticationWithPassword(
        string $username,
        string $password,
        bool $setJwtCookie,
    ): AuthenticationResult {
      // ...
    }
}
```

As soon as access rules are defined for a root resolver (query or mutation), the access protection of the extranet bundle no longer applies.

### Controller

The access control of the extranet bundle is also used for controllers if no separate access controls have been defined. The system checks whether the user is authenticated. If this is not the case, an error message is returned.

To enable access to a controller in the extranet module as well, the access controls of the controller can be defined accordingly. For example, a PHP attribute `#[IsGranted('PUBLIC_ACCESS')]` can be used for this purpose:

```php
use Symfony\Component\Security\Http\Attribute\IsGranted;

final class WebPageController extends AbstractController
{
    // Access is verified internally by the controller, but should not be globally restricted for extranet scenarios
    #[IsGranted('PUBLIC_ACCESS')]
    public function processResource(string $absolutePath): Response
    {
        // ...
    }
}
```
