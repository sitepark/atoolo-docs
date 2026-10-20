# Translation API

The Translation API delivers the translations of a website as JSON, e.g. for
[i18next](https://www.i18next.com/){:target="\_blank"} in the frontend. It is
provided by the [Translation API Bundle](../bundles/translation-api.md), whose
configuration decides which domains and locales are public.

## Endpoints

| Endpoint                                              | Delivers                                                  |
| ----------------------------------------------------- | --------------------------------------------------------- |
| `GET /api/translations/{locale}/domains/{domain}`     | the messages of a domain                                  |
| `GET /api/translations/{locale}/domains`              | the domains of a locale                                   |
| `GET /api/translations/{locale}`                      | all domains of a locale with their messages              |

All endpoints accept an optional `.json` suffix and the query parameter
[`source`](#parameter-source).

`locale`
: The locale, matched ignoring case and `-`/`_` (`en-GB` finds `en_GB`).

`domain`
: A translation domain, with or without `+intl-icu` suffix. A domain
  corresponds to an i18next namespace.

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
- With or without `+intl-icu` suffix, the ICU and the plain messages of the
  domain are delivered.

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

## Parameter `source`

```
GET /api/translations/de/domains/frontend?source=<name>
```

Without the parameter the messages come from the translator of the website.
A website can offer further sources, e.g. with the messages of one kind of
translation resources only. Which sources exist depends on the website; an
unknown source responds with `404`.

## Access

Without authentication only the public domains and locales of the website can
be fetched, everything else responds with `404`. Clients with full access
authenticate with a token (`POST /api/login_check`, then
`Authorization: Bearer <token>`) and can fetch and list every domain of every
well-formed locale.

A malformed locale responds with `404` as well. i18next does not retry on 4xx
responses.

## Caching

- Public responses have `Cache-Control: public, max-age=<seconds>`,
  `Vary: Origin` and an `ETag`; `If-None-Match` is answered with `304`. A
  browser may reuse a response for the configured time without asking again.
- Responses that need full access and the domain lists are `private`.

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
website offers a source with only the changed messages, a frontend that brings
its own labels can load just these by adding `?source=<name>` to the `loadPath`
and merge the result into its labels.
