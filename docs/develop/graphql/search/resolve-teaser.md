---
status: draft
---

# Resolve teaser

```graphql
{
  search(input: { index: "[client-anchor]-www", text: "Filmabend" }) {
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
    asset(variant: "teaser") {
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
