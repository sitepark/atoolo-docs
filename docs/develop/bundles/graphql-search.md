---
status: draft
---

# GraphQL Search Bundle

The GraphQL Search Bundle uses the functionalities of the [Search component](../components/search/index.md) and extends the GraphQL interface with the ability to perform searches.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-graphql-search-bundle](https://github.com/sitepark/atoolo-graphql-search-bundle){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/graphql-search-bundle
```

## Teaser-Factory

A teaser factory must implement the interface `TeaserFactory`. The factory is used to create a teaser object from a resource object.

Creates a teaser object with the basic data of a teaser, which can be derived from the resource without any effort.

More complex determinations should be made using the teaser resolver. This can provide a method for individual fields, which is only executed if the field is requested in the GraphQL query.

A factory can be defined as a Symfony service.

```yaml
services:
  atoolo_graphql_search.resolver.newsTeaserFactory:
    class: 'Atoolo\GraphQL\Search\Resolver\NewsTeaserFactory'
    arguments:
      - "@atoolo_graphql_search.resolver.urlRewriter"
    tags:
      - { name: "atoolo_graphql_search.teaserFactory", objectType: "news" }
```

Tagging the service with `atoolo_graphql_search.teaserFactory` registers it as a teaser factory. The `objectType` parameter specifies the object type for which the factory is to be used.

## Teaser-Resolver

A teaser resolver is a service that implements the interface `TeaserResolver`. The resolver is used to determine the data of a teaser that cannot be derived directly from the resource and therefore requires a more complex determination. The resolver can make a method available for individual fields, which is only executed if the field is requested in the GraphQL query.

A resolver can be defined as a Symfony service.

```yaml
services:
  Atoolo\GraphQL\Search\Resolver\NewsTeaserResolver:
    arguments:
      - '@Atoolo\GraphQL\Search\Resolver\ArticleTeaserResolver'
    tags:
      - { name: "atoolo_graphql_search.resolver" }
```

In the above case, the `ArticleTeaserResolver` is still required in the constructor of the `NewsTeaserResolver`. This is passed as an argument.

By tagging the service with `atoolo_graphql_search.resolver`, it is registered as a teaser resolver.

## Url-Rewriter

The URL rewriter is a service that implements the interface `UrlRewriter`. The rewriter is used to rewrite URLs in the teaser object. URL rewriters are needed to influence the URL's that are returned in the teasers.

In the standard case, the `DoNothingUrlRewriter` is used, which returns the URLs unchanged.

```yaml
services:
  atoolo_graphql_search.resolver.urlRewriter:
    class: Atoolo\GraphQL\Search\Resolver\DoNothingUrlRewriter
```

However, this can be replaced by a separate URL rewriter if necessary.
