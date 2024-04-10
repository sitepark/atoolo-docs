# Suggest

A "suggest search" is a search function that automatically displays suggestions or auto-completions to users as they enter search queries.

A suggest search can be carried out as follows.

```graphql
{
  suggest(input: { text: "work" }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```

As a result, the suggestions that would lead to hits are returned. The number of hits is indicated with .

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

The same [filters](filtered-search.md) can be specified for the suggest search as for a [search](index.md#). The suggest is usually used together with a [full-text search](index.md#full-text-search). In this case, the filters for the search and the suggest should always be the same. This ensures that the suggestions only return the words that lead to hits for the search.

```graphql
{
  suggest(input: { text: "holid", filter: [{ groups: ["1195"] }] }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```
