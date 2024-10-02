# More like this

A "More-Like-This" search is a technique in which a source document or item is used as a reference point to find similar documents in the search index. It is based on extracting characteristics from the source object and searching for other objects that have similar characteristics in order to present relevant results to the user.

A more-like-this search can be carried out as follows.

```graphql
query {
  moreLikeThis(input: { id: "1211" }) {
    total
    offset
    queryTime
    results {
      id
    }
  }
}
```

You can also use [filters](filtered-search.md) for more-like-this.

Just like the search, the search result returns a [`SearchResult`](../reference.md#searchresult) object. See also [Search results](index.md#search-results)
