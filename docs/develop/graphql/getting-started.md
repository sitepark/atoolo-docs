---
status: draft
---

# Get started with GraphQL API.

This guide shows the integration and basic usage of the GraphQL API.

## Requirements

A Symfony 6.3 project with Symfony-Flex is required. In this project the GraphQL endpoint is set up.

## Install

For GraphQl integration the [`overblog/GraphQLBundle`](https://github.com/overblog/GraphQLBundle) Symfony bundle is used.

It is integrated via the [Symfony Flex installation](https://github.com/overblog/GraphQLBundle/blob/master/docs/index.md#symfony-flex-installation).

In the project directory:
```sh
composer require overblog/graphql-bundle
```

Install the GraphiQL interface:

```sh
composer require --dev overblog/graphiql-bundle
```

Atoolo uses PHP 8 attributes to configure the mappings and define the schema.

Change the graphql package configuration
```yaml
# config/packages/graphql.yaml
overblog_graphql:
  definitions:
    schema:
      query: RootQuery
    mappings:
      types:
        - type: attribute
          dir: "%kernel.project_dir%/src/Atoolo/GraphQL"
          suffix: ~
```

Your `RootQuery` class should look like this:

```php
<?php

declare(strict_types=1);

namespace Atoolo\GraphQL\Query;

use Overblog\GraphQLBundle\Annotation as GQL;

#[GQL\Type]
class RootQuery
{
    #[GQL\Field(name: 'something', type: 'String!')]
    public function getSomething(): string
    {
        return "Hello world!";
    }
}
```

Add `autoload` `psr-4` config to `composer.json`:

```json
    "autoload": {
        "psr-4": {
            "Atoolo\\": "src/Atoolo"
        }
    }
```

Change Path to `/graphql`

```yaml
# config/routes/graphql.yaml
    resource: "@OverblogGraphQLBundle/Resources/config/routing/graphql.yml"
    prefix : /graphql
```

Register `RootQuery` as Service

```yaml
#config/services.yaml
...
    Atoolo\GraphQL\Query\RootQuery:
        public: true
```

Clear Symfony-Cache
```sh
rm -rf var/cache
```

## Usage

### Commandline

You can run GraphQL queries in a curl query in the command line on your local computer. A GraphQL query can be issued as a POST request to /api/graphql with the query as the payload. You can authorize your query by generating a personal access token to use as the owner token.

With the fictitious endpoint `www.example.com`, the GraphQL endpoint can be reached at the following URL.

```sh
curl "https://www.example.com/graphql/" --fail \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"query" : "{ something }"}'
```

### GraphiQL

GraphiQL is an interactive development environment for GraphQL that allows developers to easily create, execute and test GraphQL queries. It provides a user-friendly interface with features such as automatic code completion and real-time query execution. GraphiQL helps developers explore API endpoints and develop and debug queries efficiently. It is a valuable tool for working with GraphQL APIs, streamlining the development process and improving query accuracy.

With the fictitious endpoint `www.example.com` the GraphiQL can be reached at the following URL.

`https://www.example.com/graphiql`

