---
status: draft
---

# Resolve navigation hierarchy

Root:

```graphql
{
  search(
    input: { index: "[client-anchor]-www", filter: [{ groups: ["1195"] }] }
  ) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        root {
          id
        }
      }
    }
  }
}
```

Parent:

```graphql
{
  search(
    input: { index: "[client-anchor]-www", filter: [{ groups: ["1195"] }] }
  ) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        parent {
          id
          navigation {
            parent {
              id
            }
          }
        }
      }
    }
  }
}
```

Children:

```graphql
{
  search(
    input: { index: "[client-anchor]-www", filter: [{ groups: ["1195"] }] }
  ) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        children {
          id
          teaser {
            url
          }
        }
      }
    }
  }
}
```

Path:

```graphql
{
  search(
    input: {
      index: "[client-anchor]-www"
      filter: [{ key: "musterseiten", groups: ["1195"] }]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        path {
          id
          location
          navigation {
            children {
              name
            }
          }
        }
      }
    }
  }
}
```
