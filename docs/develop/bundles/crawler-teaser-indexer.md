# Crawler Teaser Indexer Bundle

This bundle provides a simple crawler designed to generate teasers from external sources and indexing them into the Apache Solr search platform. This ensures that the teasers are discoverable via the website's search function. The process utilizes a PHP array containing the data that the crawler need to extract. You can extract the Title, Introtext, Date and DateTime.

## Sources

The sources can be accessed via the GitHub project [Crawler Teaser Indexer Bundle](https://github.com/sitepark/atoolo-crawler-teaser-indexer)

---

## Installation

The application was developed as a Symfony bundle and is distributed as a Composer package.

### Install the module via Composer

```sh
composer require atoolo/crawler-teaser-indexer
```

### Register Bundle

  config/bundles.php: `Atoolo\Crawler\AtooloCrawlerTeaserIndexerBundle::class => ['all' => true],`

### Resolve all dependencies

```sh
composer update
```

### Run the application

```sh
  docker compose exec -u ${UID} fpm /var/www/fillTheBlank/www bin/console crawler:index -vvv
```

[Atoolo Indexer Docs](https://sitepark.github.io/atoolo-docs/operate/indexing/)

### Run without indexing

```sh
  bin/console crawler:index
```

---

## Quick start Guide

### Install the module, in your project, via Composer

```sh
composer require atoolo/crawler-teaser-indexer
```

- Register Bundle in config/bundles.php: `Atoolo\Crawler\AtooloCrawlerTeaserIndexerBundle::class => ['all' => true],`

### Create this file in your Project

```sh
config/packages/atoolo_crawler_master.yaml
```

### Copy this in the `atoolo_crawler_master.yaml`

```yaml
parameters:
  # Defines execution schedule
  atoolo.crawler.schedule:
    - 0 3 * * *
    - 15 3 * * *

  # Status codes that trigger retries
  atoolo.crawler.retry_status_codes: 
    408
    429
    500
    501
    502
    503
    504
```

### Minimal PHP-Array configuration

The file have to be located in: `base_dir/indexer/atooloTeaserCrawler.php`

Fill out the fields: sp_id, sp_url and sp_title_css.

```php
<?php return [
  "name" => "Indexer für externe Teaser",
  "data" => [
    "sp_crawling_sites" => [
      [
        "sp_id" => "!To Fill in the Pagename in snakecase!",
        "sp_respect_robots_txt" => false,
        "sp_robots_url" => "",
        "sp_max_teaser" => "11",
        "sp_max_retry" => "3",
        "sp_parallel_requests" => "3",
        "sp_delay_ms" => "500",
        "sp_user_agent" => "EntwicklungBot/1.0 (+contact@example.org)",
        "sp_start_urls" => [[
            "sp_url" => "!To Fill in the startpage absolute url!",
            "sp_extraction_depth" => "2"
        ]],
        "sp_link_selector" => "#content a[href]",
        "sp_allow_prefixes" => [
            "https://"
        ],
        "sp_deny_prefixes" => [],
        "sp_deny_endings" => [],
        "sp_forced_article_urls" => [],
        "sp_strip_query_params_active" => false,
        "sp_strip_query_params" => [],
        "sp_title_prefix" => "Pagename - ",
        "sp_title_opengraph" => ["og:title"],
        "sp_title_css" => [
            "!To Fill in the Title CssSelector!"
            "#content h2",
            ".service-detail h2",
            "#content h3"
        ],
        "sp_title_max_chars" => "",
        "sp_introText_present" => false,
        "sp_introText_required_field" => false,
        "sp_introText_opengraph" => [],
        "sp_introText_css" => [],
        "sp_introText_max_chars" => "",
        "sp_datetime_present" => false,
        "sp_datetime_required_field" => false,
        "sp_datetime_only_date" => false,
        "sp_datetime_opengraph" => [],
        "sp_datetime_css" => [],
        "sp_content_scoring_active" => false,
        "sp_content_scoring_min_score" => "",
        "sp_content_scoring_positive" => []
        "sp_content_scoring_negative" => []
      ]
    ]
  ]
];
```

### Run the Crawler

```sh
  docker compose exec -u ${UID} fpm /var/www/fillTheBlank/www bin/console crawler:index -vvv
```

### Search in the Solr-index

Search the Solr index for the value defined in the `sp_id` field of the PHP configuration array.

### Worker Configuration

You need a Worker to run the Scheduler
 [Atoolo Scheduler Docs](https://github.com/sitepark/atoolo-docs/blob/dcd815492e937ebfd929cdf4b96f1641613d4646/docs/operate/worker.md)

---

## Configuration

### Central Orchestrating Configuration

Location in your Project:  
`config/packages/atoolo_crawler_master.yaml`

An example configuration lay in: [PHP Array Config Example](https://github.com/sitepark/atoolo-crawler-teaser-indexer/blob/main/config/example/exampleConfig.php)

Purpose:

- Specifies when each site crawler is executed
- Specifies statuscodes to retry

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
    - 0 3 * * *
    - 15 3 * * *
  
  # Status codes that trigger retries
  atoolo.crawler.retry_status_codes: 
    408
    429
    500
    501
    502
    503
    504
```

## Site-Specific Configurations

Warnings will be thrown in the test environment and at runtime if configurations are missing.
This data is in a two-dimensional array.

A full example configuration can be found in: `https://github.com/sitepark/atoolo-crawler-teaser-indexer/blob/main/config/example/exampleConfig.php`

### Category

```php
    # An id for a categorie
    "sp_categories" => [1525, 1523, 1524],
    
    # An id for groups of categories
    "sp_categories_path" => [1525, 1528, 1524],
```

### Core / Meta

```php
  # Unique ID for this website configuration (used for Solr)
  "sp_id" => "source_pagename",

  # Respect robots.txt
  "sp_respect_robots_txt" => false,
  
  # Correct robots.txt URL of the target domain
  "sp_robots_url" => "https://www.example/robots.txt",
  
  # Limit the number of detected teasers
  # Teasers are extracted from the first X detected URLs
  "sp_max_teaser" => "100",

  # Minimum teaser list length required for successful indexing in Solr.
  "sp_cleanup_threshold" => "50",
  
  # Maximum number of retry attempts for unreachable URLs
  # Retries use exponential backoff: 1s, 2s, 4s, 8s, etc.
  # 0 means only one attempt (no retries)
  "sp_max_retry" => "3",
  
  # Delay between requests in milliseconds
  # (increase if the target system blocks requests)
  "sp_delay_ms" => "500",
  
  # Maximum parallel requests per host (recommended 1–3, never above 10)
  "sp_parallel_requests" => "3",
  
  # Clearly identifiable User-Agent
  "sp_user_agent" => "Atoolo/Crawler-Teaser-Indexer/1.0 (+contact@example.org)"

```

### URLCollector (Discovery)

```php
  # Start URLs for the crawler
  # extraction_depth: crawl depth (homepage → teaser → detail page)
  "sp_start_urls" => [
      [
          "sp_url" => "https://www.example/microsite/index.php",
          "sp_extraction_depth" => 2
      ],
      [
          "sp_url" => "https://www.example/",
          "sp_extraction_depth" => 2
      ]
  ],
  
  # Selector for links (recommended: #content a[href])
  "sp_link_selector" => "#content a[href]",
  
  # Allowed URL prefixes (whitelist)
  "sp_allow_prefixes" => [
      "https://www.example/microsite/"
  ],
  
  # Explicit exclusions of URL prefixes (blacklist)
  "sp_deny_prefixes" => [
      "https://www.example/microsite/meta/",
      "https://www.example/index.php?sp%3Aout=sitemap",
      "https://www.example/microsite/about_us/team.php",
      "https://www.example/microsite/about_us/Classes.php",
      "https://www.example/microsite/about_us/E-Mail-Contakt.php",
      "https://www.example/microsite/about_us/Business.php",
      "https://www.example/microsite/service/SEPA-Info.php"
  ],
  
  # Explicit exclusions of URL endings
  "sp_deny_endings" => [
      # Images & graphics
      ".jpg", ".jpeg", ".png", ".gif", ".svg", ".webp", ".ico", ".bmp", ".tiff",
      # Documents
      ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".odt", ".rtf",
      # Archives
      ".zip", ".tar", ".gz", ".7z", ".rar", ".iso",
      # Web assets & data
      ".js", ".css", ".json", ".xml", ".map", ".webmanifest",
      # Media
      ".mp3", ".mp4", ".wav", ".avi", ".mov", ".mkv", ".webm", ".ogg",
      # Fonts & miscellaneous
      ".woff", ".woff2", ".ttf", ".eot", ".exe", ".bin"
  ],
  
  # Teasers are always included in the final result
  # unless the title cannot be determined
  "sp_forced_article_urls" => [
      "https://www.example"
  ],
  
  # URL normalization
  # Query parameters are temporarily removed to detect duplicate URLs
  # and later reattached.
  "sp_strip_query_params_active" => true,
  
  "sp_strip_query_params" => [
      "page",
      "p",
      "offset",
      "sort",
      "view",
      "print",
      "fbclid",
      "gclid"
  ]
```

### Parser

Default values should always be provided for selectors to ensure flexibility.
The Symfony CSS-Selector package is used to extract teaser content.
The configured values are passed directly to the package.

#### Example CSS Selectors

- HTML tag: "h1"
- ID selector: "#content #page-title"
- Class selector: "#content .page-title"

#### Title

```php
  # Title is mandatory; otherwise the article is not indexed
  "sp_title_present" => true,
  
  # Used to clearly identify the article's source
  "sp_title_prefix" => "Pagename - ",
  
  # OpenGraph tags are preferred when extracting data
  "sp_title_opengraph" => [
      "og:title"
  ],
  
  # CSS selectors (skipped if empty)
  # Example CSS Selectors:
  # - HTML tag: "h1"
  # - ID selector: "#content #page-title"
  # - Class selector: "#content .page-title"
  "sp_title_css" => [
      "h1",
      ".page-title",
      "#content h2"
  ],
  
  # Maximum character length (text is truncated and "..." appended)
  "sp_title_max_chars" => 120
```

#### Intro Text

```php
  # Intro text is optional
  "sp_introText_present" => true,
  
  # If false, the teaser can remain even if the field is missing
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
  
  # Maximum character length (text is truncated and "..." appended)
  # null = no limit
  "sp_introText_max_chars" => 200
```

#### DateTime

```php
  # Enable DateTime extraction
  "sp_datetime_present" => false,
  
  # If true, the teaser is excluded if no DateTime is found
  "sp_datetime_required_field" => false,
  
  # If only a date is present, append 00:00:00
  # Example:
  # "2026-01-21" → "2026-01-21 00:00:00"
  # Solr requires DateTime, not Date Type
  "sp_datetime_only_date" => true,
  
  # Preferred OpenGraph tags
  "sp_datetime_opengraph" => [
      "article:published_time",
      "datePublished"
  ],
  
  # CSS selectors (skipped if empty)
  "sp_datetime_css" => [
      ".published-date",
      ".article-date",
      ".created-at"
  ]
```

### Filter Function "Utility Score" (Content Filter)

```php
  # Enable content scoring
  "sp_content_scoring_active" => false,
  
  # Minimum required score for a teaser to be indexed
  "sp_content_scoring_min_score" => 7,
  
  # Positive signals (increase score)
  "sp_content_scoring_positive" => [
      [
          "sp_score" => 6,
          "sp_match_any" => [
              "vr-bis-detail/dienstleistung"
          ]
      ],
      [
          "sp_score" => 4,
          "sp_match_any" => [
              "onlinedienstleistung",
              "online-antrag",
              "online apply",
              "onlineantrag",
              "form",
              "appointment booking",
              "book appointment",
              "submit application",
              "apply digitally"
          ]
      ],
      [
          "sp_score" => 1,
          "sp_match_any" => [
              "procedure",
              "process",
              "legal basis",
              "forms and links",
              "downloads",
              "further information"
          ]
      ],
      [
          "sp_score" => 3,
          "sp_condition" => [
              "sp_body_text_length" => 350
          ]
      ]
  ],
  
  # Negative signals (decrease score)
  "sp_content_scoring_negative" => [
      [
          "sp_score" => -12,
          "sp_match_any" => [
              "vr-bis-detail/mitarbeiter"
          ]
      ],
      [
          "sp_score" => -6,
          "sp_match_any" => [
              "test service",
              "asset publisher",
              "newsletter",
              "advertising",
              "press office"
          ]
      ],
      [
          "sp_score" => -3,
          "sp_condition" => [
              "sp_body_text_length" => 150
          ]
      ]
  ]
```
