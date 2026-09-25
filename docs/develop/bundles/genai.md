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

The bundle prepends nothing but `{GENAI_URL}` to the path, because the GenAI
application serves its parts under different roots:

| Purpose | Request |
| --- | --- |
| health | `GET /actuator/health` (`{"status":"UP"}`) |
| bulk update | `POST /api/index/documents`, body is a bare list of documents, answers `{documents, chunks, unchanged}` |
| delete by id | `POST /api/index/documents/delete` `{channel, source, ids}` |
| purge by process id | `POST /api/index/purge` `{channel, source, keepProcessId}` |
| ask | GraphQL `POST /graphql`, query `question(query!, language!, channel!, categoryIds)` |
| feedback | GraphQL `POST /graphql`, mutation `answerFeedback(answerId!, feedback)` |

An empty bulk sends no request at all. The errors GraphQL reports with status
200 are treated as a failed request as well.

## Assistant

The assistant asks the GenAI application a question and passes on the
feedback of a user on the answer. The answer is structured as the application
delivers it: an `id` to give feedback with, `sections` - `TEXT` with `html`,
`LINKS` with `links`, each with its `sources` - and an `error` when the
indexed resources did not answer the question.

```php
$answer = $assistant->ask(new Question(
    'When is the next council meeting?',
    ResourceLanguage::of('en'),
    ['10'], // category ids, optional
));

if ($answer->error !== null) {
    // the sections are hints how to ask more precisely
}
foreach ($answer->sections as $section) {
    echo $section->headline;
    echo $section->html;
    foreach ($section->links as $link) {
        echo $link->label . ': ' . $link->url;
    }
    foreach ($section->sources as $source) {
        echo $source->url;
    }
}

if ($answer->id !== null) {
    $assistant->feedback($answer->id, AnswerFeedback::GOOD);
}
```

The question is asked in the channel of the site. A question without a
language is asked in the language of the channel.

### GraphQL

Asking and giving feedback are also offered as the fields `genAiQuestion` and
`genAiAnswerFeedback` of the [GraphQL API](../graphql/genai/index.md). They are
only available when the GraphQL API is installed as well, see
[GraphQL Search Bundle](graphql-search/index.md).

### Console

```sh
bin/console genai:ask "When is the next council meeting?" --lang en --category 10
```

`--category` can be given several times.
