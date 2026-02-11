# Suggest

A "suggest search" is a search function that automatically displays suggestions or auto-completions to users as they enter search queries.

A suggest search can be carried out as follows.

```graphql
query {
  suggest(input: { text: "work" }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```

The suggestions that would lead to hits are returned as a result. `term` contains the suggested term, `hits` returns the number of times the term is contained in the index. This is **not** the number of search results that would be expected from a search with the term.

```json
{
  "data": {
    "suggest": {
      "suggestions": [
        {
          "term": "work",
          "hits": 32
        },
        {
          "term": "workshop",
          "hits": 7
        },
        {
          "term": "working",
          "hits": 5
        },
        ...
      ]
    }
  }
}
```

### Filters

The same [filters](filtered-search.md) can be specified for the suggest search as for a [search](index.md#). The suggest is usually used together with a [full-text search](index.md#full-text-search). In this case, the filters for the search and the suggest should always be the same. This ensures that the suggestions only return the words that lead to hits for the search.

```graphql
query {
  suggest(input: { text: "holid", filter: [{ groups: ["1195"] }] }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```

### Minimal hits count

The parameter `minHitCount` controls the minimum amount of hits a suggestion must have in order to be part of the result. By default, it is set to `0`.

Suggestions with 0 hits can occur when filters are applied to the query. While a term may exist in the index, the specific filter constraints might exclude 
all documents containing that term, resulting in a suggestion that leads to no actual hits.

Often, you want to set the `minHitCount` to 1 in order to exclude all suggestions that wouldn't lead to a search result anyway.

```graphql
query {
  suggest(input: { text: "holid", minHitCount: 1 }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```