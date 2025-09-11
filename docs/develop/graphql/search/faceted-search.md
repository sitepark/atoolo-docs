# Faceted search

A faceted search, also known as faceted filtering, is a search technique that can be applied to various use cases to allow users to easily refine and navigate search results. It works by dividing search results into different categories or facets that are representative features or attributes of the information found.

The facet type is required to define a facet. This can be, for example, the object type and the possible values of the facet type whose results are to be returned.

This can look like this, for example:

```graphql
facets: [
  {
    key: "articletypes",
    objectTypes: ["content", "news"]
  }
]
```

The specification of a `key` is necessary so that the facet can be identified in the result, as it is possible to specify several facets.

A facet is defined here via the object type. The possible values `content` and `news` indicate that the number of possible hits is returned for these two values.

With `facetGroups` in [`SearchResult`](../reference.md#searchresult) the results of the facets can be output.

```graphql
facetGroups {
  key
  facets {
    key
    hits
  }
}
```

A result could look like this, for example:

```json
{
  "facetGroups": [
    {
      "key": "articletypes",
      "facets": [
        {
          "key": "content",
          "hits": 664
        },
        {
          "key": "news",
          "hits": 1633
        }
      ]
    }
  ]
}
```

This indicates that a search filtered by `objectTypes:content` would return `664` hits. A search with the filter on `objectTypes:news` would return `1633` hits.

The facets are determined on the basis of the search. One problem with this is that if, for example, the filter `objectTypes:content` is used, the search result no longer contains any hits of the type `news` and therefore the result of the facet for `news` is `0`.

To solve this problem, you can specify for each facet which filter should not be taken into account so that the result is not distorted.

This is done via the `excludeFilter` parameter. This parameter refers to the `key` of a filter. This can look like this, for example.

```graphql
search(
  input: {
    filter: [{ key: "articletypefilter", objectTypes: ["content"] }]
    facets: [
      {
        key: "articletypes",
        objectTypes: ["content", "news"],
        excludeFilter: ["articletypefilter"]
      }
    ]
  }
)
```

Here, `excludeFilter: ["articletypefilter"]` is used to refer to the filter `key: "articletypefilter"`. When determining this facet, the filter `articletypefilter` is no longer taken into account. This means that the values of the facet can be taken into account correctly, even though the filter is used for the search.

A complete GraphQL Query could then look like this:

```graphql
query {
  search(
    input: {
      filter: [{ key: "articletypefilter", objectTypes: ["content"] }]
      facets: [
        {
          key: "articletypes"
          objectTypes: ["content", "news"]
          excludeFilter: ["articletypefilter"]
        }
      ]
    }
  ) {
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

Any number of facets can be specified. An example could look like this:

```graphql
query {
  search(
    input: {
      filter: [
        { key: "articletypefilter", objectTypes: ["content"] }
        { key: "sitefilter", sites: ["3952"] }
      ]
      facets: [
        {
          key: "articlefacet"
          objectTypes: ["content", "news"]
          excludeFilter: "articletypefilter"
        }
        {
          key: "sitefacet"
          sites: ["3952", "4551", "7462", "1463"]
          excludeFilter: ["sitefilter"]
        }
      ]
    }
  ) {
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

## Object type facet

Object types describe the different types of pages that are used in the website. These can be, for example, news pages, events, normal content pages or any other types that are part of the project.

```graphql
query {
  search(input: { facets: [{ key: "mykey", objectTypes: ["news"] }] }) {
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

## Content section types facet

Content section types are types of sections that are included in a page. These can be text sections, image sections and all others that the project provides for the website. For example, a facet can be defined in which it is possible to determine how many search hits contain a YouTube video.

```graphql
query {
  search(
    input: { facets: [{ key: "mykey", contentSectionTypes: ["youtube"] }] }
  ) {
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

## Categories facet

The CMS can be used to define any number of category trees that can be used to categorise articles.
These categories can be facetted via their ID. The hierarchy of the category is also taken into account. This means that if you facet a category that has subcategories, the articles that are linked to the subcategory are also taken into account.

```graphql
query {
  search(input: { facets: [{ key: "mykey", categories: ["15949"] }] }) {
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

## Groups facet

In the CMS, articles are organised in hierarchical groups. For example, all articles in a category are managed in substructures of the category group. The number of hits can be determined using the group facet. The hierarchy of the groups is also taken into account so that all articles in a group are included, even if they are contained in other nested subgroups.

```graphql
query {
  search(input: { facets: [{ key: "mykey", groups: ["16811"] }] }) {
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

## Sites facet

Several websites can be managed within the CMS. These can be several main websites, but also microsites that are subordinate to a main website. The Sites facet can be used to determine the number of hits within a site.

```graphql
query {
  search(input: { facets: [{ key: "mykey", sites: ["3952"] }] }) {
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

## Content types facet

This can be used to facet the content type, e.g. `application/pdf` or `text/html; charset=UTF-8`.

```graphql
query {
  search(
    input: {
      facets: [
        {
          key: "mykey"
          contentTypes: ["application/pdf", "text/html; charset=UTF-8"]
        }
      ]
    }
  ) {
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

## Sources facet

This facet can be used to determine the number of hits for a specific source. The source indicates which indexer was used to transfer the data to the index. For resources that are editorially maintained by the CMS, the source is `internal`.

```graphql
query {
  search(input: { facets: [{ key: "mykey", sources: ["internal"] }] }) {
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

## Date range facet

An editorial date can be maintained for articles. This date can be used for the search to filter articles. If there is no editorial date, the creation date of the article is used. Depending on the article type, a list of dates can also be maintained. This is the case for events, for example. Repeat dates are also possible here. All dates are then taken into account in the date range facet.

Facets can also be defined using a time range. Two entries are required for this:

There are two ways in which a date range facet can be used.

1. to determine the number of all results within a certain period of time.
2. to determine the number of results divided into time periods within a certain time period, e.g. the number of results within a month divided into days.

To determine the number of all results within a certain period, the period must be specified via [Date ranges](index.md#date-ranges).

If the result is to be divided into time periods, a `gap` must also be specified. This specifies the date periods in which the results are to be subdivided.
`gap` must be specified in [ISO-8601 Duration](https://en.wikipedia.org/wiki/ISO_8601#Durations){:target="\_blank"} format (e.g.`P1M`).

### Examples

#### Absolute date range facet

Example of absolute date range facets for the year `2022` (Timezone Europe/Berlin) divided into months:

```graphql
query {
  search(
    input: {
      facets: [
        {
          key: "month"
          absoluteDateRange: {
            from: "2021-12-31T23:00:00Z"
            to: "2022-12-30T23:00:00Z"
            gap: "P1M"
          }
        }
      ]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
      name
      location
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

#### Absolute relative range facet

Example of relative date range facets for the last, current and next year divided into months:

```graphql
query {
  search(
    input: {
      facets: [
        {
          key: "month"
          relativeDateRange: {
            from: "-P1Y"
            to: "P1Y"
            gap: "P1M"
            roundStart: START_OF_YEAR
            roundEnd: END_OF_YEAR
          }
        }
      ]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
      name
      location
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

#### Facets for Date range selection

One use case is the selection of a date range according to predefined ranges. E.g.

- Today
- Next 7 days
- This month
- This and nex month

The facet search can be used to determine how many hits are contained in the date periods.

```graphql
query relativeDateRangeFacetsearch($filter: RelativeDateRangeInputFilter) {
  search(
    input: {
      filter: [{ key: "dateFilter", relativeDateRange: $filter }]
      facets: [
        {
          key: "today"
          relativeDateRange: { to: "P1D", roundEnd: END_OF_PREVIOUS_DAY }
          excludeFilter: ["dateFilter"]
        }
        {
          key: "next7days"
          relativeDateRange: { to: "P7D", roundEnd: END_OF_PREVIOUS_DAY }
          excludeFilter: ["dateFilter"]
        }
        {
          key: "thisMonth"
          relativeDateRange: { to: "P1M", roundEnd: END_OF_PREVIOUS_MONTH }
          excludeFilter: ["dateFilter"]
        }
        {
          key: "thisAndNextMonth"
          relativeDateRange: { to: "P1M", roundEnd: END_OF_MONTH }
          excludeFilter: ["dateFilter"]
        }
      ]
    }
  ) {
    total
    results {
      objectType
      name
      id
    }
    facetGroups {
      key
      facets {
        key
        hits
      }
    }
    queryTime
  }
}
```

Depending on which filter is selected, the corresponding filter value must be transferred. This is transferred here as the variable `filter`:

If "Today" is selected:

```json
{
  "filter": {
    "to": "P1D",
    "roundEnd": "END_OF_PREVIOUS_DAY"
  }
}
```

If "Next 7 days" is selected:

```json
{
  "filter": {
    "to": "P7D",
    "roundEnd": "END_OF_PREVIOUS_DAY"
  }
}
```

If "This month" is selected:

```json
{
  "filter": {
    "to": "P1M",
    "roundEnd": "END_OF_PREVIOUS_MONTH"
  }
}
```

If "This and nex month" is selected:

```json
{
  "filter": {
    "to": "P1M",
    "roundEnd": "END_OF_MONTH"
  }
}
```

#### Facets for Day-by-day Paging

One use case for event searches is that day-by-day paging is used when events are to be searched for within a certain period of time.

In this case, only the events for one day are displayed and the user can then query the hits on a day-by-day basis.

```graphql
query relativeDateRangeFacetsearch($currentPageDate: DateTime) {
  search(
    input: {
      filter: [
        {
          key: "currentPageDateFilter"
          relativeDateRange: {
            base: $currentPageDate
            to: "P1D"
            roundEnd: END_OF_PREVIOUS_DAY
          }
        }
      ]
      facets: [
        {
          key: "pageDates"
          absoluteDateRange: {
            from: "2024-05-01T00:00:00+02:00"
            to: "2024-05-20T00:00:00+02:00"
            gap: "P1D"
          }
          excludeFilter: ["currentPageDateFilter"]
        }
      ]
    }
  ) {
    total
    results {
      id
      objectType
      teaser {
        url
        ... on ArticleTeaser {
          date
          kicker
          headline
        }
      }
      name
      id
    }
    facetGroups {
      key
      facets {
        key
        hits
      }
    }
    queryTime
  }
}
```

Variable:

```json
{
  "currentPageDate": "2024-05-03T22:00:00Z"
}
```

## Spatial distance range facet

The spatial distance range facet can be used to determine the number of hits within a certain distance from a reference point.

Diese Facette benötigt folgtende Parmameter:

`point`

: The reference point from which the distance is to be determined. This point is specified as a longitude and latitude point.

`from`

: The minimum distance from the reference point. This is specified in km.

`to`

: The maximun distance from the reference point. This is specified in km.

```graphql
query {
  search(
    input: {
      facets: [
        {
          key: "mykey"
          spatialDistanceRange: {
            point: { lat: 51.9650398, lng: 7.6260621 }
            from: 0
            to: 10
          }
        }
      ]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
      name
      location
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

## Query facet

This facet accepts a query that is passed directly to the search engine. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.

!!! warning

    If the schema is changed, the specified queries for these facet may no longer work.

```graphql
query {
  search(
    input: { facets: [{ key: "mykey", query: "sp_objecttype:content" }] }
  ) {
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

## Query template facet

Like the "Query facet", the "Query template facet" also accepts a query that is passed directly to the search engine.

The difference is that here a query is defined with placeholders and the variables to be used are specified separately. The use case is when the query is not defined directly by the frontend, but is specified by the PHP backend via an HTML data attribute and the frontend should only use the user input.

The query is defined with placeholders in the form `{myvar}`. The variables are then passed separately via the `variables` attribute.

!!! warning

    If the schema is changed, the specified queries for these facet may no longer work.

```graphql
query {
  search(
    input: {
      facets: [
        {
          key: "mykey"
          query: "sp_objecttype:{myvar}"
          variables: { myvar: "content" }
        }
      ]
    }
  ) {
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
