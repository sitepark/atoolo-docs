# Getting started

This guide shows the integration and basic usage of the GraphQL API.

## Requirements

A Symfony 6.4 project with Symfony-Flex is required. In this project the GraphQL endpoint is set up.

## Install

For GraphQl integration the [`overblog/GraphQLBundle`](https://github.com/overblog/GraphQLBundle){:target="\_blank"} Symfony bundle is used.

It is integrated via the [Symfony Flex installation](https://github.com/overblog/GraphQLBundle/blob/master/docs/index.md#symfony-flex-installation){:target="\_blank"}.

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

## Usage

### Basics

To learn the basics of GraphQL, ["Introduction to GraphQL"](https://graphql.org/learn/){:target="\_blank"} is a good place to start.

### Commandline

You can run GraphQL queries in a curl query in the command line on your local computer. A GraphQL query can be issued as a POST request to `/graphql with the query as the payload.

With the fictitious endpoint `www.example.com`, the GraphQL endpoint can be reached at the following URL.

```sh
curl "https://www.example.com/api/graphql/" --fail \
    --header "Content-Type: application/json" \
    --request POST \
    --data '{"query" : "{ ping }"}'
```

### Clients

Because GraphQL is a communication pattern, there are many tools to help you get started working which support GraphQL in all sorts of languages.

See e.g. [here](https://graphql.org/community/tools-and-libraries/){:target="\_blank"}

#### Altair GraphQL Client

[Altair GraphQL Client](https://altairgraphql.dev/){:target="\_blank"} is a GraphQL client that allows you to interact with GraphQL servers. It provides a user-friendly interface for creating, executing, and debugging queries. Altair supports features such as automatic code completion, syntax highlighting, and real-time query execution. It is a valuable tool for working with GraphQL APIs, streamlining the development process, and improving query accuracy.

It is also available as a browser extension.

#### GraphiQL

[GraphiQL](https://github.com/graphql/graphiql){:target="\_blank"} is an interactive development environment for GraphQL that allows developers to easily create, execute and test GraphQL queries. It provides a user-friendly interface with features such as automatic code completion and real-time query execution. GraphiQL helps developers explore API endpoints and develop and debug queries efficiently. It is a valuable tool for working with GraphQL APIs, streamlining the development process and improving query accuracy.

GraphiQL can be installed as a desktop app, for example. See [GraphQL-Playground](https://github.com/graphql/graphql-playground){:target="\_blank"}.

With the fictitious endpoint `www.example.com` the GraphQL Playground needs the URL.

`https://www.example.com/api/graphql/`

The ending slash is necessary and must not be omitted.
