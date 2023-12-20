# Search

The GraphQL query `search` can be used to search for resources. The aim of this GraphQL query is to fulfill the requirements for a search within the website. The focus here is on full-text searches, filters and facets.

## Search in a index

The search is performed using a full-text index. The CMS IES takes care of filling and updating the index. There is a separate index for each publication channel. For translated publication channels, there is a separate index for each language.

For each query via `selectResources`, the index to be searched must be specified via the input parameter `index`.

## Full text search

To find resources using a full-text search, the text is specified using the input parameter `text`.
The index is searched for the text and the corresponding hits are returned. The search is performed word by word. If several words (separated by spaces) are entered, an AND search is carried out in the standard case and the hits must contain both words. An OR search can also be carried out. To do this, the input parameter `queryDefaultOperator` must be specified with `OR`:

```graphql
  search(input: {
    index:"[client-anchor]-www"
    text: "cacao coffee "
    queryDefaultOperator: OR
  }) {
    ...
  }
```

Example:

```graphql
{
  search(input: { index: "[client-anchor]-www", text: "chocolate" }) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

The results are sorted by relevance if no other sorting criterion has been specified.

## Search results

The search results can be output using the [`SearchResult`](../reference.md#searchresult) type. In this case, `results` returns a list of [`Resource`](../reference.md#resource) objects. This can be used to query further data. See also:

- [Resolve navigation hierarchy](resolve-navigation-hierarchy.md)
- [Resolve teaser](resolve-teaser.md)

## Advanced search

Additional input parameters are available for extended search functionalities, which can be used with the search. These are described on the following pages.

- [Filtered search](filtered-search.md)
- [Faceted search](faceted-search.md)
- [Resolve teaser](resolve-teaser.md)
- [Resolve navigation hierarchy](resolve-navigation-hierarchy.md)

## TODO

- Sorting
- Date-filter
- Spell Checking
- Error handling
- Spatial Search
