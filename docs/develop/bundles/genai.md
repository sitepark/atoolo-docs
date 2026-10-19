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

The connection is held as its parts, the same way the
[search bundle](search/index.md) holds the Solr connection, so that each one
can be set on its own:

| Environment variable | Default | Purpose |
| --- | --- | --- |
| `GENAI_SCHEME` | `http` | scheme of the GenAI application |
| `GENAI_HOST` | `localhost` | host of the GenAI application |
| `GENAI_PORT` | `8080` | port of the GenAI application |
| `GENAI_PATH` | _empty_ | path the GenAI application is served under |
| `GENAI_API_KEY` | _empty_ | sent as `X-API-Key`, only when set |
| `GENAI_IDLE_TIMEOUT` | `300` | seconds to wait for the next byte of an answer |

Without any of them the bundle talks to `http://localhost:8080`. An
environment that knows the application as one address can set `GENAI_URL`
instead, e.g. `https://genai.example.com:8443/genai`; it is taken apart into
the parts, the same way `SOLR_URL` works for the search bundle.

Without an API key the GenAI application rejects the indexing, so
`GENAI_API_KEY` has to be set wherever the bundle indexes.

`GENAI_IDLE_TIMEOUT` is not the duration of a request but the time the bundle
waits for the application to send something. The application answers a bulk
update only once it has embedded every changed document of it, so the default
is generous.

### Client ip

