# Seo Bundle

This bundle contains features for search engine optimization. Included are:

- Controller for providing the [Sitemap-XML](https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview){:target="\_blank"}

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-seo-bundle](https://github.com/sitepark/atoolo-seo-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/seo-bundle
```

## Sitemap-XML

The bundle provides a controller that generates a sitemap XML for the pages managed by the IES. The sitemap XML is provided under the URL `/sitemap.xml`. The number of entries in a sitemap XML is limited. The entries are therefore split across several requests. For this reason, the URL `/sitemap.xml` initially only provides an index with further references to the actual Sitemap XML files. See also [Large Sitemaps](https://developers.google.com/search/docs/crawling-indexing/sitemaps/large-sitemaps).

The IES can also be used to manage subordinate microsites for a site. Optionally, these microsites can also be delivered via their own domain. In this case, the microsite provides its own `robots.xml`. In this case, entries may have to be removed from the `sitemap.xml` of the main site. This is done via an additional parameter `siteExcludes=1124,2324` in the URL. Example: `/sitemap.xml?siteExcludes=1124,2324`. The site IDs of the microsites are transferred as the parameter value.

The `sitemap.xml` of the corresponding microsite may only contain the entries of the microsite. As the entries are determined via the search index and all entries are contained there, the entries must be filtered. This is done using the parameter `siteIncludes=1124` in the URL. Example: `/sitemap.xml?siteIncludes=1124`. The site ID of the microsite is passed as the parameter value.

| Routes                | Description                                           |
| --------------------- | ----------------------------------------------------- |
| `/sitemap.xml`        | Returns the sitemap index                             |
| `/sitemap-{page}.xml` | Returns the sitemap entries of the corresponding page |

### Multilingual site

If the site is operated in multiple languages (with automatic translation by the IES), the sitemap XML also contains the entries for the other languages. And also the references between the individual languages. See also [Localized Versions of your Pages](https://developers.google.com/search/docs/specialty/international/localized-versions)

### Use

If the bundle is installed, the two routes are available. The prerequisite is that the file `config/routes/seo.yaml` has also been created and the `config/bundles.php` was extended in the project via Flex. Otherwise, this must be done manually.

`config/bundles.php`

```php
<?php

return [
  // ...
  Atoolo\Seo\AtooloSeoBundle::class => ['all' => true],
];
```

`config/routes/seo.yaml`

```yaml
controller:
  resource: "@AtooloSeoBundle/Controller/"
  type: attribute
```
