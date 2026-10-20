# Translation API Bundle

Delivers the translations of the Symfony translator as JSON over HTTP. It is
used by

- **the frontend**, e.g. with [i18next](https://www.i18next.com/){:target="\_blank"},
  to load labels that are maintained in Symfony translation files or in the CMS
- **the IES**, to read the translations of a website, e.g. as default values in
  the input template for translation overrides

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

## Endpoints

| Endpoint                                              | Delivers                                                  |
| ----------------------------------------------------- | --------------------------------------------------------- |
| `GET /api/translations/{locale}/domains/{domain}`     | the messages of a domain                                  |
| `GET /api/translations/{locale}/domains`              | the domains of a locale                                   |
| `GET /api/translations/{locale}`                      | all domains of a locale with their messages              |

All endpoints accept an optional `.json` suffix and the query parameter
`source` (see [Sources of the messages](#sources-of-the-messages)).

### Messages of a domain

```
GET /api/translations/de/domains/frontend
```

```json
{
  "greeting": "Hallo",
  "cart": {
    "items": "{count, plural, one {# Artikel} other {# Artikel}}"
  }
}
```

- The dot separated keys become nested objects.
- The messages are delivered unchanged, i.e. in ICU message format for
  `+intl-icu` domains.
- The messages of the fallback locales are included, the more specific locale
  wins.
- The domain may be requested with or without `+intl-icu` suffix.
- The locale is matched ignoring case and `-`/`_` (`en-GB` finds `en_GB`).

### Domains of a locale

```
GET /api/translations/de/domains
```

```json
["frontend+intl-icu", "spinon+intl-icu"]
```

The domains with messages in the locale or one of its fallback locales,
named in full: with `+intl-icu` suffix if the domain contains ICU messages.
Each listed domain can be fetched as is.

### All domains of a locale

```
GET /api/translations/de
```

```json
{
  "frontend+intl-icu": { "greeting": "Hallo" },
  "spinon+intl-icu": { "skip_link": { "text": "Inhalt anspringen" } }
}
```

The listed domains together with their messages in one request.

## Access

Without full access only the domains listed in `domains` of the allowed
`locales` can be fetched; everything else responds with `404`. Users with one
of the `full_access_roles` can fetch and list every domain of every
well-formed locale.

With the [Security Bundle](security.md) the `api` firewall (`^/api`, JWT)
covers the endpoints. Clients get a token via `POST /api/login_check` and send
it as `Authorization: Bearer <token>`. The IES uses the user `api` with the
role `ROLE_API`, so `full_access_roles: [ROLE_API, ROLE_ADMIN]` gives the IES
access without an additional user.

## Caching and CORS

- Public responses have `Cache-Control: public, max-age=<cache_max_age>`,
  `Vary: Origin` and an `ETag`. A browser may reuse them for `cache_max_age`
  seconds.
- Responses that need full access and the domain lists are `private`.
- The bundle sets no CORS headers. They are configured in the application
  with [`nelmio/cors-bundle`](https://github.com/nelmio/NelmioCorsBundle){:target="\_blank"},
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

Without the parameter `source` the messages come from the translator of the
application. An application can register further sources, e.g. a translator
with the messages of one kind of resources only. A source is a
`Symfony\Component\Translation\TranslatorBagInterface` service tagged with
`atoolo_translation_api.source`:

```yaml
App\Translation\MySource:
  tags:
    - { name: atoolo_translation_api.source, source: mine }
```

An unknown source responds with `404`. The bundle knows nothing about what a
source holds.

## i18next

```ts
import i18n from 'i18next'
import ICU from 'i18next-icu'
import HttpBackend from 'i18next-http-backend'

i18n.use(ICU).use(HttpBackend).init({
  fallbackLng: 'en',
  ns: ['frontend'],
  defaultNS: 'frontend',
  backend: {
    loadPath: '/api/translations/{{lng}}/domains/{{ns}}',
  },
})
```

For `+intl-icu` domains i18next needs the ICU plugin `i18next-icu`. If the
application offers a source with only the changed messages (see
[Sources of the messages](#sources-of-the-messages)), a frontend that brings its
own labels can load just these by adding `?source=<name>` to the `loadPath` and
merge the result into its labels.
