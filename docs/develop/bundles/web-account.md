# WebAccount Bundle

The Web Account Bundle provides support for user registration and authentication directly on the website. It enables personalized features for registered users, such as commenting, managing personal event entries (with appropriate permissions), and other user-specific functionality.

This bundle integrates seamlessly with the Sitepark CMS and follows Symfony best practices for security, extensibility, and modularity.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-web-account-bundle](https://github.com/sitepark/atoolo-web-account-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/web-account-bundle
```

## Configuration

The bundle can be configured in `config/packages/atoolo_web_account.yaml`. All configuration parameters are optional and have sensible default values.

```yaml
atoolo_web_account:
  # Time-to-live for authentication tokens in seconds (default: 30 days)
  # Minimum: 3600 (1 hour)
  token_ttl: 2592000

  # Time-to-live for registration tokens in seconds (default: 2 hours)
  # Minimum: 600 (10 minutes)
  registration_token_ttl: 7200

  # Time-to-live for password reset tokens in seconds (default: 2 hours)
  # Minimum: 600 (10 minutes)
  password_reset_token_ttl: 7200

  # Entry point URL for unauthenticated users (default: '/account')
  # Users trying to access protected resources will be redirected here
  unauthorized_entry_point: "/account"
```

### Configuration Parameters

- **`token_ttl`**: Duration in seconds for which authentication tokens remain valid. This determines how long users stay logged in. Default is 2,592,000 seconds (30 days), minimum is 3,600 seconds (1 hour).

- **`registration_token_ttl`**: Duration in seconds for which registration confirmation tokens are valid. After this time expires, users must request a new registration link. Default is 7,200 seconds (2 hours), minimum is 600 seconds (10 minutes).

- **`password_reset_token_ttl`**: Duration in seconds for which password reset tokens remain valid. After expiration, users must request a new password reset. Default is 7,200 seconds (2 hours), minimum is 600 seconds (10 minutes).

- **`unauthorized_entry_point`**: The URL path where unauthenticated users are redirected when they attempt to access protected resources. This should typically point to your login page. Default is `/account`.

## GraphQL API

The Web Account Bundle provides a GraphQL API for user authentication. This allows for flexible integration with frontend applications.

See also [GraphQL API](../graphql/web-account/index.md)

## Symfony Security Integration

The WebAccount Bundle integrates with Symfony's security system to manage user authorization.

The following components are provided:

- `atoolo_web_account.user_provider`: [Symfony Security User Provider](https://symfony.com/doc/current/security/user_providers.html){:target="\_blank"}. WebAccount users are authenticated via the GrahQL interface and not the Symfony security system. The user provider can neither load nor update user data and is only used to avoid error messages from Symfony, as Symfony requires a user provider.
- `atoolo_web_account.authenticator`: [Symfony Security Custom Authenticator](https://symfony.com/doc/current/security/custom_authenticator.html){:target="\_blank"}. This reads the `WEB_ACCOUNT_TOKEN` cookie and authenticates the user if the token is valid.
- `atoolo_web_account.unauthorized_entry_point`: [Symfony Security Entry Point](https://symfony.com/doc/current/security/entry_point.html){:target="\_blank"}. This entry point is used to redirect unauthenticated users to a login page when they try to access protected resources.

Different roles are set depending on the user's authorizations. The role names are formed from the ID of the role in the CMS: `IES_ID_<role_id>`. If an anchor is assigned to the role in the CMS, the anchor is converted into a role notation. All letters are converted to capital letters, all separators are replaced by underscores. Example: `usrp.internetwebsite.protected` becomes `USRP_INTERNETWEBSITE_PROTECTED`. In addition, the role `WEB_ACCOUNT` is set for each authenticated user.

These roles can be used for access protection within the Symfony application. See also [Access Control (Authorization)](https://symfony.com/doc/current/security.html#access-control-authorization){:target="\_blank"}.

For security reasons, Symfony does not offer the option of adding the configuration directly when installing the bundle. Therefore, the configuration must be added manually in the file `config/packages/security.yaml`.

`config/packages/security.yaml`

```yaml
security:
  providers:
    web_account_users:
      id: atoolo_web_account.user_provider

    all_users:
      chain:
        providers: [..., "web_account_users"]

  firewalls:
    web_account:
      lazy: true
      provider: web_account_users
      custom_authenticators:
        - atoolo_web_account.authenticator
      entry_point: atoolo_web_account.unauthorized_entry_point
      stateless: false
```
