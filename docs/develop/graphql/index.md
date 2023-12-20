# GraphQL API

[GraphQL](https://graphql.org/) is a data query and manipulation language developed by Facebook. It allows applications to request precisely the data they need, avoiding over-fetching of information. GraphQL offers a flexible and efficient way to access APIs, granting clients control over data retrieval and enabling the bundling of multiple queries into a single request. This makes GraphQL particularly appealing for modern web applications and mobile apps.

## Work with GraphQL

If you are new to the GraphQL API, see [Getting Started with the GraphQL API](getting-started.md).

You can view the available resources in the GraphQL API reference. The reference is automatically generated from the GitLab GraphQL schema and written to a Markdown file.

The GraphQL API endpoint is located at `/graphql`.

The [GraphQL Schema Language Cheat Sheet](https://raw.githubusercontent.com/sogko/graphql-shorthand-notation-cheat-sheet/master/graphql-shorthand-notation-cheat-sheet.png) is also helpful.

## GraphiQL

Explore the GraphQL API with the interactive [GraphiQL Explorer](getting-started.md#graphiql), which would be accessible at the fictitious endpoint `www.example.com` via the following URL.

`https://www.example.com/graphiql`

## GraphQL API reference

The documentation of the GraphQL API resources is automatically generated based on the GraphQL schema and varies depending on the extensions installed in the IES. Therefore we refer to the interactive GraphiQL explorer which contains the API documentation.

## Breaking changes

The GraphQL API is [versionless](https://graphql.org/learn/best-practices/#versioning) and changes to the API are primarily backward-compatible.

Should the GraphQL API change in a way that is not backward compatible, these changes are called "Breaking Changes" and may involve removing or renaming fields, arguments, or other parts of the schema. When a Breaking Change is created, there will be a transition period where the old from will continue to be supported and marked deprecated. Until a time when the parts marked as deprecated are removed.
