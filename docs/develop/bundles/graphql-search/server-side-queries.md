# Server-side GraphQL queries

While the primary purpose of the `atoolo/graphql-search-bundle` is to expose a GraphQL API over HTTP for external clients (like a browser), it also includes features for executing queries directly on the server within your PHP application.

This allows you to reuse your existing GraphQL logic for internal application needs, avoiding the overhead of making an HTTP request to your own API.

## Config setup

Ensure that you have configured the `graphql_query_dirs` parameter in your `config/packages/atoolo_graphql.yaml` file (see [reference](config.md#configuration-reference)). This tells the bundle where to look for your GraphQL operation definitions.

## Defining a GraphQL operation

Inside of one of the configured graphql query directories, you can define any `.graphql` file as usual.

Example:

```graphql
# src/resources/graphql/queries/search.graphql
query exampleOperation($input: SearchInput!) {
  search(input: $input) {
    results {
      id
      name
      # ...
    }
  }
}
```

The operation name, `exampleOperation` in this case, is what you will use to reference this query in your PHP code. It has
to be unique in the scope of your application.

All operations defined in `.graphql` files will be loaded and passed to the `GraphQLQueryManager` service during the compilation of the symfony cache.

## Execute the query in PHP

You can execute the operation from any PHP service by using the `GraphQLQueryExecutor` service. You can inject this service via dependency injection and call its execute method.

Example:

```php


namespace App\Service;

use Atoolo\GraphQL\SearchBundle\Query\GraphQLQueryExecutor;

class MyService
{
    private GraphQLQueryExecutor $queryExecutor;

    public function __construct(
      private readonly GraphQLQueryExecutor $queryExecutor
    ){}

    public function performSearch(array $searchInput): array
    {
        // Define the variables for your GraphQL query
        $variables = [
            'input' => $searchInput,
        ];

        // Execute the query by referencing its operation name
        $result = $this->queryExecutor->execute('exampleOperation', $variables);

        $data = $result->getData();
        /*
          $data: [
            'search' => [
              'results' => [
                  ['id' => 1, 'name' => 'foo'],
                  ['id' => 2, 'name' => 'bar'],
                  ...
              ]
            ]
          ]
        */
    }
}

```
