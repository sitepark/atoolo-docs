# Index Bundle

Provides the backend agnostic core for indexing [resources](resource.md).

Indexers used to differ only in their **source** - where the data comes from.
They now also differ in their **target**: the Solr index of the
[search bundle](search/index.md), a GenAI application
([GenAI bundle](genai.md)), or whatever comes next. Everything that is
independent of the target lives in this bundle: the `Indexer` interface, the
CMS side indexer configuration, the document enricher mechanics, status
handling, abortion, the console commands and the scheduler.

The bundle brings no index target of its own.

## Sources

The sources can be accessed via the GitHub project [https://github.com/sitepark/atoolo-index-bundle](https://github.com/sitepark/atoolo-index-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

```sh
composer require atoolo/index-bundle
```

The bundle has to be registered in `config/bundles.php`:

```php
return [
    // ...
    Atoolo\Index\AtooloIndexBundle::class => ['all' => true],
];
```

## Index name

The index name is used to determine which index is written to. An index is
always assigned to a [Resource Channel](../../concepts/resource-channel.md).

The IES supports multilingual resource channels. Editorial content is only ever
written in one language and is automatically translated into the other
languages by the CMS. Depending on the target, a separate index is created for
each language - Solr does, because stop words and stemming are language
specific; a GenAI target usually does not, because embedding models are
multilingual.

The name is determined via the interface `IndexName`. The implementation this
bundle ships, `ResourceChannelBasedIndexName`, appends the locale of a
translated language (`<index>-<locale>`) - the convention of a target that
keeps one index per language. A target with a single multilingual index
implements `IndexName` itself.

```php
$indexName = new ResourceChannelBasedIndexName($resourceChannel);
$lang = ResourceLanguage::of('en');
$index = $indexName->name($lang);
```

If there is no index for the specified language, the index for the base
language of the resource channel is returned.

## Indexing

[Resources](resource.md#the-resource) are stored as files in the file system.
The indexer searches a directory structure for them, loads them and maps them
to index documents. The mapping is carried out via document enricher that read
the resource data and set the fields of the index document. The documents are
then handed to the index target.

`InternalResourceIndexer` is the standard indexer. It is target agnostic: the
target is injected as an `IndexService`, the document comes from the target's
`IndexDocumentFactory`, and the fields are set by the target's enricher.

### The target ports

An index target implements four interfaces:

| Interface | Purpose |
| --- | --- |
| `IndexService` | the index itself: name, managed indices, updater, commit, delete, and a `prepareIndexing()` hook for whatever a target needs before a full run |
| `IndexUpdater` | collects the documents of one chunk and transfers them |
| `IndexUpdateResult` | `isSuccess()` and `getErrorMessage()` of one transfer |
| `IndexDocumentFactory` | creates the target's `IndexDocument` |

`IndexService` carries only what a run of the indexer needs. Free-form target
queries - Solr's delete-by-query for example - stay with the target. The one
thing the port does expect of a document is that it keeps the process id of
the run that wrote it, otherwise a full run cannot tell stale documents from
current ones.

**`IndexDocument` prescribes no structure.** It extends `\JsonSerializable`
and nothing else: a document only has to represent itself as data, so that
`index:dump-document` can show what a run would write. Whether that is a flat
map of fields, a nested tree or a list of sections is up to the target - the
indexer never looks inside the document, it only passes it from the factory
through the enricher to the updater.

An indexer that can index single paths instead of the whole tree implements
`UpdatableIndexer`.

### Registering an indexer

Every target bundle registers its own indexer instance and tags it
`atoolo_index.indexer`. The generic services - the resource filter, the
location finder, the aborter, the configuration loader, the status store and
the php limit increaser - come from this bundle:

```yaml
services:
  mybundle.indexer.progress_state:
    class: Atoolo\Index\Service\Indexer\IndexerProgressState
    arguments:
      - "@atoolo_index.index_name"
      - "@atoolo_index.indexer.status_store"
      - "mysource"

  mybundle.indexer.internal_resource_indexer:
    class: Atoolo\Index\Service\Indexer\InternalResourceIndexer
    arguments:
      - !tagged_iterator mybundle.indexer.document_enricher
      - "@atoolo_index.indexer.resource_filter"
      - "@mybundle.indexer.progress_state"
      - "@atoolo_index.indexer.location_finder"
      - "@atoolo_resource.resource_loader"
      - "@mybundle.indexer.index_service"
      - "@atoolo_index.indexer.aborter"
      - "@atoolo_index.indexer.configuration_loader"
      - "mysource"
      - "@atoolo_index.index_name"
      - false # see "CMS side configuration"
      - "@atoolo_index.indexer.php_limit_increaser"
      - "@logger"
    tags:
      - { name: "atoolo_index.indexer", priority: 20 }
```

Note the enricher iterator: **enricher are always target specific**, because
they write the field names of one schema. Each target bundle therefore defines
a tag of its own.

### CMS side configuration

Which sources exist and how they are indexed is configured by the CMS, one
file per source under `configs/indexer/<source>.php`. A source without a file
is not offered by the console. This is how a project enables the solr indexer
(`internal.php`) and a GenAI indexer (`genai.php`) independently of each
other.

The `$enabledWithoutConfig` constructor argument of
`InternalResourceIndexer` overrides that: with `true` the indexer is offered
even without a configuration file, and
`IndexerConfigurationLoader::load()` falls back to defaults. Only the solr
indexer of the search bundle uses it, so that projects that never wrote a
`configs/indexer/internal.php` keep working as they did before 1.18.

### Custom Document Enricher

Document enricher allow the document that is handed to the target to be
enriched with the desired fields. Here it is possible to react to product or
customer-specific object types and to set the document according to
requirements.

```php
declare(strict_types=1);

namespace Atoolo\Examples\Indexer\Enricher;

use Atoolo\Index\Service\Indexer\DocumentEnricher;
use Atoolo\Index\Service\Indexer\IndexDocument;
use Atoolo\Resource\Resource;
use Atoolo\Search\Service\Indexer\IndexSchema2xDocument;

/**
 * @implements DocumentEnricher<IndexSchema2xDocument>
 */
class CustomDocumentEnricher implements DocumentEnricher
{
    public function enrichDocument(
        Resource $resource,
        IndexDocument $doc,
        string $processId
    ): IndexDocument {
        if ($resource->objectType !== 'myObjectType') {
            return $doc;
        }

        // ... enrich document

        return $doc;
    }

    public function cleanup(): void {}
}
```

The enricher is registered with the tag of the target it writes for - for Solr
that is `atoolo_search.indexer.document_enricher.schema2x`.

### Custom Content Matcher

For the full-text content, the `content` field is filled with everything
relevant to the search. The `content` array of the resource is walked
recursively and a `ContentMatcher` is called for each value, so that special
content can be extracted.

```yaml
services:
  Atoolo\Examples\Indexer\Matcher\CustomContentMatcher:
    tags:
      - { name: "atoolo_index.indexer.sitekit.content_matcher", priority: 10 }
```

### Document dumper

`IndexDocumentDumper` shows the document a target would write, one instance per
target, tagged `atoolo_index.indexer.document_dumper`. It builds its document
with the same `IndexDocumentFactory` the target's updater uses, so a dump and
an index run can never drift apart.

## Console commands

| Command | Purpose |
| --- | --- |
| `index:indexer [paths] [--source]` | fill an index |
| `index:update <paths> [--source]` | update single paths |
| `index:dump-document <paths> [--source]` | dump a document |

With exactly one candidate the source is used silently, with several the
command asks. See also [Indexing](../../operate/indexing.md).

## Scheduler

`AddScheduleMessengerPass` of Symfony creates one transport per schedule name,
so one schedule per indexer would need one `messenger:consume` worker per
indexer. All indexers therefore share a single schedule named `atoolo_index`,
configured per source:

```yaml
parameters:
  atoolo_index.indexer.schedules:
    internal: "0 2 * * *"
    genai: "0 3 * * *"
```

`IndexerMessageHandler` resolves the indexer by the source of the message. A
source that has no registered indexer is skipped with a warning.

!!! warning

    Do not configure one source in both this schedule and one of the
    deprecated schedulers of the search bundle - it would run twice.

## Migration from atoolo/search-bundle 1.17

With `atoolo/search-bundle` 1.18 the indexer core moved into this bundle. The
old names keep working and are removed in 2.0.

### Classes

Every moved class, interface and enum keeps a deprecated alias at its old
name. Replace the namespace `Atoolo\Search` with `Atoolo\Index` for:

- `Indexer`
- `Service\AbstractIndexer`, `Service\IndexName`,
  `Service\ResourceChannelBasedIndexName`
- `Service\Indexer\*` except the Solr specific classes
  (`IndexSchema2xDocument`, `SolrIndexService`, `SolrIndexUpdater`,
  `SolrXmlIndexer`, `SolrXmlReader` and the schedulers stay)
- `Service\Indexer\SiteKit\*` except `DefaultSchema2xDocumentEnricher`
- `Dto\Indexer\*` except the `SolrXml*` classes
- `Exception\DocumentEnrichingException`,
  `Exception\UnsupportedIndexLanguageException`
- `Console\Application`, `Console\Command\Io\*`

The aliases are registered eagerly when the search-bundle is autoloaded, not
only when a deprecated name is first used. That is deliberate: PHP does not
autoload for parameter and return type checks, so a method that type hints a
deprecated name would otherwise reject an object of the new class. Existing
indexer and enricher of a project therefore keep working unchanged.

### Service ids

| Deprecated | Use |
| --- | --- |
| `atoolo_search.index_name` | `atoolo_index.index_name` |
| `atoolo_search.indexer.php_limit_increaser` | `atoolo_index.indexer.php_limit_increaser` |
| `atoolo_search.indexer.content_collector.sitekit` | `atoolo_index.indexer.content_collector.sitekit` |
| `atoolo_search.indexer.resource_filter` | `atoolo_index.indexer.resource_filter` |
| `atoolo_search.indexer.aborter` | `atoolo_index.indexer.aborter` |
| `atoolo_search.indexer.location_finder` | `atoolo_index.indexer.location_finder` |
| `atoolo_search.indexer.status_store` | `atoolo_index.indexer.status_store` |
| `atoolo_search.indexer.configuration_loader` | `atoolo_index.indexer.configuration_loader` |
| `atoolo_search.indexer.indexer_collection` | `atoolo_index.indexer.indexer_collection` |
| `atoolo_search.indexer.console.progress_bar` | `atoolo_index.indexer.console.progress_bar` |
| `Atoolo\Search\Console\Application` | `Atoolo\Index\Console\Application` |

### Tags and parameters

| Deprecated | Use |
| --- | --- |
| `atoolo_search.indexer` | `atoolo_index.indexer` |
| `atoolo_search.indexer.sitekit.content_matcher` | `atoolo_index.indexer.sitekit.content_matcher` |
| `atoolo_search.indexer.time_limit` | `atoolo_index.indexer.time_limit` |
| `atoolo_search.indexer.memory_limit` | `atoolo_index.indexer.memory_limit` |

The tag `atoolo_search.indexer.document_enricher.schema2x` is schema specific
and stays as it is.

### Commands

| Deprecated | Use |
| --- | --- |
| `search:indexer` | `index:indexer` |
| `search:indexer:update-internal-resources` | `index:update` |
| `search:dump-index-document` | `index:dump-document --source internal` |

### Indexer status file

The indexer status is cached under `%kernel.cache_dir%` and the file name lost
its search-bundle prefix: `atoolo.search.index.<key>.status.json` is now
`atoolo.index.<key>.status.json`. Right after the update the status of a
source reads `UNKNOWN` until it runs once - the same thing that happens on
every deploy, because the cache directory is cleared anyway.

### Dumped document

`IndexDocumentDumper::dump()` returns the documents instead of their field
arrays, and the console command encodes them. For the Solr target that also
means dates are now written as Solr dates instead of as a spelled out
`DateTime` object.
