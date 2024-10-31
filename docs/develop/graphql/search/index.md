# Search

The GraphQL query `search` can be used to search for resources. The aim of this GraphQL query is to fulfill the requirements for a search within the website. The focus here is on full-text searches, filters and facets.

## Search in a index

The search is performed using a full-text index. The CMS IES takes care of filling and updating the index. There is a separate index for each publication channel. For translated publication channels, there is a separate index for each language.

For each query via `selectResources`, the index to be searched must be specified via the input parameter `index`.

## Full text search

To find resources using a full-text search, the text is specified using the input parameter `text`.
The index is searched for the text and the corresponding hits are returned. The search is performed word by word. If several words (separated by spaces) are entered, an 'OR' search is carried out by default and the hits must contain at least one of the words. An `OR` search can also be carried out. To do this, the input parameter `queryDefaultOperator` must be specified with `OR`:

```graphql
query {
  search(input: {
    text: "cacao coffee"
    queryDefaultOperator: OR
  }) {
    ...
  }
}
```

Example:

```graphql
query {
  search(input: { text: "chocolate" }) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

Quotation marks can be used to search for related phrases:

```graphql
query {
  search(input: {
    text: "cacao \"milk coffee\""
  }) {
    ...
  }
}
```

In order to force a word to be included in the search results, a `+` can be placed in front of the word:

```graphql
query {
  search(input: {
    text: "cacao coffee +milk"
  }) {
    ...
  }
}
```

To exclude a word from the search results, a `-` can be placed in front of the word:

```graphql
query {
  search(input: {
    text: "cacao coffee -milk"
  }) {
    ...
  }
}
```

## Multilingual search

The IES (Sitepark's content management system) supports multilingual resource channels. Editorial content is only ever written in one language and is automatically translated into the other languages by the CMS. A multilingual resource channel then contains several resources for an article, each of which is published in a different language. For the search, a separate full text index is created for each language, which also takes into account language-specific features such as stop words and stemming.

If the publication channel is multilingual, the search is limited to a specific language. The language is specified using the input parameter `lang`. If no `lang` is specified, the search is carried out in the base language of the channel.

Example:

```graphql
query {
  search(input: { text: "chocolate", lang: "it" }) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

Of course, the search results are also in the respective language. Regardless of whether a full-text search or a [filter](filtered-search.md) is carried out.

## Sorting

Sort criteria can be used to specify how the result should be sorted. Multiple sorting criteria can be specified, which are applied to the result one after the other. The second sort criterion is used if the first is the same and so on.

If no sorting criterion is specified, the result is sorted by relevance. The `score` is used here, which is higher the more precisely the hit matches the search.

The following sorting criteria are possible:

| <div style="width:8em">Search criteria</div> | Description                                                                                                                                                                                                                                                    |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                       | This is sorted by the name of the article. In some cases, the name is preceded by a numerical prefix to achieve the desired sorting in the CMS and is therefore not always identical to the headline.                                                          |
| `headline`                                   | Sort by the title of the article.                                                                                                                                                                                                                              |
| `date`                                       | In many cases, an editorial date can be set for the article that is used here. Otherwise it is the last modification date of the article.                                                                                                                      |
| `natural`                                    | In most cases, a sort field is written to the index, which should describe the natural sorting of the entry. For normal articles, this is usually the heading. For news or events, however, it is the date, for example. This sort field is used in this case. |
| `score`                                      | The score is determined during the search and describes how closely the individual hits match the search query. This sorting is useful for full-text searches in order to obtain the most accurate results first. Here it is sorted according to relevance.    |
| `spatialDist`                                | The hits are sorted according to the distance to the reference point. The reference point is specified via an additional parameter `spatialPoint`                                                                                                              |
| `custom`                                     | This sort criterion allows you to use your own fields from the search index for sorting.                                                                                                                                                                       |

When specifying the search criteria, you must specify whether the sorting should be in ascending (`ASC`) or descending (`DESC`) order.

The sorting criteria are specified as a list in the following form:

```graphql
sort: [ { name: ASC }, { date: DESC }, ... ]
```

Here is an example of a search criteria:

Examples:

```graphql
query {
  search(input: { text: "chocolate", sort: [{ name: ASC }] }) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

Sort by distance to the reference point:

```graphql
query {
  search(
    input: {
      text: "chocolate"
      sort: [{ spatialDist: ASC, spatialPoint: { lat: 48.8566, lon: 2.3522 } }]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

When specifying a `custom` sort criteria, the name of the field to be used for sorting must also be specified. This field must be present in the index.

```graphql
query {
  search(
    input: {
      text: "chocolate"
      sort: [{ custom: { field: "myfield", direction: ASC } }]
    }
  ) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

!!! warning

    If the schema is changed, the specified sort field for this sorting may no longer work.

## Archive search

The indexed resources can be marked as "archived". This flag ensures that these resources are not normally included in the search. This can be used for news, for example, to include only the latest news in the general search. For a special search, such as a news archive search, the `archive` flag can be used to also find archived resources.

```graphql
query {
  search(
    input: {
      text: "chocolate"
      filter: [{ objectTypes: ["news"] }]
      archive: true
    }
  ) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

## Date ranges

Date ranges can be used in the search to limit the search to a specific time period. [Date range filters](filtered-search.md#date-range-filter) are used for this purpose.

Facets are another area of application for data ranges. These can be used to determine how many hits are contained in a specific time period or how the hits are distributed over the different days, for example. [Date range facets](faceted-search.md#date-range-facet) are used for this purpose.

A date must always be specified for the UTC time zone and in the format [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601#Combined_date_and_time_representations){:target="\_blank"} (e.g.`2024-05-22T10:13:00Z`).

Date ranges can be defined over an absolute period or relatively based on a specific date.

### Absolute date range

An absolute period is defined by two parameter:

- the start date (`from`)
- the end date (`to`)

If the start or end date is not specified, the current date is used.

Example of an absolute date range

```graphql
{
  absoluteDateRange: {
    from: "2024-05-21T22:00:00Z",
    to: "2024-05-22T21:59:59Z"
  }
}
```

At least the `from` or `to` date must be specified. If `from` is not specified, there is no lower limit. If `to` is not specified, there is no upper limit.

!!! note

    A special case is the use of the absolute date range for facets. Here, a defined period must always be specified for which the facets are to be determined. `from` and `to` are mandatory here.

### Relative date range

A relative date range is specified using two intervals that are relative to a specific date:

- the `before` interval is based on a specific date
- the `after` interval is based on a specific date

The interval must be specified in the format [ISO-8601 Durations](https://en.wikipedia.org/wiki/ISO_8601#Durations){:target="\_blank"} (e.g. `P1D` for one day).

Optionally, a `base` can also be specified. This date is used as the basis for calculating the relative date. If no `base` is specified, the current date is used.

Relative date ranges can only be exact to the day. Specifying a time such as "P1DT1H" will result in an error.

The period defined via the `before` and `after` intervals is to the day. The period is therefore always rounded. See [Round Date](#round-date).

The following examples illustrate the relative date ranges:

Only everything from yesterday:

```graphql
{
  relativeDateRange: {
    before: "P1D"
    roundStart : START_OF_DAY
    roundEnd: END_OF_PREVIOUS_DAY # default end-date is 'now'
  }
}
```

Yesterday, today and tomorrow

```graphql
{
  relativeDateRange: {
    before: "P1D"
    after: "P1D"
  }
}
```

Everything from the last 7 days and today:

```graphql
{
  relativeDateRange: {
    before: "P7D"
    roundStart : START_OF_DAY
    roundEnd: END_OF_DAY # default end-date is 'now'
  }
}
```

Everything this month, past and future

```graphql
{
  relativeDateRange: {
    roundStart : START_OF_MONTH
    roundEnd: END_OF_MONTH # default end-date is 'now'
  }
}
```

All in the last month:

```graphql
{
  relativeDateRange: {
    before: "P1M"
    roundStart : START_OF_MONTH
    roundEnd: END_OF_PREVIOUS_MONTH # default end-date is 'now'
  }
}
```

All in the seven days before Christmas Eve 2024 (Timezone Europe/Berlin):

```graphql
{
  relativeDateRange: {
    base: "2024-12-23T23:00:00Z"
    before: "P7D"
    roundEnd: END_OF_PREVIOUS_DAY
  }
}
```

### Round date

The smallest unit in which ranges can be defined is a day. Each date is therefore rounded (for current Timezone). How the date is to be rounded can be defined using the `roundStart` and `roundEnd` parameters. The possible values are:

| <div style="width:13em">Name</div> | Description                                                                                                                |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `START_OF_DAY`                     | The start of the day. The time is set to `00:00:00`.                                                                       |
| `START_OF_PREVIOUS_DAY`            | The start of the previous day. The time is set to `00:00:00` of the previous day.                                          |
| `END_OF_DAY`                       | The end of the day. The time is set to `23:59:59`.                                                                         |
| `END_OF_PREVIOUS_DAY`              | The end of the previous day. The time is set to `23:59:59` of the previous day.                                            |
| `START_OF_MONTH`                   | The start of the month. The date is set to the first day of the month the time is set to `00:00:00`.                       |
| `START_OF_PREVIOUS_MONTH`          | The start of the previous month. The date is set to the first day of the previous month and the time is set to `00:00:00`. |
| `END_OF_MONTH`                     | The end of the month. The date is set to the last day of the month and the time is set to `23:59:59`.                      |
| `END_OF_PREVIOUS_MONTH`            | The end of the previous month. The date is set to the last day of the previous month and the time is set to `23:59:59`.    |
| `START_OF_YEAR`                    | The start of the year. The date is set to the first day of the year and the time is set to `23:59:59`.                     |
| `START_OF_PREVIOUS_YEAR`           | The start of the previous year. The date is set to the first day of the previous year and the time is set to `23:59:59`.   |
| `END_OF_YEAR`                      | The end of the year. The date is set to the last day of the year and the time is set to `23:59:59`.                        |
| `END_OF_PREVIOUS_YEAR`             | The end of the previous year. The date is set to the last day of the previous year and the time is set to `23:59:59`.      |

If no rounding parameter is specified, `START_OF_DAY` is used for `roundStart` and `END_OF_DAY` for `roundEnd`.

See also [Timezone](#timezone)

## Timezone

By default, all mathematical date expressions are evaluated relative to the Server time zone, but the timeZone parameter can be specified to override this behavior by performing all date-related additions and rounding relative to the specified time zone.

This is relevant for [Date ranges](#date-ranges).

Example:

```graphql
query {
  search(input: { timeZone: "Europe/London", ... }) {
    ...
  }
}
```

!!! note

    The time zone only affects the range of dates. The date specifications transferred in the GraphQL query and the date specifications returned in the results remain UTC.

## Spatial search

A Spatial Search searches data based on spatial or geographical relationships rather than traditional text or number-based criteria. It takes into account coordinates and distances to find relevant results in a specific area or radius. This technique is often used in applications such as maps to filter and sort information according to its position in space.

To enable searches based on geodata, the corresponding fields must be available in the index. This requires the individual resources to be provided with geo coordinates via the CMS.

The GraphQL search supports the following features:

- Specification of the distance (in km) per hit to the reference point. See also [Geo data](resolve-resource.md#geo-data)
- [Sorting](#sorting) of hits by distance to the reference point
- Filtering of hits by distance to the reference point using the [Spatial orbital filter](filtered-search.md#spatial-orbital-filter)
- Filtering of hits that are located within a defined rectangle using the [Spatial arbitrary rectangle filter](filtered-search.md#spatial-arbitrary-rectangle-filter)
- Faceting of hits by distance to the reference point using the [Spatial distance range facet](faceted-search.md#spatial-distance-range-facet)

## Boosting

Boosting makes it possible to increase the relevance of certain documents in the search results. This can be achieved by customizing query parameters, such as adding boosting factors to specific fields or applying custom functions. In this way, search results can be specifically influenced to place more relevant results at the top.

The following parameters can be used to influence the result:

| <div style="width:13em">Name</div> | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `queryFields`                      | This parameter specifies the fields to be searched and their relative importance. It is a list of fields, optionally with boost factors that indicate how heavily each field should be weighted when matching search terms. For example, qf=title^2.0 description means that the title field is twice as important as the description field.                                                 |
| `phraseFields`                     | This parameter increases the importance of whole phrases (word sequences) in the specified fields. It is used to increase the relevance of documents in which the search terms appear as phrases in these fields. For example, pf=title^1.5 content increases the relevance of documents in which the search terms appear as a phrase in the title field more than in the content field.     |
| `boostQueries`                     | This parameter allows additional query clauses that increase the relevance score of documents that match these clauses. These clauses do not affect whether a document matches the main query, but increase the score of documents that match them. For example, `contenttype:(text/html*)^10` would increase the relevance score of HTML documentserhöhen.                                  |
| `boostFunctions`                   | This parameter applies function-based boosts to the relevance score. These are mathematical functions that adjust the score based on field values or other criteria. For example, `if(termfreq(sp_objecttype,'news'),scale(sp_date,0,12),scale(sp_date,10,11)` could be used to score older news articles less highly                                                                        |
| `tie` (Tie-Breaker-Multiplikator)  | This parameter combine the best match points from multiple fields. The tie parameter adjusts how much lower scores affect the overall score. A higher tie value means that the lower scores have more influence on the final score. For example, tie=0.1 could be used to give the secondary fields some influence in the scoring process, preventing only the best matches from dominating. |

Setting the boosting parameters requires in-depth knowledge of how the search index works and its schema. If no boosting is specified, the default values of Sitepark are used, which have already proven themselves in many projects.

Example:

```graphql
query {
  search(input: {
     ...
     boosting: {
      queryFields: [
        "sp_title^1.4",
        "keywords^1.2",
        "description^1.0",
        "title^1.0",
        "url^0.9",
        "content^0.8"
      ]
      phraseFields: [
        "sp_title^1.5",
        "description^1",
        "content^0.8"
      ]
      boostQueries: [
        "sp_objecttype:searchTip^100",
        "contenttype:(text/html*)^10"
      ]
      boostFunctions: [
        "if(termfreq(sp_objecttype,'news'),scale(sp_date,0,12),scale(sp_date,10,11))"
      ]
      tie: 0.1
    }
  }) {
    ...
  }
}
```

!!! warning

    The boosting parameters are matched to the fields of the index. If changes are made to the index schema, the boosting parameters must be adjusted accordingly.

## Search results

The search results can be output using the [`SearchResult`](../reference.md#searchresult) type. In this case, `results` returns a list of [`Resource`](../reference.md#resource) objects. This can be used to query further data. See also:

- [Resolve resource](resolve-resource.md)
- [Resolve navigation hierarchy](resolve-navigation-hierarchy.md)
- [Resolve teaser](resolve-teaser.md)

## Advanced search

Additional input parameters are available for extended search functionalities, which can be used with the search. These are described on the following pages.

- [Filtered search](filtered-search.md)
- [Faceted search](faceted-search.md)
- [Resolve teaser](resolve-teaser.md)
- [Resolve navigation hierarchy](resolve-navigation-hierarchy.md)

## Explain

The `explain` parameter can be used to output detailed information about the search. This can be used to analyze the search and to identify possible sources of error.

It helps to understand why certain hits are returned and why they are returned in the corresponding order.

```graphql
query {
  search(input: {
    text: "section"
    explain: true
  }) {
    results {
      name
      explain {
        score
        type
        description
        details {
          score
          type
          description
          details {
            ...
          }
        }
      }
  }
}
```

Depending on how precise the analysis is to be, a corresponding number of levels of `details` can be returned.

A result can look like this, for example:

```json
{
  "data": {
    "search": {
      "total": 26,
      "results": [
        {
          "name": "Section with Tabs",
          "explain": {
            "score": 24.873642,
            "type": "sum",
            "details": [
              {
                "score": 3.9798312,
                "type": "max",
                "description": "max plus 0.1 times others of:",
                "details": [
                  {
                    "score": 1.4506807,
                    "type": "weight",
                    "field": "sp_title",
                    "details": [
                      {
                        "score": 1.4506807,
                        "type": "score",
                        "description": "score(freq=1.0), computed as boost * idf * tf from:",
                        "details": [
                          {
                            "description": "boost"
                          },
                          {
                            "description": "idf, computed as log(1 + (N - n + 0.5) / (n + 0.5)) from:"
                          },
                          {
                            "description": "tf, computed as freq / (freq + k1 * (1 - b + b * dl / avgdl)) from:"
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "score": 1.0478733,
                    "type": "weight",
                    "field": "title",
                    "details": [
                      {
                        "score": 1.0478733,
                        "type": "score",
                        "description": "score(freq=1.0), computed as boost * idf * tf from:",
                        "details": [
                          {
                            "description": "idf, computed as log(1 + (N - n + 0.5) / (n + 0.5)) from:"
                          },
                          {
                            "description": "tf, computed as freq / (freq + k1 * (1 - b + b * dl / avgdl)) from:"
                          }
                        ]
                      }
                    ]
                  },
                  {
                    "score": 3.7299757,
                    "type": "weight",
                    "field": "content",
                    "details": [
                      {
                        "score": 3.7299757,
                        "type": "score",
                        "description": "score(freq=3.0), computed as boost * idf * tf from:",
                        "details": [
                          {
                            "description": "boost"
                          },
                          {
                            "description": "idf, computed as log(1 + (N - n + 0.5) / (n + 0.5)) from:"
                          },
                          {
                            "description": "tf, computed as freq / (freq + k1 * (1 - b + b * dl / avgdl)) from:"
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "score": 10,
                "type": "boosting",
                "description": "contenttype:text/html*^10.0",
                "details": []
              },
              {
                "score": 10.893811,
                "type": "function",
                "description": "FunctionQuery(if(termfreq(sp_objecttype,news),scale(date(sp_date),0.0,12.0),scale(date(sp_date),10.0,11.0))), product of:",
                "details": [
                  {
                    "score": 10.893811,
                    "type": "boosting",
                    "field": null,
                    "details": []
                  },
                  {
                    "score": 1,
                    "type": "boost",
                    "field": null,
                    "details": []
                  }
                ]
              }
            ]
          }
        },
        ...
      ]
    }
  }
}
```

## TODO

- Spell Checking
