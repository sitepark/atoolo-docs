---
status: draft
---

# Search Component

Provides services with which a Solr index can be filled and searched for [resources](resource.md) via a index.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-search](https://github.com/sitepark/atoolo-search){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/search
```

## Indexing

To be able to search in a Solr index, it must first be filled. This is done via the indexer.

[Resources](resource.md#the-resource) are indexed. These are stored as files in the file system. The indexer can search an entire directory structure for the resources and thus rebuild an entire index. The resources are loaded via the files and mapped to index documents. The mapping is carried out via document enricher that read the resource data and set the corresponding fields of the index document. The index document are passed to Solr so that they can be indexed. Searches can then be performed on a Solr index created in this way.

An [Indexer service](https://github.com/sitepark/atoolo-search/blob/main/src/Indexer.php){:target="\_blank"} is available for indexing, which can be used to index and remove data from the index.

### Custom Document Enricher

Document Enricher allow the document that is passed to Solr for indexing to be enriched with the desired fields. Here it is possible to react to product or customer-specific object types and to set the document according to requirements.

The document to be filled must adhere to the schema stored in Solr. Only the fields that are known in the schema can be set. Currently the schema `2.1` is used. The implementation `IndexSchema2xDocument` of the `IndexDocument` interface is available for this purpose. The document enricher must implement the interface `DocumentEnricher`.

```php
declare(strict_types=1);

namespace Atoolo\Examples\Search\Indexer\Enricher;

use Atoolo\Resource\Resource;
use Atoolo\Search\Service\Indexer\DocumentEnricher;
use Atoolo\Search\Service\Indexer\IndexDocument;
use Atoolo\Search\Service\Indexer\IndexSchema2xDocument;

/**
 * @implements DocumentEnricher<IndexSchema2xDocument>
 */
class CustomDocumentEnricher implements DocumentEnricher
{
    public function isIndexable(Resource $resource): bool
    {
        return true;
    }

    public function enrichDocument(
        Resource $resource,
        IndexDocument $doc,
        string $processId
    ): IndexDocument {
        if (
            $resource->getObjectType() !== 'myObjectType'
        ) {
            return $doc;
        }

        // ... enrich document

        return $doc;
    }
}
```

The document enricher is required, for example, in the [GraphQL Search Bundle](../bundles/graphql-search.md). This offers a mutation that is also used by the CMS IES to trigger indexing. See also [GraphQl Indexing](../graphql/search/indexing.md). So that your own document enricher can be used, it must be registered as [tagged Symfony service](https://symfony.com/doc/current/service_container/tags.html){:target="\_blank"}.

`services.yaml`

```yaml
services:
  Atoolo\Examples\Search\Indexer\Enricher\CustomDocumentEnricher:
    tags:
      - {
          name: "atoolo.search.indexer.documentEnricher.schema2x",
          priority: 10,
        }
```

## Searching

You can search the index to find resources. The [SelectSearcher service](https://github.com/sitepark/atoolo-search/blob/main/src/SelectSearcher.php) is available for this purpose.

### Query

The `select()` method expects a [`SelectQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SelectQuery.php){:target="\_blank"} object that contains the filter rules, for example. To create a [`SelectQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SelectQuery.php){:target="\_blank"} object, only the [`SelectQueryBuilder`](https://github.com/sitepark/atoolo-search/blob/feature/initial-implementation/src/Dto/Search/Query/SelectQueryBuilder.php){:target="\_blank"} must be used to ensure that a valid [`SelectQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SelectQuery.php){:target="\_blank"} object is always created.

Example of a query:

```php
$builder = new SelectQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')

$query = $builder->build();
$result = $selectSearcher->select($query);
```

### Result

The search returns a [`SearchResult`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Result/SearchResult.php){:target="\_blank"} object, which can be used to read the results.

The result provides the list of resources found that can be iterated over.

```php
foreach ($result as $resource) {
  echo $resource->getLocation() . "\n";
}
```

If facets have also been defined in the query, these can also be read out:

```php
foreach ($result->facetGroups as $facetGroup) {
  echo $facetGroup->key . "\n";
  foreach ($facetGroup->facets as $facet) {
    echo $facet->key . ' (' . $facet->hits . ")\n";
  }
}
```

## Searching (More like this)

A "More-Like-This" search is a technique in which a source document or item is used as a reference point to find similar documents in the search index. It is based on extracting characteristics from the source object and searching for other objects that have similar characteristics in order to present relevant results to the user.

The [`MoreLikeThisSearcher`](https://github.com/sitepark/atoolo-search/blob/main/src/MoreLikeThisSearcher.php){:target="\_blank"} service is available for this. The `moreLikeThis()` method expects a [`MoreLikeThisQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/MoreLikeThisQuery.php){:target="\_blank"} object with which the query can be defined.

The search returns a [`SearchResult`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Result/SearchResult.php){:target="\_blank"} object with which the results can be read.

The result returns the list of resources found, which can be iterated over.

```php
foreach ($result as $resource) {
  echo $resource->getLocation() . "\n";
}
```

## Suggest

A "suggest search" is a search function that automatically displays suggestions or auto-completions to users as they enter search queries.

The [`SuggestSearcher`](https://github.com/sitepark/atoolo-search/blob/main/src/SuggestSearcher.php){:target="\_blank"} service is available for this. The `moreLikeThis()` method expects a [`SuggestQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SuggestQuery.php){:target="\_blank"} object with which the query can be defined.

The search returns a [`SuggestResult`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Result/SuggestResult.php){:target="\_blank"} object with which the results can be read.

```php
foreach ($result as $suggest) {
  echo $suggest->term . ' (' . $suggest->hits . ")\n";
}
```

## Command line interface

This component also contains Symfony commands that can be integrated into Symfony projects. For this purpose, the service configuration can be integrated into the `services.yaml` in the corresponding project.

`services.xml`

```yaml
imports:
  - { resource: ../vendor/atoolo/search/config/commands.yml }
```

The following commands are then available via `./bin/console`:

| Command                      | Description                      |
| ---------------------------- | -------------------------------- |
| `atoolo:dump-index-document` | Dump a index document            |
| `atoolo:indexer`             | Fill a search index              |
| `atoolo:mlt`                 | Performs a more-like-this search |
| `atoolo:search`              | Performs a search                |
| `atoolo:suggest`             | Performs a suggest search        |
