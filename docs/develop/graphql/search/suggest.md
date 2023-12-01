---
status: draft
---

# Suggest

A "suggest search" is a search function that automatically displays suggestions or auto-completions to users as they enter search queries.

```graphql
{
  suggest(input: {
    index:"[client-anchor]-www"
    text: "holid"
    filter: [
      {groups:["1195"]}
    ]
  }) {
    queryTime
    suggestions {
      term
      hits
    }
  }
}
```
