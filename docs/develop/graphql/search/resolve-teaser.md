# Resolve teaser

A teaser is a short preview or introduction that serves to arouse the interest of the target group. Typically, a teaser is used to hint at upcoming content, such as an article, news, or event. The purpose of a teaser is to grab people's attention and encourage them to learn more or consume the full content when it is available. Teasers can use text, images, videos or other media formats to pique the curiosity of the target audience.

Depending on the type of page, a teaser can also be highly customized and contain special data that can only be provided by this type of page. For example, the teaser for a person's page can contain their first and last name and their contact details.

Due to this property of a teaser, the data cannot be mapped via a single object type. The teaser types listed here cannot be complete, as project-specific teasers can also be defined depending on the project.

The 'teaser' field is used to determine the teaser of a resource.

```graphql
{
  search(input: { index: "[client-anchor]-www", text: "movie" }) {
    total
    offset
    queryTime
    results {
      id
      teaser {
        __typename
        url
      }
    }
  }
}
```

In this case, `__typename` and `url` are the only fields that are available for all teaser types. All other fields must be queried individually depending on the teaser type.

This is solved in GraphQL with [Inline Fragments](https://graphql.org/learn/queries/#inline-fragments).

```graphql
{
  search(input: { index: "[client-anchor]-www", text: "movie" }) {
    total
    offset
    queryTime
    results {
      id
      teaser {
        __typename
        url
        ... on ArticleTeaser {
          headline
          text
      }
    }
  }
}
```

## ArticleTeaser

The article teaser is the classic teaser that can contain a headline, a text and possibly an asset (e.g. an image).

In the following example, the fields of the article teaser are read out and [Fragments](https://graphql.org/learn/queries/#fragments) is also used.

See also in the [reference](../reference.md#articleteaser).

```graphql
{
  search(input: { index: "[client-anchor]-www", text: "movie" }) {
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
