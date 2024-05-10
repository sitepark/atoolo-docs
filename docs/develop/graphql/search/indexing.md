# Indexing

Indexing, i.e. filling and updating the search index, is triggered internally and is therefore not publicly accessible.

## Reindex all documents

One use case is to recreate the entire index. The mutation [`index`](http://127.0.0.1:8000/develop/graphql/reference/#mutation-rootmutation) is used for this.

```graphql
mutation {
  index {
    statusLine
  }
}
```

## Updating individual documents

If new articles are created or updated in the CMS, they must also be created or updated in the index. This is also done via the mutation [`indexUpdate`](../reference.md#mutation-rootmutation). The paths of the resources to be updated are passed via an array.

```graphql
mutation {
  indexUpdate(["news/438237.php", "events/43212.php"]) {
    statusLine
  }
}
```

## Get Indexing status

While the indexer is indexing the documents, the current status can be queried using the query [`indexerStatus`](../reference.md/#query-rootquery). For example, to show how many documents have already been indexed.

```graphql
query {
  indexerStatus {
    statusLine
  }
}
```

## Remove documents

The mutation [`indexRemove`](../reference.md/#mutation-rootmutation) is used to remove documents from the index. The corresponding documents are removed from the index by specifying `idList`, which is used to specify a list of resource IDs.

```graphql
mutation {
  indexRemove(idlist: ["438237", "43212"])
}
```

## Abort indexing

Indexing can be canceled. A check is made after each chunk as to whether the process should be aborted. The mutation [`indexAbort`](../reference.md/#mutation-rootmutation) is used to ensure that indexing is interrupted.

```graphql
mutation {
  indexAbort
}
```
