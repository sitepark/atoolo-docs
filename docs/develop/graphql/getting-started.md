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

The Symfony Flex Recipes from Sitepark must be used to ensure that the configurations are created correctly.

To do this, the following entry must be added to `composer.json` of the Symfony project:

```sh
composer config extra.symfony.allow-contrib true
composer config --json extra.symfony.endpoint \
'["'\
'https://api.github.com/repos/sitepark/'\
'symfony-recipes/contents/index.json'\
'?ref=flex/main'\
'"]'
composer config --json --merge extra.symfony.endpoint \
'["flex://defaults"]'
```

The installation is then carried out via `composer require`.


```sh
composer require atoolo/graphql-search-bundle
```

Install the GraphiQL interface:

```sh
composer require --dev overblog/graphiql-bundle
```

## Usage

### Commandline

You can run GraphQL queries in a curl query in the command line on your local computer. A GraphQL query can be issued as a POST request to `/graphql with the query as the payload.

With the fictitious endpoint `www.example.com`, the GraphQL endpoint can be reached at the following URL.

```sh
curl "https://www.example.com/graphql/" --fail \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"query" : "{ ping }"}'
```

### TypeScript

The Apollo client can be used to use the GraphQL interface with TypeScript. See [TypeScript with Apollo Client](https://www.apollographql.com/docs/react/development-testing/static-typing/)

### GraphiQL

GraphiQL is an interactive development environment for GraphQL that allows developers to easily create, execute and test GraphQL queries. It provides a user-friendly interface with features such as automatic code completion and real-time query execution. GraphiQL helps developers explore API endpoints and develop and debug queries efficiently. It is a valuable tool for working with GraphQL APIs, streamlining the development process and improving query accuracy.

With the fictitious endpoint `www.example.com` the GraphiQL can be reached at the following URL.

`https://www.example.com/graphiql`

