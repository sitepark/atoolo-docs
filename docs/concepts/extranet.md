# Extranet

The exranet is a special operating module in which all requests are initially protected. Only authenticated users can access the resources. The only exceptions to this are requests for login, registration and password recovery.

Login takes place via the [Web-Account](web-account.md). If a user is logged in, the system behaves as in the normal operating module.

To use the extranet module, the following steps are necessary:

- All requests to public [media](resource-channel.md#media) must also not be delivered directly by the web server, but must be delivered via PHP/Symfony.
- The environment variable `SITE_MODE=extranet` must be set. Possibly via the virtual host configuration of the web server (`SetEnv SITE_MODE extranet`).
- The [`atoolo/extranet`](../develop/bundles/extranet.md) bundle must be installed.
