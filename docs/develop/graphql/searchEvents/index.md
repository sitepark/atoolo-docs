# Intro

The full-text index also supports sub-documents. For example, when searching for individual occurrences of an event, the "nested documents" feature can be used. During indexing, an event is stored as a single document in the index. But for recurring events, each occurrence is stored as a separate nested-document within the event document.

# EventSearch

The GraphQL query `searchEvents`, which is a variant of the [`search`](../search/) query, is used to retrieve these sub-documents. This means that the search results consist of individual event occurrences, and therefore multiple results may be returned for the same event.

## Example

```graphql
query {
  searchEvents (
    input: {
      text: "museum of art"
      queryDefaultOperator: AND
      filter: [
        { categories: ["1234"] }
      ]
    }
  ) {
    ...
  }
}
```

# Filters

Filters, that are based on dates, are applied to the individual sub-documents. Full-text search, on the other hand, filters out all sub-documents whose parent-document does not match the search query.

# Facets

Facets behave similarly. Facets that are based on dates are calculated from the sub-documents. Facets that are based on categories are also applied to the sub-documents, ensuring that the documents count for each facet matches the number of results returned when that facet is selected.
