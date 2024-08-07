# CityGov Bundle

CityGov is a product of Sitepark. The main areas of application of CityGov are the Internet presences of municipalities and district administrations as well as their employee portals on the intranet.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-citygov-bundle](https://github.com/sitepark/atoolo-citygov-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/citygov-bundle
```

## Extended indexing

The bundle contains [Document Enricher](../bundles/search/index.md#custom-document-enricher), which extends the full-text index for the search with CityGov-specific fields. This allows CityGov-specific searches to be created.
