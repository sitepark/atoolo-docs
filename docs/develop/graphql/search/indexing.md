# Indexing

Indexing, i.e. filling and updating the search index, is triggered internally and is therefore not publicly accessible.

## Reindex all documents

One use case is to recreate the entire index. The mutation [`index`](http://127.0.0.1:8000/develop/graphql/reference/#mutation-rootmutation) is used for this. Without specifying `paths`, the entire index is rebuilt. The field `cleanupThreshold` is also important here, which specifies how many documents must have been successfully indexed so that the old documents are also deleted. This ensures that the index is not emptied if a problem occurs during indexing.

```graphql
mutation {
  index(input: { index: "[client-anchor]-www", cleanupThreshold: 1000 }) {
    statusLine
  }
}
```

There is also a parameter `chunkSize` which can be used to specify how many documents are read in at once in order to index them. In the standard case, this is `500`. If the memory consumption is too high for this, the value can be reduced. Increasing the value no longer provides a performance advantage.

## Updating individual documents

If new articles are created or updated in the CMS, they must also be created or updated in the index. This is also done via the mutation [`index`](http://127.0.0.1:8000/develop/graphql/reference/#mutation-rootmutation). However, the paths of the resources that are to be updated must be specified here via the `paths` field. If `paths` is specified, `cleanupThreshold` is not taken into account, as only old versions of the updated documents are deleted.

```graphql
mutation {
  index(
    input: {
      index: "[client-anchor]-www"
      paths: ["news/438237.php", "events/43212.php"]
    }
  ) {
    statusLine
  }
}
```

There is also a parameter `chunkSize` which can be used to specify how many documents are read in at once in order to index them. In the standard case, this is `500`. If the memory consumption is too high for this, the value can be reduced. Increasing the value no longer provides a performance advantage.

## Get Indexing status

Während der Indexer die Dokumente indiziert, kann über die query [`indexerStatus`](http://127.0.0.1:8000/develop/graphql/reference/#query-rootquery) der aktuelle Status abgefragt werden. Z.B. um anzuzeigen wieviele Dokumente bereits indiziert wurde.

```graphql
{
  indexerStatus(index: "[client-anchor]-www") {
    statusLine
  }
}
```

## Remove documents

The mutation [`indexRemove`](http://127.0.0.1:8000/develop/graphql/reference/#mutation-rootmutation) is used to remove documents from the index. The corresponding documents are removed from the index by specifying `idList`, which is used to specify a list of resource IDs.

```graphql
mutation {
  indexRemove(index: "[client-anchor]-www", idlist: ["438237", "43212"])
}
```

## Abort indexing

Das indizieren kann abgebrochen werden. Hierbei wird nach jedem Chunk geprüft, ob der Vorgang abgebrochen werden soll. Über die Mutation [`indexAbort`](http://127.0.0.1:8000/develop/graphql/reference/#mutation-rootmutation) wird dafür gesorgt, das das indizieren unterbrochen wird.

```graphql
mutation {
  indexAbort(index: "[client-anchor]-www")
}
```
