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
        excludeFilter: "articletypefilter"
      }
    ]
  }
)
```

Here, `excludeFilter: "articletypefilter"` is used to refer to the filter `key: "articletypefilter"`. When determining this facet, the filter `articletypefilter` is no longer taken into account. This means that the values of the facet can be taken into account correctly, even though the filter is used for the search.

A complete GraphQL Query could then look like this:

```graphql
{
  search(
    input: {
      filter: [{ key: "articletypefilter", objectTypes: ["content"] }]
      facets: [
        {
          key: "articletypes"
          objectTypes: ["content", "news"]
          excludeFilter: "articletypefilter"
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
{
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
          excludeFilter: "sitefilter"
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

### Object type facet

Object types describe the different types of pages that are used in the website. These can be, for example, news pages, events, normal content pages or any other types that are part of the project.

```graphql
{
  search(input: { facets: [{ objectTypes: ["news"] }] }) {
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

### Content section types facet

Content section types are types of sections that are included in a page. These can be text sections, image sections and all others that the project provides for the website. For example, a facet can be defined in which it is possible to determine how many search hits contain a YouTube video.

```graphql
{
  search(input: { facets: [{ contentSectionTypes: ["youtube"] }] }) {
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

### Categories facet

The CMS can be used to define any number of category trees that can be used to categorise articles.
These categories can be facetted via their ID. The hierarchy of the category is also taken into account. This means that if you facet a category that has subcategories, the articles that are linked to the subcategory are also taken into account.

```graphql
{
  search(input: { facets: [{ categories: ["15949"] }] }) {
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

### Groups facet

In the CMS, articles are organised in hierarchical groups. For example, all articles in a category are managed in substructures of the category group. The number of hits can be determined using the group facet. The hierarchy of the groups is also taken into account so that all articles in a group are included, even if they are contained in other nested subgroups.

```graphql
{
  search(input: { facets: [{ groups: ["16811"] }] }) {
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

### Sites facet

Several websites can be managed within the CSM. These can be several main websites, but also microsites that are subordinate to a main website. The Sites facet can be used to determine the number of hits within a site.

```graphql
{
  search(input: { facets: [{ sites: ["3952"] }] }) {
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
