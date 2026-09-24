# GenAI Bundle

Indexes [resources](resource.md) into an external GenAI application - embedding
and vector database - and asks that application questions. The GenAI
technology itself is not part of the bundle, just as the Solr server is not
part of the [search bundle](search/index.md).

The bundle has two areas:

- **Indexer** — the GenAI application as a target of the
  [index bundle](index-bundle.md)
- **Assistant** — asking the GenAI application questions

## Sources

The sources can be accessed via the GitHub project [https://github.com/sitepark/atoolo-genai-bundle](https://github.com/sitepark/atoolo-genai-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

```sh
composer require atoolo/genai-bundle
```

The bundle and the index bundle have to be registered in
`config/bundles.php`:

```php
return [
    // ...
    Atoolo\Index\AtooloIndexBundle::class => ['all' => true],
    Atoolo\GenAi\AtooloGenAiBundle::class => ['all' => true],
];
```

## Configuration

| Environment variable | Default | Purpose |
| --- | --- | --- |
| `GENAI_URL` | `http://localhost:8080` | base url of the GenAI application |
| `GENAI_API_KEY` | _empty_ | sent as `Authorization: Bearer`, only when set |
| `GENAI_TIMEOUT` | `30` | request timeout in seconds |

## Indexing

The indexer runs under the source `genai` and is configured by the CMS in
`configs/indexer/genai.php`, so it can be enabled separately from the solr
indexer (`internal.php`).

```sh
bin/console index:indexer --source genai
```

Resources the CMS publishes or depublishes reach the GenAI index through the
[resource change notification](resource.md#resource-change-notification), the
same way as the Solr index.

**One index per channel.** Embedding models are multilingual, so the documents
carry `language` and `locale` instead of being spread over language specific
indices.

### The document

`GenAiDocument` is the payload. Its property names are the JSON keys, so the
mapping lives in the property names and nowhere else:

`id`, `source`, `process_id`, `url`, `title`, `headline`, `description`,
`language`, `locale`, `object_type`, `content_type`, `content_types`,
`keywords`, `categories`, `category_names`, `category_path`, `group`,
`group_path`, `sites`, `include_groups`, `exclude_groups`, `archived`,
`changed`, `generated`, `date`, `date_list`, `valid_from`, `valid_until`,
`content`, `content_hash`, `meta`

Fields that were never set are left out of the payload, dates are formatted as
`DATE_ATOM`, and `content_hash` is a `sha256:` digest of title, description and
content, so the GenAI application can skip documents whose indexed content did
not change.

To dump what an index run would send:

```sh
bin/console index:dump-document --source genai /path/to/resource.php
```

In an application that has both bundles installed, the same resource dumped
with `--source internal` shows the Solr document and with `--source genai` the
GenAI document; without `--source` the command asks.

### Custom Document Enricher

`DefaultGenAiDocumentEnricher` fills the document from a SiteKit resource. Own
enricher are registered with the tag of this bundle:

```yaml
services:
  Atoolo\Examples\GenAi\Indexer\Enricher\CustomDocumentEnricher:
    tags:
      - { name: "atoolo_genai.indexer.document_enricher", priority: 10 }
```

### Scheduling

Through the index bundle:

```yaml
parameters:
  atoolo_index.indexer.schedules:
    genai: "0 3 * * *"
```

## HTTP contract

The GenAI application is addressed under `{GENAI_URL}/api/v1`:

| Purpose | Request | Response |
| --- | --- | --- |
| health | `GET /health` | 2xx |
| managed indices | `GET /indices` | `{"indices":[{"name":"www","documents":123}]}` |
| bulk update | `PUT /indices/{index}/documents` | `{"accepted":n,"rejected":m,"errors":{"<id>":"msg"}}` |
| delete by id | `POST /indices/{index}/documents/delete` | `{"deleted":n}` |
| cleanup by process id | `POST /indices/{index}/documents/cleanup` | `{"deleted":n}` |
| commit | `POST /indices/{index}/commit` | 2xx/204 |
| ask | `POST /indices/{index}/ask` | `{"answer":"…","conversation_id":"…","sources":[…]}` |

An empty bulk sends no request at all.

## Assistant

```php
$answer = $assistant->ask(new Question(
    'When is the next council meeting?',
    ResourceLanguage::of('de'),
));

echo $answer->text;
foreach ($answer->sources as $source) {
    echo $source->url;
}
```

From the console:

```sh
bin/console genai:ask "When is the next council meeting?" --lang de
```
