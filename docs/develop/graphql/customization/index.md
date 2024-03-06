# Project-specific customizations

This section contains information about customizing the GraphQL API for your project. It includes information about customizing the schema, customizing the resolvers, and adding custom queries and mutations.

## Customizing the schema

The schema is the structure of the GraphQL API. It defines the types, queries, and mutations that are available to clients. You can customize the schema by adding new types, queries, and mutations, or by modifying existing ones.

### Add custom teaser

For customer-specific object types, it is sometimes necessary to create your own teaser types. GraphQL schema can then be extended for this purpose.

First, the new teaser type must be entered in the GraphQL configuration. To do this, the file `config/packages/graphql.yml` is adapted.

The configuration file should look like this:

`config/packages/graphql.yml`

```yaml
overblog_graphql:
  definitions:
    schema:
      query: RootQuery
      mutation: RootMutation
      types: [CustomTeaser] # (1)
    mappings:
      types:
        - types: [yaml, graphql]
          dir: "%kernel.project_dir%/vendor/atoolo/graphql-search-bundle/src/Resources/ chema/defaults"
          suffix: ~
        - types: [yaml, graphql] # (2)
          dir: "%kernel.project_dir%/config/graphql/types"
          suffix: ~
```

1. :material-information-outline: The new teaser types are entered here.
2. :material-information-outline: The configuration directory in which the schema for the teaser is stored is specified here.

There are various ways to define the schema. See also [here](https://github.com/overblog/GraphQLBundle/blob/master/docs/definitions/type-system/index.md). For example, a GraphQL schema file can be created directly in which the schema is defined. This can look like this, for example:

`config/graphql/types/schema.types.graphql`

```graphql
type CustomTeaser implements Teaser {
  customField: String
}
```

To ensure that the `CustomTeaser` is also used with a corresponding object type, a `TeaserResolver` must be created. This can then look as follows:

`src/GraphQL/Resolver/CustomTeaserResolver.php`

```php
use Atoolo\GraphQL\Search\Resolver\TeaserResolver;
use Atoolo\GraphQL\Search\Types\Teaser;
use Atoolo\Resource\Resource;
use App\GraphQL\Type\CustomTeaser;

class CustomTeaserResolver implements TeaserResolver
{
    public function accept(Resource $resource): bool
    {
        return $resource->getObjectType() === 'customObjectType';
    }

    public function resolve(Resource $resource): Teaser
    {
        return new CustomTeaser(
          // ... custom fields
        );
    }
}
```

This still has to be registered as a service:

`config/services.yaml`

```yaml
services:
  App\GraphQL\Resolver\CustomTeaserResolver:
    tags:
      - { name: "atoolo.graphql.teaserResolver", priority: 5 }
```

The values of the teaser can also be returned for individual fields via resolver methods. This can be useful, for example, if the determination is complex and should only be executed if the field is actually queried.

The `Resolver` interface must also be implemented for this:

```php
use Atoolo\GraphQL\Search\Resolver\Resolver;
use Atoolo\GraphQL\Search\Resolver\TeaserResolver;
use Atoolo\GraphQL\Search\Types\Teaser;
use Atoolo\Resource\Resource;
use App\GraphQL\Type\CustomTeaser;

class CustomTeaserResolver implements TeaserResolver, Resolver
{
    public function accept(Resource $resource): bool
    {
        return $resource->getObjectType() === 'customObjectType';
    }

    public function resolve(Resource $resource): Teaser
    {
        return new CustomTeaser(
          // ... custom fields
        );
    }

    public function getSomeField(CustomTeaser $teaser): string
    {
        return 'some value';
    }
}
```

Additional tagging of the service is necessary here:

`config/services.yaml`

```yaml
services:
  App\GraphQL\Resolver\CustomTeaserResolver:
    tags:
      - { name: "atoolo.graphql.teaserResolver", priority: 5 }
      - { name: "atoolo.graphql.resolver", priority: 10 } # (1)
```

1. :material-information-outline: Additional tagging

### Extending base teaser type

You can extend the base `Teaser` type to add custom fields to the teaser type. Changes to the basic teaser type affect all teaser types that extend the 'Teaser' type.

To make it possible to extend the basic teaser types, the basic teasers are defined as decorators. Therefore, the configuration in the customer project normally looks like this:

```yaml
overblog_graphql:
  definitions:
    mappings:
      types:
        - types: [yaml, graphql]
          dir: "%kernel.project_dir%/vendor/atoolo/graphql-search-bundle/src/Resources/ chema/defaults"
          suffix: ~
```

This configuration is used to define the default teaser types that the decorators use. See also the documentation for [Inheritance](https://github.com/overblog/GraphQLBundle/blob/master/docs/definitions/type-inheritance.md) and the **Decorators** section there.

Normally, the definition of the article teaser looks like this, for example:
`vendor/atoolo/graphql-search-bundle/src/Resources/schema/defaults/ArticleTeaser.defaulttype.yaml`

```yaml
ArticleTeaser:
  type: "object"
  inherits: [ArticleTeaserDecorator]
```

If one or more teasers are to be customized, the default types can no longer be used. All files from `vendor/atoolo/graphql-search-bundle/src/Resources/schema/defaults/ArticleTeaser.defaulttype.yaml` must be copied to `config/graphql/types/` and the desired teasers adapted.

It is also necessary to change the configuration in `config/packages/graphql.yml`:

```yaml
overblog_graphql:
  definitions:
    mappings:
      types:
        # - types: [yaml, graphql]
        #   dir: "%kernel.project_dir%/vendor/atoolo/graphql-search-bundle/src/Resources/ chema/defaults"
        #   suffix: ~
        - types: [yaml, graphql]
          dir: "%kernel.project_dir%/config/graphql/types"
          suffix: ~
```

A new field can now be added to the basic teaser, for example:

`config/graphql/types/Teaser.defaulttype.yaml`

```yaml
Teaser:
  type: interface
  inherits: [TeaserDecorator]
  config:
    fields:
      customfield:
        type: "String"
        description: General Custom-Field
```

To be able to return the value of the new field, a `Resolver` must be created. This can then look as follows:

`src/GraphQL/Resolver/TeaserResolver.php`

```php
use Atoolo\GraphQL\Search\Resolver\Resolver;
use Atoolo\GraphQL\Search\Types\ArticleTeaser;
use Atoolo\GraphQL\Search\Types\MediaTeaser;

class ExtendedTeaserResolver implements Resolver
{
    public function getCustomfield(
        ArticleTeaser|MediaTeaser $teaser,
    ): ?string {
        return '';
    }
}
```

All teaser types that have the new field must be listed in the method signature via a union type. In this case, these are `ArticleTeaser` and `MediaTeaser`.

This still has to be registered as a service:

`config/services.yaml`

```yaml
services:
  App\GraphQL\Resolver\ExtendedTeaserResolver:
    tags:
      - { name: "atoolo.graphql.resolver", priority: 10 }
```
