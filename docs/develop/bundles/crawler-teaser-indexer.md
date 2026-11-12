# Crawler Teaser Indexer Bundle

This bundle provides a simple crawler designed to generate teasers from external sources and indexing them into the Apache Solr search platform. This ensures that the teasers are discoverable via the website's search function. The process utilizes a PHP array containing the data that the crawler need to extract. You can extract the Title, Introtext, Date and DateTime.

## Sources

The sources can be accessed via the GitHub project [Crawler Teaser Indexer Bundle](https://github.com/sitepark/atoolo-crawler-teaser-indexer){:target="\_blank"}

---

## Installation

The application was developed as a Symfony bundle and is distributed as a Composer package.

### Install the module via Composer

```sh
composer require atoolo/crawler-teaser-indexer
```

### Register Bundle

  config/bundles.php: `Atoolo\CrawlerIndexer\AtooloCrawlerTeaserIndexerBundle::class => ['all' => true],`

### Resolve all dependencies

```sh
composer update
```

### Run the application

The command crawls and indexes all configured sites one after another. It uses the same logic as the scheduled run.

```sh
bin/console crawler:scheduler-atoolo-crawler-teaser-indexer -vvv
```

The command returns a non-zero exit code if at least one site failed.

[Atoolo Indexer Docs](../../operate/indexing.md)

---

## Quick start Guide

### Install the module, in your project, via Composer

```sh
composer require atoolo/crawler-teaser-indexer
```

- Register Bundle in config/bundles.php: `Atoolo\CrawlerIndexer\AtooloCrawlerTeaserIndexerBundle::class => ['all' => true],`

### Create this file in your Project

```sh
config/packages/atoolo_crawler_master.yaml
```

### Copy this in the `atoolo_crawler_master.yaml`

```yaml
parameters:
  # Defines execution schedule
  atoolo.crawler.schedule:
    - '0 3 * * *'

  # Status codes that trigger retries
  atoolo.crawler.retry_status_codes:
    - 408
    - 429
    - 500
    - 502
    - 503
    - 504

  # URL endings that are never followed (applies to all sites)
  atoolo.crawler.deny_endings:
    - .jpg
    - .png
    - .pdf
    - .zip
```

### Minimal PHP-Array configuration

The file has to be located in the `indexer` directory of the configuration directory of your resource channel: `<config-dir>/indexer/atooloTeaserCrawler.php`

Fill out the fields: `sp_id`, `sp_url` and `sp_title_css`. All other keys are optional and fall back to their defaults (see [Site-Specific Configurations](#site-specific-configurations)).

```php
<?php return [
  "name" => "Indexer für externe Teaser",
  "data" => [
    "sp_crawling_sites" => [
      [
        "sp_id" => "!To Fill in the Pagename in snakecase!",
        "sp_max_teaser" => "100",
        "sp_cleanup_threshold" => "10",
        "sp_parallel_requests" => "3",
        "sp_delay_ms" => "500",
        "sp_user_agent" => "ExampleBot/1.0 (+contact@example.org)",
        "sp_start_urls" => [
          [
            "sp_url" => "!To Fill in the startpage absolute url!",
            "sp_extraction_depth" => "2",
          ],
        ],
        "sp_link_selector" => "#content a[href]",
        "sp_allow_prefixes" => [
          "https://",
        ],
        "sp_title_prefix" => "Pagename - ",
        "sp_title_opengraph" => ["og:title"],
        "sp_title_css" => [
          "!To Fill in the Title CssSelector!",
          "#content h2",
        ],
      ],
    ],
  ],
];
```

!!! note
    `sp_cleanup_threshold` defaults to `50`. A crawl that indexes no more than this number of teasers counts as failed (see [Run and error handling](#run-and-error-handling)). Set it below the number of teasers you expect.

### Run the Crawler

```sh
bin/console crawler:scheduler-atoolo-crawler-teaser-indexer -vvv
```

### Search in the Solr-index

Search the Solr index for the value defined in the `sp_id` field of the PHP configuration array. It is written to the fields `sp_source` and `sp_objecttype`.

### Worker Configuration

The schedule is executed by a Symfony Messenger worker (see [Atoolo Worker Docs](../../operate/worker.md)).
The worker has to consume the scheduler transport of the crawler:

`scheduler_atoolo-crawler-teaser-indexer`

With Symfony 7.1 or later, `messenger:consume --all` includes it. With older versions, every
transport has to be listed explicitly in the `command` of the Supervisor configuration:

```ini
command=/path/to/app/bin/console messenger:consume scheduler_atoolo-crawler-teaser-indexer <other transports>
```

Apply the changed Supervisor configuration (only the changed programs are restarted):

```sh
supervisorctl reread && supervisorctl update
```

Check that the schedule is registered and the worker consumes it:

```sh
bin/console debug:scheduler atoolo-crawler-teaser-indexer
ps aux | grep "messenger:consume"
```

!!! note
    If the worker does not consume the transport, the schedule is never executed and nothing is logged.

Several worker processes (e.g. `numprocs=2`) may consume the transport. The schedule is locked per search index, so only one of them starts the crawler. The lock uses the lock store of the project (`framework.lock`, default `flock`), which only works across processes on the same host. If the workers run on several hosts, configure a shared store (e.g. Redis or a database).

#### Missed runs

The scheduler stores its state (the last scheduled date it handled) in the application cache (`cache.app`). If no worker was running at a scheduled date, e.g. during a restart or a downtime, the crawler catches up as soon as a worker runs again, **once**, even if several dates were missed. A date that becomes due while a crawl is still running is not covered by it and leads to one more crawl afterwards.

!!! note
    By default `cache.app` lives in the cache directory of the project, and `bin/console cache:clear` empties it. A date missed during a deployment is therefore not caught up; the crawler runs again at the next scheduled date. Configure a persistent adapter for `cache.app` (e.g. Redis) if this matters.

---

## How it works

The crawler runs per site as a pipeline of four steps. The steps are chained lazily: pages are fetched, parsed and cleaned while the indexer consumes them.

```
URLCollector ──▶ Parser ──▶ Processor ──▶ Indexer
(crawl + fetch)  (extract)   (clean)       (Solr)
```

1. **URLCollector** crawls breadth-first from the start URLs and fetches every page exactly once, in chunks of `sp_parallel_requests`. Discovered links are brought into a canonical form and then filtered (allow/deny prefixes, deny endings, robots.txt).
2. **Parser** extracts title, intro text and datetime. OpenGraph tags are tried first, then the CSS selectors. With `sp_split_html_document` one page can yield several teasers. If content scoring is active, irrelevant teasers are dropped here.
3. **Processor** removes HTML and scripts, decodes entities and truncates the texts to their maximum length (the ellipsis `…` is included in the length).
4. **Indexer** removes duplicate teasers (same title, intro text and date), writes the documents to Solr and removes the old documents of the site.

### Run and error handling

- A problem with a single page or teaser (unreachable URL, missing title, missing required field, unparsable date) is logged and the page or teaser is skipped.
- A failing site never stops the run: the remaining sites are still crawled.
- Old documents of a site are only removed if **more than** `sp_cleanup_threshold` teasers were indexed. Otherwise the run of this site counts as failed and the old documents stay in the index. This protects the index if the external site is down or its markup changed.
- Invalid cron expressions in `atoolo.crawler.schedule` stop the scheduler with an error.
- Only one worker starts the scheduled crawl, and missed dates are caught up with a single crawl (see [Missed runs](#missed-runs)). A skipped date is logged as `Crawler run due at … skipped`.
- A site without `sp_id` is invalid and skipped.

---

## Configuration

### Central Orchestrating Configuration

Location in your Project:  
`config/packages/atoolo_crawler_master.yaml`

Purpose:

- Specifies when the crawler is executed
- Specifies status codes to retry
- Specifies URL endings that are never followed on any site

The data from this file is injected via configuration.  
Therefore, after changes the cache must be rebuilt:

```sh
./bin/console cache:clear
```

```yaml
parameters:
  # Defines execution schedule
  # - Cron expression (5 fields)
  # - Format:
  # ┌ Minute (0–59)
  # │ ┌ Hour (0–23)
  # │ │ ┌ Day of month (1–31)
  # │ │ │ ┌ Month (1–12)
  # │ │ │ │ ┌ Day of week (0–6, Sun=0)
  # │ │ │ │ │
  # * * * * *

  # Example:
  # schedule (field 1): 0      → minute
  # schedule (field 2): 3      → hour
  # schedule (field 3): */3    → every 3 days
  # schedule (field 4-5): * *  → every month, every weekday
  atoolo.crawler.schedule:
    - '0 3 * * *'
    - '15 3 * * *'

  # Status codes that trigger retries
  atoolo.crawler.retry_status_codes:
    - 408
    - 429
    - 500
    - 501
    - 502
    - 503
    - 504

  # URL endings that are never followed (merged with sp_deny_endings of each site)
  atoolo.crawler.deny_endings:
    # Images & graphics
    - .jpg
    - .jpeg
    - .png
    - .gif
    - .svg
    - .webp
    # Documents
    - .pdf
    - .doc
    - .docx
    # Archives
    - .zip
    - .gz
    # Web assets & data
    - .js
    - .css
    - .json
    - .xml
    # Media & fonts
    - .mp3
    - .mp4
    - .woff
    - .woff2
```

## Site-Specific Configurations

The file `<config-dir>/indexer/atooloTeaserCrawler.php` returns an array with a list of sites in `data.sp_crawling_sites`. Each site is configured with the `sp_*` keys described below.

- Missing keys fall back to their default value.
- Invalid values (e.g. a string where a list is expected) are logged as a warning and the default is used.
- Lists are always lists, even with a single entry.

A full example configuration can be found in: [https://github.com/sitepark/atoolo-crawler-teaser-indexer/blob/main/config/example/exampleConfig.php](https://github.com/sitepark/atoolo-crawler-teaser-indexer/blob/main/config/example/exampleConfig.php){:target="\_blank"}

### Category

```php
    # Category IDs written to every teaser of this site (Solr field sp_category)
    "sp_categories" => [1525, 1523, 1524],

    # Category path IDs written to every teaser of this site (Solr field sp_category_path)
    "sp_categories_path" => [1525, 1528, 1524],
```

### Core / Meta

```php
  # Required. Unique ID for this website configuration.
  # Used as source of the documents in Solr (sp_source, sp_objecttype).
  "sp_id" => "source_pagename",

  # Respect robots.txt (default: false)
  # Only applied if sp_robots_url is set. If the robots.txt cannot be read,
  # all URLs are allowed.
  "sp_respect_robots_txt" => false,

  # Absolute URL of the robots.txt of the target domain
  "sp_robots_url" => "https://www.example.com/robots.txt",

  # Maximum number of pages fetched while crawling (default: 100)
  # The crawl stops once this number of pages has been fetched.
  # sp_forced_article_urls are not counted.
  "sp_max_teaser" => "100",

  # Old documents of this site are only removed from Solr if MORE than
  # this number of teasers was indexed (default: 50)
  "sp_cleanup_threshold" => "50",

  # Maximum number of retries for a failed request (default: 3)
  # 0 means only one attempt (no retries)
  "sp_max_retry" => "3",

  # Delay before the first retry in milliseconds (default: 500)
  # The delay doubles with every retry (500, 1000, 2000, ...).
  # A Retry-After header of the target system takes precedence.
  "sp_backoff_ms" => "500",

  # Minimum delay between two requests to the same host in milliseconds (default: 150)
  # (increase if the target system blocks requests)
  "sp_delay_ms" => "500",

  # Number of requests sent in parallel (default: 1; recommended 1–3, never above 10)
  "sp_parallel_requests" => "3",

  # Clearly identifiable User-Agent (default: "Atoolo/Crawler-Teaser-Indexer")
  "sp_user_agent" => "ExampleBot/1.0 (+contact@example.org)",
```

### URLCollector (Discovery)

All discovered URLs are brought into a canonical form first: lowercase scheme and host, no default port (80/443), configured query parameters and fragments removed. The prefix rules below are compared against this form, so configure them accordingly (e.g. a lowercase host).

```php
  # Start URLs for the crawler
  # sp_extraction_depth: links are followed from the start page (depth 0)
  # up to this depth; the pages found at the next level are still fetched,
  # but their links are not followed.
  # Example with 2: start page → level 1 → level 2 → level 3 (leaf pages)
  "sp_start_urls" => [
      [
          "sp_url" => "https://www.example.com/microsite/index.php",
          "sp_extraction_depth" => 2
      ],
      [
          "sp_url" => "https://www.example.com/",
          "sp_extraction_depth" => 1
      ]
  ],

  # CSS selector for the links to follow (default: #content a[href])
  "sp_link_selector" => "#content a[href]",

  # Allowed URL prefixes (whitelist)
  # If set, a URL must start with one of them.
  "sp_allow_prefixes" => [
      "https://www.example.com/microsite/"
  ],

  # Explicit exclusions of URL prefixes (blacklist)
  "sp_deny_prefixes" => [
      "https://www.example.com/microsite/meta/",
      "https://www.example.com/microsite/about_us/team.php"
  ],

  # Additional URL endings that are not followed on this site
  # Merged with atoolo.crawler.deny_endings, compared case-insensitively
  # against the URL path.
  "sp_deny_endings" => [
      ".ics",
      ".vcf"
  ],

  # URLs that are always fetched and always pass the content scoring,
  # independent of sp_max_teaser. They are still skipped if no title
  # can be determined.
  "sp_forced_article_urls" => [
      "https://www.example.com/microsite/important-page.php"
  ],

  # Remove query parameters from discovered URLs (default: false)
  # The parameters are removed permanently: the URL without them is
  # fetched and indexed. This avoids fetching the same page several times.
  "sp_strip_query_params_active" => true,

  "sp_strip_query_params" => [
      "utm_source",
      "utm_medium",
      "sort",
      "view",
      "print",
      "fbclid",
      "gclid"
  ],

  # Remove the fragment (#...) from URLs starting with one of these prefixes
  # Example: page.php#contact and page.php#directions are fetched once as page.php
  "sp_strip_fragments" => [
      "https://www.example.com/"
  ]
```

### Parser

Default values should always be provided for selectors to ensure flexibility.
The Symfony CSS-Selector package is used to extract teaser content.
The configured values are passed directly to the package.

For every field the OpenGraph tags are tried first (`<meta property="…">`), then the CSS selectors in the configured order. The first value found wins.

#### Example CSS Selectors

- HTML tag: "h1"
- ID selector: "#content #page-title"
- Class selector: "#content .page-title"

#### Split a page into several teasers

```php
  # XPath expressions (not CSS selectors) that split one page into
  # several teasers, e.g. an overview page with a list of events.
  # Every matched element becomes its own teaser; all selectors below
  # are then evaluated inside that element only.
  # If a matched element contains another matched element, only the
  # inner one is used.
  # Without a value, no match or an invalid expression, the whole page
  # is one teaser.
  "sp_split_html_document" => [
      "//article",
      "//*[@id='content']//div[contains(@class, 'event')]"
  ],
```

All teasers of a split page share the URL of the page.

#### Title

The title is always required: a page or block without a title is skipped.

```php
  # Used to clearly identify the article's source
  "sp_title_prefix" => "Pagename - ",

  # OpenGraph tags are preferred when extracting data
  "sp_title_opengraph" => [
      "og:title"
  ],

  # CSS selectors (skipped if empty)
  "sp_title_css" => [
      "h1",
      ".page-title",
      "#content h2"
  ],

  # Maximum character length including the "…" appended when truncated
  # (default: 999)
  "sp_title_max_chars" => 120
```

#### Intro Text

```php
  # Enable intro text extraction (default: false)
  "sp_introText_present" => true,

  # If true, the teaser is skipped if no intro text is found (default: false)
  "sp_introText_required_field" => false,

  # Preferred OpenGraph tags
  "sp_introText_opengraph" => [
      "og:description"
  ],

  # CSS selectors (skipped if empty)
  "sp_introText_css" => [
      "#content p",
      "main p",
      ".description"
  ],

  # Maximum character length including the "…" appended when truncated
  # (default: 999)
  "sp_introText_max_chars" => 200
```

#### DateTime

```php
  # Enable DateTime extraction (default: false)
  "sp_datetime_present" => false,

  # If true, the teaser is skipped if no valid DateTime is found (default: false)
  "sp_datetime_required_field" => false,

  # If only a date is present, append 00:00:00 (default: true)
  # Example:
  # "2026-01-21" → "2026-01-21 00:00:00"
  # Solr requires DateTime, not Date Type
  "sp_datetime_only_date" => true,

  # Preferred OpenGraph tags
  "sp_datetime_opengraph" => [
      "article:published_time"
  ],

  # CSS selectors (skipped if empty)
  # The datetime attribute of the element is preferred over its text,
  # e.g. <time datetime="2026-01-21">21. Januar</time>.
  # The value has to be a date format PHP can parse.
  "sp_datetime_css" => [
      "time[datetime]",
      ".published-date",
      ".article-date"
  ]
```

### Filter Function "Utility Score" (Content Filter)

Content scoring keeps only relevant teasers when a site yields too many of them. Every teaser starts with a score of 0, the matching rules add their `sp_score`, and only teasers reaching `sp_content_scoring_min_score` are indexed.

How the rules are matched:

- `sp_match_any` matches if **one** of the keywords occurs in the visible text of title, intro text and main content (case-insensitive substring, whitespace normalized). URLs, HTML markup and scripts are not matched.
- `sp_condition.sp_body_text_length` matches if the visible text of intro text and main content is **shorter** than the given number of characters. It is meant for penalizing pages with little content.
- Each rule counts once, no matter how many keywords match.
- Negative rules need a negative `sp_score`: all scores are added up.
- Teasers whose URL contains a fragment (`#`) get an additional -2.
- `sp_forced_article_urls` always pass.

```php
  # Enable content scoring (default: false)
  "sp_content_scoring_active" => true,

  # Minimum required score for a teaser to be indexed (default: 4)
  "sp_content_scoring_min_score" => 7,

  # CSS selectors for the main content that is scored
  # The first selector that yields text is used; without a value or
  # without a match, the visible text of the whole page (or split block)
  # is scored.
  "sp_relevance_content_selector" => [
      "#content",
      "main"
  ],

  # Positive signals (increase score)
  "sp_content_scoring_positive" => [
      [
          "sp_score" => 4,
          "sp_match_any" => [
              "online application",
              "book appointment",
              "submit application"
          ]
      ],
      [
          "sp_score" => 1,
          "sp_match_any" => [
              "procedure",
              "legal basis",
              "further information"
          ]
      ]
  ],

  # Negative signals (decrease score)
  "sp_content_scoring_negative" => [
      [
          "sp_score" => -6,
          "sp_match_any" => [
              "newsletter",
              "advertising",
              "press office"
          ]
      ],
      [
          # Pages with less than 150 characters of text
          "sp_score" => -3,
          "sp_condition" => [
              "sp_body_text_length" => 150
          ]
      ]
  ]
```

---

## Extending the crawler

All pipeline steps are Symfony services registered by their interface. A project can change the behavior without forking the bundle.

The steps are shared services that live for the whole run. The configuration of the current site (`PipelineConfig`) is passed with every call and must not be stored in a property.

### Decorate a pipeline step

Every step can be decorated with `#[AsDecorator]`:

| Interface | Responsibility |
|-----------|----------------|
| `Pipeline\Collector\URLCollectorInterface` | Crawl and fetch the pages |
| `Pipeline\Collector\LinkFilterInterface` | Decide which links are followed |
| `Pipeline\Fetcher\FetcherInterface` | Fetch a chunk of URLs |
| `Pipeline\Parser\ParserInterface` | Extract the teasers from the HTML |
| `Pipeline\RelevanceEvaluator\RelevanceEvaluatorInterface` | Content scoring |
| `Pipeline\Processor\ProcessorInterface` | Clean and truncate the texts |
| `Pipeline\Indexer\IndexerInterface` | Write to Solr |

All interfaces are in the namespace `Atoolo\CrawlerIndexer`. Several decorators of the same step are stacked by their `priority`.

Example: never follow links to print versions.

```php
<?php

declare(strict_types=1);

namespace App\Crawler;

use Atoolo\CrawlerIndexer\Config\PipelineConfig;
use Atoolo\CrawlerIndexer\Pipeline\Collector\LinkFilterInterface;
use Symfony\Component\DependencyInjection\Attribute\AsDecorator;
use Symfony\Component\DependencyInjection\Attribute\AutowireDecorated;

#[AsDecorator(LinkFilterInterface::class)]
final class NoPrintLinkFilter implements LinkFilterInterface
{
    public function __construct(
        #[AutowireDecorated] private readonly LinkFilterInterface $inner,
    ) {}

    public function filter(array $urls, PipelineConfig $config): array
    {
        return array_values(array_filter(
            $this->inner->filter($urls, $config),
            static fn (string $url): bool => !str_contains($url, '/print/'),
        ));
    }
}
```

### Replace the extraction of a single field

If OpenGraph and CSS selectors are not enough for a field, implement `Pipeline\Parser\FieldExtractorInterface`. Implementations are tagged automatically and asked before the built-in extraction. Splitting, required fields, the title prefix and content scoring stay with the parser.

- `supports()` returns whether the extractor handles a field (`FIELD_TITLE`, `FIELD_INTRO_TEXT`, `FIELD_DATETIME`). Return `false` for unknown fields.
- `extract()` returns a `string` for title and intro text, a `\DateTimeInterface` for the datetime, or `null` to fall through to the next extractor and finally to the built-in extraction.
- The `FieldSource` gives read access to the current page or split block: `text()`, `visibleText()`, `attr()` and `meta()`. Do not store it.
- Exceptions and values of the wrong type are logged and the built-in extraction takes over.

Example: read the date from a `data-date` attribute.

```php
<?php

declare(strict_types=1);

namespace App\Crawler;

use Atoolo\CrawlerIndexer\Config\PipelineConfig;
use Atoolo\CrawlerIndexer\Pipeline\Parser\FieldExtractorInterface;
use Atoolo\CrawlerIndexer\Pipeline\Parser\FieldSource;

final class DataDateExtractor implements FieldExtractorInterface
{
    public function supports(string $field): bool
    {
        return self::FIELD_DATETIME === $field;
    }

    public function extract(string $field, FieldSource $source, PipelineConfig $config): mixed
    {
        $raw = $source->attr('.event', 'data-date');
        if (null === $raw || 'example_events' !== $config->id()) {
            return null;
        }

        return \DateTimeImmutable::createFromFormat('d.m.Y', $raw) ?: null;
    }
}
```
