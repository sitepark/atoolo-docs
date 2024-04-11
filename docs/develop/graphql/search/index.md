# Search

The GraphQL query `search` can be used to search for resources. The aim of this GraphQL query is to fulfill the requirements for a search within the website. The focus here is on full-text searches, filters and facets.

## Search in a index

The search is performed using a full-text index. The CMS IES takes care of filling and updating the index. There is a separate index for each publication channel. For translated publication channels, there is a separate index for each language.

For each query via `selectResources`, the index to be searched must be specified via the input parameter `index`.

## Full text search

To find resources using a full-text search, the text is specified using the input parameter `text`.
The index is searched for the text and the corresponding hits are returned. The search is performed word by word. If several words (separated by spaces) are entered, an 'OR' search is carried out by default and the hits must contain at least one of the words. An `OR` search can also be carried out. To do this, the input parameter `queryDefaultOperator` must be specified with `OR`:

```graphql
  search(input: {
    text: "cacao coffee "
    queryDefaultOperator: OR
  }) {
    ...
  }
```

Example:

```graphql
{
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

## Multilingual search

The IES (Sitepark's content management system) supports multilingual resource channels. Editorial content is only ever written in one language and is automatically translated into the other languages by the CMS. A multilingual resource channel then contains several resources for an article, each of which is published in a different language. For the search, a separate full text index is created for each language, which also takes into account language-specific features such as stop words and stemming.

If the publication channel is multilingual, the search is limited to a specific language. The language is specified using the input parameter `lang`. If no 'lang' is specified, the search is carried out in the base language of the channel.

Example:

```graphql
{
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

| Search criteria | Description                                                                                                                                                                                                                                                    |
| --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`          | This is sorted by the name of the article. In some cases, the name is preceded by a numerical prefix to achieve the desired sorting in the CMS and is therefore not always identical to the headline.                                                          |
| `headline`      | Sort by the title of the article.                                                                                                                                                                                                                              |
| `date`          | In many cases, an editorial date can be set for the article that is used here. Otherwise it is the last modification date of the article.                                                                                                                      |
| `natural`       | In most cases, a sort field is written to the index, which should describe the natural sorting of the entry. For normal articles, this is usually the heading. For news or events, however, it is the date, for example. This sort field is used in this case. |
| `score`         | The score is determined during the search and describes how closely the individual hits match the search query. This sorting is useful for full-text searches in order to obtain the most accurate results first. Here it is sorted according to relevance.    |

When specifying the search criteria, you must specify whether the sorting should be in ascending (`ASC`) or descending (`DESC`) order.

The sorting criteria are specified as a list in the following form:

```graphql
sort: [ { name: ASC }, { date: DESC }, ... ]
```

Here is an example of a search criteria:

Example:

```graphql
{
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

- Date-filter
- Spell Checking
- Error handling
- Spatial Search