The GenAI application limits the questions per ip address. Every question and
every feedback is therefore sent with the ip of the visitor in
`X-Forwarded-For`. It is the ip Symfony determines for the request, so if the
website runs behind a proxy or load balancer, it has to be configured as a
[trusted proxy](https://symfony.com/doc/current/deployment/proxies.html){:target="\_blank"}.
Otherwise every visitor is sent with the ip of the proxy and they all share
one limit.

A `X-Forwarded-For` the visitor sends along is not passed on, as it could be
forged to get around the limit. The GenAI application in turn should trust the
header only from the website.

## Indexing

The GenAI indexer reads the same resources as the Solr indexer and therefore
works under the same source, `internal`. It is told apart by its id `genai`,
which selects it on the console and in the schedule. The CMS configures it in
`configs/indexer/genai.php`, so it can be enabled separately from the Solr
indexer (`internal.php`); without that file it is not offered.

```sh
bin/console index:indexer --indexer genai
```

Resources the CMS publishes or depublishes reach the GenAI index through the
[resource change notification](resource.md#resource-change-notification), the
same way as the Solr index. See also [Indexing](../../operate/indexing.md).

A full run is a sync: every document carries a `hash` of its content, and the
GenAI application only embeds the documents whose hash changed. The others
just take over the process id of the run, and at the end of it everything the
run did not write is purged. The status of the indexer shows how many
documents were unchanged.

**The index is the channel.** The GenAI application separates its indices by
the channel, the way Solr does by its cores. The name of the channel is the
search index of the [resource channel](../../concepts/resource-channel.md),
the same for every language.

**Only the channel language.** For now only the resources in the language of
the channel are indexed, translations are left out.

!!! warning

    The GenAI index knows no access rights. The documents carry no access
    groups, so an answer may be built from protected content. Do not index a
    channel with protected content as long as that is the case.

### The document

The GenAI application knows four kinds of document, told apart by `type`:

- `article` - a page, made of the sections the editor arranged: text blocks
  keep their HTML, link lists their links. The contact point and its opening
  hours become sections of their own. Next to the `headline`, an article
  carries a `kicker` - inherited from the navigation if the page has none -
  and an `intro`.
- `media` - a binary asset with the text the CMS extracted from it.
- `knowledge` - a knowledge entry: one HTML `text` without page of its own,
  so without url, date, categories or archive. The application finds it with
  a search of its own and cites it as the internal knowledge base. Resources
  of the object types in `GENAI_KNOWLEDGE_OBJECT_TYPES` are knowledge
  entries, and so are the files of `configs/genai/knowledge` (see below).
- `glossary` - the `entries` of a glossary, each with `terms` and an
  `expansion`, from the files of `configs/genai/glossary`. The glossaries of
  a channel together are the glossary the application normalizes and
  searches its questions with; a glossary is neither chunked nor embedded.

Articles and media carry `id`, `channel`, `source`, `processId`,
`objectType`, `title`, `url`, `date`, `categories`, `keywords` and `hash`. The url is absolute, as the
application links it as the source of an answer. `keywords` are terms the
document is to be found by although its text may not contain them - the
keywords of the metadata, and the synonyms other bundles add. Fields that are
not set are left out.

To dump what an index run would send:

```sh
bin/console index:dump-document --indexer genai /path/to/resource.php
```

### Glossary and knowledge entries of the configuration

The CMS keeps a glossary and knowledge entries as configuration of the
resource channel. Every file returns an array and carries the id of its CMS
resource, which is the id of the document:

```php
// configs/genai/glossary/<name>.php: one glossary
<?php return [
    'id' => 40540,
    'title' => 'Stadtteile',           // optional, else the file name
    'definitions' => [
        ['terms' => ['OB'], 'definition' => 'Oberbürgermeister'],
        ['terms' => ['perso', 'persi'], 'definition' => 'Personalausweis'],
    ],
];

// configs/genai/knowledge/<name>.php: one knowledge entry
<?php return [
    'id' => 40541,
    'headline' => 'Stuttgart 21 – Aktueller Stand',
    'keywords' => ['S21'],             // optional
    'text' => ['modelType' => 'html.richText', 'text' => '<p>…</p>'],
];
```

They are data of the internal resource channel and are sent with the source
`internal`: a full run of the GenAI indexer sends all of them with its process
id, so that the purge closing the run keeps them; a
[resource change notification](resource.md#resource-change-notification) of
one of the files sends them again, and a removed one is deleted by the id of
its resource. The CMS reports a change of such a file with the publication
type `CONFIG`, since IES 3.27 with the ies-webnode admin module; an older CMS
reports the publication of a configuration as a removal. Only the German
files are read, the translations are left out.
A term must contain neither a comma nor an equals sign.

### Custom Document Enricher

`DefaultGenAiDocumentEnricher` fills the document from a SiteKit resource. Own
enricher are registered with the tag of this bundle:

```yaml
services:
  Atoolo\Examples\GenAi\Indexer\Enricher\CustomDocumentEnricher:
    tags:
      - { name: "atoolo_genai.indexer.document_enricher", priority: 10 }
```

To add terms without overwriting those of other enricher, use
`GenAiDocument::addKeywords()`.

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
| feedback | GraphQL `POST /graphql`, mutation `answerFeedback(feedbackToken!, feedback)` |

An empty bulk sends no request at all. The errors GraphQL reports with status
200 are treated as a failed request as well. The GraphQL requests carry the
[client ip](#client-ip) in `X-Forwarded-For`.

## Assistant

The assistant asks the GenAI application a question and passes on the
feedback of a user on the answer. Following the
[errors as data](../graphql/error-handling.md#errors-as-data) pattern, the
result is modelled as the application delivers it: `ask()` returns a
`QuestionResult`, which is an `Answer` or one of the errors that say why the
question was not answered - `NoDocumentsError`, `NoMatchingDocumentsError`,
`AnswerCutOffError` or `UnansweredError` for an error of the application the
bundle does not know yet. Every result carries an `id` and a `feedbackToken`
to give feedback with. The `sections` of an answer are an
`AnswerTextSection` with `html` or an `AnswerLinksSection` with `links`, each
with its `sources`. Only a `NoMatchingDocumentsError` has `hints` how to ask
more precisely and `suggestedQuestions`.

```php
$result = $assistant->ask(new Question(
    'When is the next council meeting?',
    ResourceLanguage::of('en'),
    ['10'], // category ids, optional
));

if ($result instanceof Answer) {
    foreach ($result->sections as $section) {
        echo $section->headline;
        if ($section instanceof AnswerTextSection) {
            echo $section->html;
        }
        if ($section instanceof AnswerLinksSection) {
            foreach ($section->links as $link) {
                echo $link->label . ': ' . $link->url;
            }
        }
        foreach ($section->sources as $source) {
            echo $source->url;
        }
    }
} elseif ($result instanceof NoMatchingDocumentsError) {
    // $result->hints, $result->suggestedQuestions
}

if ($result->feedbackToken !== null) {
    $assistant->feedback($result->feedbackToken, AnswerFeedback::GOOD);
}
```

A question that cannot be asked at all - not accepted by the application,
too many requests, the application not available - throws an
`AssistantException` with its `AssistantErrorType`.

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
