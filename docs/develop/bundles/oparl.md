# OParl Bundle

Indexes the data of a council information system into the search index via
its [OParl](https://oparl.org){:target="\_blank"} API: meetings, papers,
organizations, persons, agenda items and files.

The bundle provides one indexer per OParl type on top of the
[index bundle](index-bundle.md). The data is fetched with
[sitepark/oparl-client](https://github.com/sitepark/oparl-php-client){:target="\_blank"}
and written to the Solr index of the [search bundle](search/index.md).

## Sources

The sources can be accessed via the GitHub project [https://github.com/sitepark/atoolo-oparl-bundle](https://github.com/sitepark/atoolo-oparl-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

```sh
composer require atoolo/oparl-bundle
```

The bundle and the [index bundle](index-bundle.md) have to be registered in
`config/bundles.php`:

```php
return [
    // ...
    Atoolo\Index\AtooloIndexBundle::class => ['all' => true],
    Atoolo\Oparl\AtooloOparlBundle::class => ['all' => true],
];
```

## Indexers

| Source               | OParl type   | OParl version |
| -------------------- | ------------ | ------------- |
| `oparl-meeting`      | Meeting      | 1.0, 1.1      |
| `oparl-paper`        | Paper        | 1.0, 1.1      |
| `oparl-organization` | Organization | 1.0, 1.1      |
| `oparl-person`       | Person       | 1.0, 1.1      |
| `oparl-agendaItem`   | AgendaItem   | 1.1           |
| `oparl-file`         | File         | 1.1           |

Each indexer fetches the list of its type from every configured body of the
OParl system. Every indexer has its own status, schedule and cleanup, so a
project only switches on the types it needs.

### CMS side configuration

An indexer is only active if the CMS provides its configuration
`configs/indexer/<source>.php` - see
[CMS side configuration](index-bundle.md#cms-side-configuration). Without the
file a scheduled run is skipped. This is usually done via a configuration
article in the CMS: an object type of the customer module in the group
*Indexer* of the *Module Administration*, which writes the file.

```php
<?php
// configs/indexer/oparl-meeting.php
return [
    'name' => 'Ratsinformationssystem - Sitzungen',
    'data' => [
        'systemUrl' => 'https://ris.example.org/oparl/v1.1',
        'bodyUrls' => ['https://ris.example.org/oparl/v1.1/body/1'],
        'cleanupThreshold' => 10,
        'chunkSize' => 500,
        'fullSyncInterval' => 24,
        'modifiedSinceOverlap' => 300,
        'omitInternal' => false,
        'group' => 1234,
        'groupPath' => [1, 12, 1234],
        'category' => [5678],
        'categoryPath' => [56, 5678],
    ],
];
```

| Key                    | Default | Description                                                                                                                                  |
| ---------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `systemUrl`            |         | Entry point of the OParl API, the `System` object. All bodies of the system are indexed. Required if `bodyUrls` is not set.                    |
| `bodyUrls`             | `[]`    | Only these bodies instead of all bodies of the system.                                                                                       |
| `cleanupThreshold`     | `10`    | A full run only deletes stale documents if it wrote at least this many documents. `0` never deletes.                                          |
| `chunkSize`            | `500`   | Documents per update request.                                                                                                                |
| `fullSyncInterval`     | `24`    | Hours between two full runs, see [Full and delta runs](#full-and-delta-runs). With `0` every run is a full run.                              |
| `modifiedSinceOverlap` | `300`   | Seconds subtracted from the last run for `modified_since`.                                                                                   |
| `omitInternal`         | `false` | Let the server leave out embedded objects, e.g. the agenda items of a meeting. The responses get smaller, the full text content gets thinner. |
| `group`                |         | Pool ID written to `sp_group` of the documents, so that a search can filter by it. The CMS is not affected. |
| `groupPath`            | `[]`    | Pool IDs of the path to `group`, written to `sp_group_path`.                                                                                 |
| `category`             | `[]`    | IDs of the categories linked to the documents (`sp_category`).                                                                               |
| `categoryPath`         | `[]`    | IDs of the linked categories and of their parent categories (`sp_category_path`).                                                            |

Further keys are passed on to the enricher and filter of a project as
`$parameter->data`.

### Scheduling

The indexers are scheduled through the
[scheduler of the index bundle](index-bundle.md#scheduler):

```yaml
parameters:
  atoolo_index.indexer.schedules:
    oparl-meeting: "15 * * * *"
    oparl-paper: "30 * * * *"
```

!!! warning

    `atoolo_index.indexer.schedules` is one parameter for all indexers of a
    project, including the ones of other bundles such as `internal`. Symfony
    does not merge parameters - set it in one place with all sources,
    otherwise one definition replaces the other.

The schedule is processed by the [worker](../../operate/worker.md). An indexer
can also be started manually, see [Indexing](../../operate/indexing.md):

```sh
bin/console index:indexer --source oparl-meeting
```

## Full and delta runs

The lists of an OParl API are paginated and can have hundreds of pages, a
complete run can take several minutes. A run is therefore either

- a **full run**, fetching every object. Afterwards it deletes every document
  of the source that it did not write, if it wrote at least
  `cleanupThreshold` documents - a server that returns an empty list by
  mistake must not empty the index.
- a **delta run**, fetching only the objects modified since the last
  successful run (`modified_since`). Objects the server reports as deleted
  are removed from the index, everything else stays untouched.

A full run is done if the last one is longer ago than `fullSyncInterval`
hours. Only a run that completed and whose updates all succeeded is
remembered. After an error, a failed update or an abortion the next run
starts over from the same point, and a full run deletes nothing then.

!!! note

    Some OParl servers answer a `modified_since` query that has no result with
    an error instead of an empty list. Such a delta run ends with an error, the
    index stays unchanged and the next change is fetched by the following run.
    With `fullSyncInterval` set to `0` every run is a full run and no
    `modified_since` query is made.

## Mapping

The documents are filled by enricher tagged
`atoolo_oparl.indexer.document_enricher.schema2x`. The common fields are set
with priority 100, the fields of each type with priority 50.

| Field                                         | Content                                                                                                                    |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `id`                                          | OParl id of the object (URL)                                                                                               |
| `url`                                         | Page of the object in the council information system (`web`), otherwise the object in the API. A paper links to its main file, a file to itself. |
| `contenttype`                                 | `text/html` for `web`, `application/json` for the API, the MIME type for a file                                             |
| `sp_source`                                   | Source of the indexer, e.g. `oparl-meeting`                                                                                |
| `title`, `sp_name`, `sp_title`, `sp_sortvalue` | Name of the object                                                                                                         |
| `sp_date`, `sp_date_from`, `sp_date_to`       | Start and end of a meeting or agenda item, date of a paper or file, period of an organization                              |
| `sp_changed`                                  | `modified` of the object                                                                                                   |
| `content`                                     | Full text: names, reference, location, agenda items of a meeting, text of a file                                           |
| `keywords`                                    | `keyword` of the object                                                                                                    |
| `sp_meta_string_oparl_*`                      | Type specific fields, e.g. `oparl_reference` and `oparl_paper_type` of a paper, `oparl_meeting_state` of a meeting          |

A paper additionally sets its paper type as `sp_meta_string_kicker`.

The bundle sets neither `sp_id` nor `sp_objecttype`: both refer to resources
of the CMS. `description` is not set either. It is used as teaser text, but
OParl offers no such text for most objects - a project that wants one sets it
in an enricher of its own.

### Custom Document Enricher

A project adds or overwrites fields with an enricher of its own and a lower
priority. The options of the CMS side configuration are available in
`$parameter->data`.

```php
declare(strict_types=1);

namespace App\Indexer;

use Atoolo\Index\Service\Indexer\IndexDocument;
use Atoolo\Oparl\Dto\Indexer\OparlIndexerParameter;
use Atoolo\Oparl\Service\Indexer\OparlDocumentEnricher;
use Atoolo\Search\Service\Indexer\IndexSchema2xDocument;
use SP\OparlClient\V1\Objects\OparlObjectV1;
use SP\OparlClient\V1\Objects\OparlPaper;

/**
 * @implements OparlDocumentEnricher<IndexSchema2xDocument>
 */
class PaperKickerEnricher implements OparlDocumentEnricher
{
    public function enrichDocument(
        OparlObjectV1 $object,
        OparlIndexerParameter $parameter,
        IndexDocument $doc,
        string $processId,
    ): IndexDocument {
        if (
            !$object instanceof OparlPaper
            || !$doc instanceof IndexSchema2xDocument
        ) {
            return $doc;
        }

        $doc->setMetaString('kicker', 'Drucksache ' . $object->getReference());

        return $doc;
    }
}
```

```yaml
services:
  App\Indexer\PaperKickerEnricher:
    tags:
      - { name: "atoolo_oparl.indexer.document_enricher.schema2x", priority: 10 }
```

The enricher of the bundle only use what the object itself contains and
resolve no references - the names of the organizations of a meeting would
cost a request each. An enricher that needs referenced objects resolves them
with the `OparlReferenceResolver` (service `atoolo_oparl.reference_resolver`),
which caches them.

## Filter

Which objects are indexed is decided by the service
`atoolo_oparl.indexer.object_filter`, an `OparlObjectFilter`. By default every
object is accepted. A project replaces the service to leave objects out. An
object that is not accepted is removed from the index, should it have been
indexed before. The filter is shared by all OParl indexers,
`$parameter->source` tells which one calls it.

```php
declare(strict_types=1);

namespace App\Indexer;

use Atoolo\Oparl\Dto\Indexer\OparlIndexerParameter;
use Atoolo\Oparl\Service\Indexer\OparlObjectFilter;
use SP\OparlClient\V1\Objects\OparlFile;
use SP\OparlClient\V1\Objects\OparlObjectV1;

/**
 * Only objects with a page to link to.
 */
class WebPageFilter implements OparlObjectFilter
{
    public function accept(
        OparlObjectV1 $object,
        OparlIndexerParameter $parameter,
    ): bool {
        if ($object instanceof OparlFile) {
            return $object->getAccessUrl() !== null;
        }
        return $object->getWeb() !== null;
    }
}
```

```yaml
services:
  atoolo_oparl.indexer.object_filter:
    class: App\Indexer\WebPageFilter
```

## Cache

The state of the delta runs and the objects resolved with the
`OparlReferenceResolver` are kept in the cache pool `atoolo_oparl.cache`. By
default this is a filesystem cache in `var/oparl`, outside of the kernel cache
directory, so that `cache:clear` keeps it. Losing it is harmless, the next run
is a full run.

```sh
bin/console cache:pool:clear atoolo_oparl.cache
```

The pool is configured like any other cache pool, e.g. with Redis to share it
between several servers:

`config/packages/cache.yaml`

```yaml
parameters:
  redis_host: "%env(REDIS_HOST)%"
  env(REDIS_HOST): localhost

framework:
  cache:
    default_redis_provider: "redis://%redis_host%"
    pools:
      atoolo_oparl.cache:
        adapter: cache.adapter.redis
```

## Parameters

| Parameter                                            | Default            | Description                                                                                                                                       |
| ---------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `atoolo_oparl.http_client.options`                   | `timeout: 30`, `max_duration: 300`, `max_redirects: 5` | Options of the [Symfony HTTP client](https://symfony.com/doc/current/http_client.html#configuration){:target="\_blank"} used for all requests, e.g. `proxy` |
| `atoolo_oparl.http_client.max_retries`               | `3`                | Retries of a failed request                                                                                                                       |
| `atoolo_oparl.reference_cache_ttl`                   | `86400`            | Seconds the `OparlReferenceResolver` caches an object                                                                                             |
| `atoolo_oparl.reference_resolver.max_memory_entries` | `2000`             | Objects the `OparlReferenceResolver` keeps in memory during a run, `0` keeps none                                                                 |
| `atoolo_oparl.cache_dir`                             | `%kernel.project_dir%/var/oparl` | Directory of the default cache pool                                                                                                   |

The parameters apply to all OParl indexers. Without a `proxy` option, the
proxy is taken from the environment (`HTTPS_PROXY`, `NO_PROXY`).
