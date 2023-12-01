---
status: draft
---

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
  search(input: {
    index:"[client-anchor]-www"
    text: "chocolate"
  }) {
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

## Filtered search

### Object type filter
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [{objectTypes:["news"]}]
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

### Content section types filter
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [{contentSectionTypes:["iframe"]}]
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

### categories filter
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [{categories:["15949"]}]
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

### groups filter
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [{groups:["16811"]}]
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

### sites filter
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [{sites:["3952"]}]
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

### Including markted as archived
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    {objectTypes:["news"]}
    {archive:true}
  }) {
    total
    offset
    queryTime
    results {
      id
      name
      location
    }
  }
}
```

## Faceted search

```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [
      {key: "color", objectTypes: ["content"]}
    ]
    facets: [
      {key:"co", objectTypes: ["content", "news"], excludeFilter:"color"}
    ]
  }) {
    total
    offset
    queryTime
    results {
      id
    }
    facetGroups {
      key
      facets {
        key
        hits
      }
    }
  }
}
```

## Resolve teaser

```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    text: "Filmabend"
  }) {
    total
    offset
    queryTime
    results {
      id
      teaser {
        ...teaser
      }
    }
  }
}

fragment teaser on Teaser {
  __typename
  url
  ... on ArticleTeaser {
    headline
    text
    asset(variant:"teaser") {
      ...asset
    }
  }
}

fragment asset on Asset {
  __typename
  copyright
  caption
  description
  ... on Image {
    alternativeText
    original {
        ...imageSource
    }
    characteristic
      sources {
        ...imageSource
      }
    }
}

fragment imageSource on ImageSource {
  variant
  url
  width
  height
  mediaQuery
}
```


## Resolve navigation hierarchy

Root:
```graphql
{
  search(input: {
    index:"[client-anchor]-www"
    filter: [
      {groups:["1195"]}
    ]
  }) {
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
  search(input: {
    index:"[client-anchor]-www"
    filter: [
      {groups:["1195"]}
    ]
  }) {
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
  search(input: {
    index:"[client-anchor]-www"
    filter: [
      {groups:["1195"]}
    ]
  }) {
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
  search(input: {
    index:"[client-anchor]-www"
    filter: [
      {key:"musterseiten", groups:["1195"]}
    ]
  }) {
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

## TODO
- Date-filter
- Spell Checking
- Error handling
- Spatial Search







### Navigation


## Named, Multiple Queries

