---
status: draft
---

# Search Component

Provides services with which a Solr index can be filled and searched for [resources](resource.md) via this index.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-search](https://github.com/sitepark/atoolo-search){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/search
```

## Indexing

### Custom Document Enricher

Document Enricher allow the document that is passed to Solr for indexing to be enriched with the desired fields. Here it is possible to react to product or customer-specific object types and to set the document according to requirements.

The document to be filled must adhere to the schema stored in Solr. Only the fields that are known in the schema can be set. Currently the schema `2.1` is used. The implementation `IndexSchema2xDocument` of the `IndexDocument` interface is available for this purpose. The document enricher must implement the interface `DocumentEnricher`.

```php
<?php

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
