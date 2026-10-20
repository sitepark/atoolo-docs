# Translation API Bundle

Delivers the translations of the Symfony translator as JSON over HTTP. It is
used by

- **the frontend**, e.g. with [i18next](https://www.i18next.com/){:target="\_blank"},
  to load labels that are maintained in Symfony translation files or in the CMS
- **the IES**, to read the translations of a website, e.g. as default values in
  the input template for translation overrides

The endpoints and how to use them are described in the
[Translation API](../translation/index.md). This page covers the installation
and configuration of the bundle.

The bundle only delivers existing translations. It does not create or
translate them — for automatic translations see the
[Translator Bundle](translator.md) (machine translation).

## Sources

The sources can be accessed via the GitHub project [https://github.com/sitepark/atoolo-translation-api-bundle](https://github.com/sitepark/atoolo-translation-api-bundle){:target="\_blank"}.

## Installation

```sh
composer require atoolo/translation-api-bundle
```

The bundle has to be registered in `config/bundles.php` and its routes have
to be imported:

```php
return [
    // ...
    Atoolo\TranslationApi\AtooloTranslationApiBundle::class => ['all' => true],
];
```

`config/routes/translation_api.yaml`

```yaml
atoolo_translation_api:
  resource: '@AtooloTranslationApiBundle/config/routes.yaml'
```

## Configuration

`config/packages/atoolo_translation_api.yaml`

```yaml
atoolo_translation_api:
  domains: [frontend]
  locales: [de, en]
  full_access_roles: [ROLE_API, ROLE_ADMIN]
  cache_max_age: 300
```

| Option              | Description                                                                                                                                                       |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `domains`           | Domains that may be fetched without full access, with or without `+intl-icu` suffix. `'*'` exposes every domain. Empty (default): nothing is public.               |
| `locales`           | Locales that may be fetched without full access. Default: `framework.enabled_locales`. If both are empty, every well-formed locale is allowed.                     |
| `full_access_roles` | Roles (or voter attributes) of users that may fetch every domain and locale. One of them is sufficient. Empty (default): nobody has full access.                  |
| `cache_max_age`     | `max-age` of the `Cache-Control` header in seconds. Default: 300.                                                                                                  |

!!! warning

    Every message of an exposed domain is publicly readable. Never expose
    domains with internal texts. `domains: ['*']` exposes every domain the
    translator knows, including those of other bundles and every domain a
    future update adds.

## Access

Without full access only the domains listed in `domains` of the allowed
`locales` can be fetched; everything else responds with `404`. Users with one
of the `full_access_roles` can fetch and list every domain of every
well-formed locale. These responses are private, so that shared caches do not
store them.

With the [Security Bundle](security.md) the `api` firewall (`^/api`, JWT)
covers the endpoints. Clients get a token via `POST /api/login_check` and send
it as `Authorization: Bearer <token>`. The IES uses the user `api` with the
role `ROLE_API`, so `full_access_roles: [ROLE_API, ROLE_ADMIN]` gives the IES
access without an additional user.

## CORS

The bundle sets no CORS headers. They are configured in the application with
[`nelmio/cors-bundle`](https://github.com/nelmio/NelmioCorsBundle){:target="\_blank"},
e.g.:

```yaml
nelmio_cors:
  paths:
    '^/api/translations/':
      allow_origin: ['*']
      forced_allow_origin_value: '*'
      allow_methods: ['GET']
      allow_headers: ['Authorization']
```

## Sources of the messages

Without the parameter [`source`](../translation/index.md#parameter-source) the
messages come from the translator of the application. An application can
register further sources, e.g. a translator with the messages of one kind of
resources only. A source is a
`Symfony\Component\Translation\TranslatorBagInterface` service tagged with
`atoolo_translation_api.source`:

```yaml
App\Translation\MySource:
  tags:
    - { name: atoolo_translation_api.source, source: mine }
```

An unknown source responds with `404`. The bundle knows nothing about what a
source holds.
