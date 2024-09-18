# GraphQL Search Bundle

The GraphQL Search Bundle uses the functionalities of the [Search bundle](../bundles/search/index.md) and extends the GraphQL interface with the ability to perform searches.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-graphql-search-bundle](https://github.com/sitepark/atoolo-graphql-search-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/graphql-search-bundle
```

## Teaser Customization

### Teaser-Type

To make a new teaser available, a class must be created that implements the interface `Teaser`.

```php
class NewsTeaser extends Teaser
{
    public function __construct(
        ?Link $link,
        public readonly ?string $headline,
        public readonly ?string $text,
        public readonly Resource $resource
    ) {
        parent::__construct($link);
    }
}
```

### Teaser-Factory

A teaser factory must implement the interface `TeaserFactory`. The factory is used to create a teaser object from a resource object.

Creates a teaser object with the basic data of a teaser, which can be derived from the resource without any effort.

For the factory, the method `TeaserFactory::create(Resource $resource): Teaser` must be implemented.

```php
class NewsTeaserFactory implements TeaserFactory
{
    public function __construct(
        private readonly LinkFactory $linkFactory,
    ) {
    }

     public function create(Resource $resource): Teaser
    {
        $link = $this->linkFactory->create(
            $resource,
        );

        $headline = $resource->data->getString(
            'base.teaser.headline',
            $resource->name,
        );
        $text = $resource->data->getString('base.teaser.text');

        return new NewsTeaser(
            $link,
            $headline,
            $text === '' ? null : $text,
            $resource,
        );
    }
}
```

More complex determinations should be made using the teaser resolver. This can provide a method for individual fields, which is only executed if the field is requested in the GraphQL query.

A factory can be defined as a Symfony service.

```yaml
services:
  atoolo_graphql_search.resolver.news_teaser_factory:
    class: 'Atoolo\GraphQL\Search\Resolver\NewsTeaserFactory'
    arguments:
      - "@atoolo_graphql_search.resolver.url_rewriter"
    tags:
      - { name: "atoolo_graphql_search.teaser_factory", objectType: "news" }
```

Tagging the service with `atoolo_graphql_search.teaser_factory` registers it as a teaser factory. The `objectType` parameter specifies the object type for which the factory is to be used.

### Teaser-Resolver

A teaser resolver is a service that implements the interface `TeaserResolver`. The resolver is used to determine the data of a teaser that cannot be derived directly from the resource and therefore requires a more complex determination. The resolver can make a method available for individual fields, which is only executed if the field is requested in the GraphQL query.

A teaser resolver can have getter methods that provide the data for the individual fields of the teaser. These methods must have a specific signature in order to be called by the GraphQL query.

The first argument of the method is the teaser for which the data is to be determined. This has previously been created by the corresponding teaser factory.

The second argument is optional and is only necessary if the GraphQL field [variables](https://graphql.org/learn/queries/#variables){:target="\_blank"} is provided.

Here is an example of a method without variables:

```php
class NewsTeaserResolver implements Resolver
{
    public function __construct(
        private readonly ResourceDateTimeResolver $dateResolver,
    ) {}

    public function getDate(
        NewsTeaser $teaser,
    ): ?DateTime {
        return $this->dateResolver->getDate($teaser->resource);
    }
}
```

Here is an example of a method with variables:

```php
use Overblog\GraphQLBundle\Definition\ArgumentInterface;

class NewsTeaserResolver implements Resolver
{
    public function __construct(
        private readonly ResourceAssetResolver $assetResolver,
    ) {}

    public function getAsset(
        NewsTeaser $teaser,
        ArgumentInterface $args,
    ): ?Asset {
        return $this->assetResolver->getAsset($teaser->resource, $args);
    }
}
```

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
  atoolo_graphql_search.resolver.url_rewriter:
    class: Atoolo\GraphQL\Search\Resolver\DoNothingUrlRewriter
```

However, this can be replaced by a separate URL rewriter if necessary.
