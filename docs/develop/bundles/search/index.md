# Search Component

Provides services with which a Solr index can be filled and searched for [resources](../resource.md) via a index.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-search-bundle](https://github.com/sitepark/atoolo-search-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/search-bundle
```

## Index name

The index name is used to determine which index should be searched. An index is always assigned to a [Resource Channel](../../../concepts/resource-channel.md), and for Solr a separate full text index is created for each language, so that language-specific features such as stop words and stemming are taken into account.

The name is determined via the interface `IndexName` of the [index bundle](../index-bundle.md#index-name).

## Indexing

The indexer core is provided by the [index bundle](../index-bundle.md). This bundle contributes the **Solr target**: `SolrIndexService`, `SolrIndexUpdater` and the schema 2.x document with its enricher. Everything that is independent of the target - the `Indexer` interface, the CMS side configuration under `configs/indexer/`, the enricher mechanics, status, abortion, the console commands and the scheduler - is documented there.

The Solr indexer runs under the source `internal` and is registered by this bundle as `atoolo_search.indexer.internal_resource_indexer`.

```sh
bin/console index:indexer --source internal
```

### Protected Resources

The IES offers the option of making certain resources visible only to a defined user group. These resources are marked as "protected". The resources are indexed, but only for user groups that are authorized to see these resources. To ensure that the protected resources are also returned via the search, the group IDs of the user groups must be stored in the PHP session via the `auth-groups` key in a comma-separated form.

### Solr Xml Indexer

In order to better convert systems with existing indexers, the SolrXMLIndexer can be used to read the existing Solr-XML files and thus integrate them into the Atoolo-Indexer technology.

Example of the integration of the SolrXMLIndexer:

`services.yaml`

```yaml
customer.indexer.mysource_aborter:
  class: Atoolo\Index\Service\Indexer\IndexingAborter
  arguments:
    - "%kernel.project_dir%/var/cache/"
    - "mysource"

customer.indexer.mysource_progress_state:
  class: Atoolo\Index\Service\Indexer\IndexerProgressState
  arguments:
    - "@atoolo_index.index_name"
    - "@atoolo_index.indexer.status_store"
    - "mysource"

customer.indexer.mysource_indexer:
  class: Atoolo\Search\Service\Indexer\SolrXmlIndexer
  arguments:
    - "@atoolo_index.index_name"
    - "@customer.indexer.mysource_progress_state"
    - "@customer.indexer.mysource_aborter"
    - "@atoolo_search.indexer.solr_index_service"
    - "@atoolo_index.indexer.configuration_loader"
    - "@atoolo_search.indexer.solr_xml_reader"
    - "mysource"
  tags: ["atoolo_index.indexer"]

customer.indexer.mysource_indexer_scheduler:
  class: Atoolo\Search\Service\Indexer\SolrXmlIndexerScheduler
  arguments:
    - "0 6-20/2 * * *" # cron expression, every 2 hours from 6am to 8pm
    - "@customer.indexer.mysource_indexer"
  tags:
    - scheduler.schedule_provider: { name: "mysource-indexer-scheduler" }
```

!!! warning

    Up to `atoolo/search-bundle` 1.17 these services were named
    `Atoolo\Search\Service\Indexer\IndexingAborter`,
    `@atoolo_search.index_name` and so on, and the tag was
    `atoolo_search.indexer`. The old names still work until 2.0; see the
    [migration section](../index-bundle.md#migration-from-atoolosearch-bundle-117).

### Custom Document Enricher

Document Enricher allow the document that is passed to Solr for indexing to be enriched with the desired fields. Here it is possible to react to product or customer-specific object types and to set the document according to requirements.

The document to be filled must adhere to the schema stored in Solr. Only the fields that are known in the schema can be set. Currently the schema `2.1` is used. The implementation `IndexSchema2xDocument` of the `IndexDocument` interface is available for this purpose. The document enricher must implement the interface `DocumentEnricher`.

```php
declare(strict_types=1);

namespace Atoolo\Examples\Search\Indexer\Enricher;

use Atoolo\Resource\Resource;
use Atoolo\Index\Service\Indexer\DocumentEnricher;
use Atoolo\Index\Service\Indexer\IndexDocument;
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

The document enricher is required, for example, in the [GraphQL Search Bundle](../graphql-search/index.md). This offers a mutation that is also used by the IES to trigger indexing. See also [GraphQl Indexing](../../graphql/search/indexing.md). So that your own document enricher can be used, it must be registered as [tagged Symfony service](https://symfony.com/doc/current/service_container/tags.html){:target="\_blank"}.

`services.yaml`

```yaml
services:
  Atoolo\Examples\Search\Indexer\Enricher\CustomDocumentEnricher:
    tags:
      - {
          name: "atoolo_search.indexer.document_enricher.schema2x",
          priority: 10,
        }
```

### Custom Content Matcher

The `content` field of the Solr document is filled by the content collector of
the [index bundle](../index-bundle.md#custom-content-matcher). Own matcher are
registered there with the tag
`atoolo_index.indexer.sitekit.content_matcher`.

## Searching

You can search the index to find resources. The [Search service](https://github.com/sitepark/atoolo-search/blob/main/src/Search.php) interface is available for this purpose. The [SolrSearch](https://github.com/sitepark/atoolo-search/blob/main/src/Service/Search/SolrSearch.php) is a common implementation of this interface.

### Query

The [`search()`](https://github.com/sitepark/atoolo-search/blob/main/src/Service/Search/SolrSearch.php) method expects a [`SearchQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SearchQuery.php){:target="\_blank"} object that contains the filter rules, for example. To create a [`SearchQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SelectQuery.php){:target="\_blank"} object, only the [`SearchQueryBuilder`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SearchQueryBuilder.php){:target="\_blank"} must be used to ensure that a valid [`SearchQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SearchQuery.php){:target="\_blank"} object is always created.

Example of a query:

```php
$builder = new SearchQueryBuilder();
$builder->text('chocolate')

$query = $builder->build();
$result = $searcher->search($query);
```

#### Full text search

To find resources using a full-text search, the text is specified using the builder methode `$builder-text()`.
The index is searched for the text and the corresponding hits are returned. The search is performed word by word. If several words (separated by spaces) are entered, an OR search is carried out in the standard case and the hits must contain both words. An AND search can also be carried out. To do this, the builder method `$builder->queryDefaultOperator()` must be specified with `QueryOperator::AND`:

```php
$builder = new SearchQueryBuilder();
$builder->text('cacao coffee')
  ->defaultQueryOperator(QueryOperator::AND);
```

#### Sorting

Sort criteria can be used to specify how the result should be sorted. Multiple sorting criteria can be specified, which are applied to the result one after the other. The second sort criterion is used if the first is the same and so on.

If no sorting criterion is specified, the result is sorted by relevance. The `Score`-class is used here, which is higher the more precisely the hit matches the search.

The following sorting criteria classes are possible:

| Search criteria Class | Description                                                                                                                                                                                                                                                    |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Name`                | This is sorted by the name of the article. In some cases, the name is preceded by a numerical prefix to achieve the desired sorting in the CMS and is therefore not always identical to the headline.                                                          |
| `Headline`            | Sort by the title of the article.                                                                                                                                                                                                                              |
| `Date`                | In many cases, an editorial date can be set for the article that is used here. Otherwise it is the last modification date of the article.                                                                                                                      |
| `Natural`             | In most cases, a sort field is written to the index, which should describe the natural sorting of the entry. For normal articles, this is usually the heading. For news or events, however, it is the date, for example. This sort field is used in this case. |
| `Score`               | The score is determined during the search and describes how closely the individual hits match the search query. This sorting is useful for full-text searches in order to obtain the most accurate results first. Here it is sorted according to relevance.    |
| `Custom`              | This sort criterion allows you to use your own fields from the search index for sorting.                                                                                                                                                                       |

The sorting can be defined as follows via the QueryBuilder:

```php
$builder = new SearchQueryBuilder();
$builder->text('chocolate')
  ->sort([
    new Sort('name', SortDirection::ASC),
    new Sort('date', SortDirection::DESC)
    ]);
```

#### Filter

Filters can be defined to limit search results. The following filters are available here:

| <div style="width:12em">Filter Class</div> | Description                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ObjectTypesFilter`                        | Object types describe the different types of pages that are used in the website. These can be, for example, news pages, events, normal content pages or any other types that are part of the project.                                                                                                                                                                                                                                     |
| `ContentSectionsFilter`                    | Content section types are types of sections that are included in a page. These can be text sections, image sections and all others that the project provides for the website. For example, a search can be defined in which all pages containing a YouTube video can be found.                                                                                                                                                            |
| `CategoriesFilter`                         | The CMS can be used to define any number of category trees that can be used to categorize articles. These categories can be filtered using their ID. The hierarchy of the category is also taken into account. This means that if you filter by a category that has subcategories, the articles that are linked to the subcategory are also found.                                                                                        |
| `GroupsFilter`                             | In the CMS, articles are organized in hierarchical groups. For example, all articles in a rubric are managed in substructures of the rubric group. The groups filter can be used to restrict the search to groups. The hierarchy of the groups is also taken into account so that all articles in a group are found, even if they are contained in further nested subgroups.                                                              |
| `SitesFilter`                              | Several websites can be managed within the CMS. These can be several main websites, but also microsites that are subordinate to a main website. The Sites filter can be used to restrict the search to a single site. For example, you can define a search that only returns hits from a microsite. Without this filter, a search for the main website can be realized, for example, in which the pages of the microsites are also found. |
| `IdFilter`                                 | An IdFilter can be used to filter directly for specific resources using their IDs                                                                                                                                                                                                                                                                                                                                                         |
| `SourceFilter`                             | The source filter can be used to filter entries that have been transferred to the search index via a specific indexer                                                                                                                                                                                                                                                                                                                     |
| `ContentTypeFilter`                        | Filters according to the content type of the entry. For `text/html`, `text/html*` should also be specified, as it contains an encoding such as `text/html; charset=UTF-8`.                                                                                                                                                                                                                                                                |
| `GeoLocatedFilter`                         | This filter is used to find entries that are geo-localized.                                                                                                                                                                                                                                                                                                                                                                               |
| `SpatialOrbitalFilter`                     | Filter for a geo radius search.                                                                                                                                                                                                                                                                                                                                                                                                           |
| `SpatialArbitraryRectangleFilter`          | Filter for a geo radius search. For performance reasons, a rectangle rather than a circle is selected for the search area.                                                                                                                                                                                                                                                                                                                |
| `AbsoluteDateRangeFilter`                  | Filter that filters over an absolute date range                                                                                                                                                                                                                                                                                                                                                                                           |
| `RelativeDateRangeFilter`                  | Filter that filters over an relative date range                                                                                                                                                                                                                                                                                                                                                                                           |
| `AndFilter`                                | The AND filter is used to combine several filters. This means that only the hits are returned that match all the filters.                                                                                                                                                                                                                                                                                                                 |
| `OrFilter`                                 | The OR filter is used to combine several filters. This means that the hits are returned that match at least one of the filters.                                                                                                                                                                                                                                                                                                           |
| `NotFilter`                                | The NOT filter is used to exclude hits that match the filter.                                                                                                                                                                                                                                                                                                                                                                             |
| `QueryFilter`                              | This filter accepts a query that is passed directly to the search engine. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.                                                                                                                                                                                                                                       |

!!! warning

    `QueryFilter`: If the schema is changed, the specified queries for these filters may no longer work.

The filters can be defined as follows via the builder:

```php
$builder = new SearchQueryBuilder();
$builder->text('chocolate')
  ->filter([
    new ObjectTypesFilter(['news', 'events']),
    new CategoriesFilter(['15949']),
    new GroupsFilter(['16811']),
    new SitesFilter(['3952']),
    new AndFilter([
      new ObjectTypesFilter(['news', 'events']),
      new CategoriesFilter(['15949']),
      new GroupsFilter(['16811']),
      new SitesFilter(['3952']),
      new QueryFilter('myField:myValue'),
    ]),
    new OrFilter([
      new ObjectTypesFilter(['news', 'events']),
      new CategoriesFilter(['15949']),
      new GroupsFilter(['16811']),
      new SitesFilter(['3952']),
      new QueryFilter('myField:myValue'),
    ]),
    new NotFilter(
      new ObjectTypesFilter(['news', 'events'])
    ),
    new QueryFilter('myField:myValue')
  ]);
```

#### Filter key

A `key` can also be specified for filters. This is only necessary if the filter only influences the facet search. The key is then used for the faceted search to identify the filters that must not be taken into account. See [Facetes](#facetes).

#### Facetes

A faceted search, also known as faceted filtering, is a search technique that can be applied to various use cases to allow users to easily refine and navigate search results. It works by dividing search results into different categories or facets that are representative features or attributes of the information found.

The facet type is required to define a facet. This can be, for example, the object type and the possible values of the facet type whose results are to be returned.

The following filters are available here:

| <div style="width:11em">Facet Class</div> | Description                                                                                                                                                                                                                                                                                                                                                                                                                               |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ObjectTypesFacet`                        | Object types describe the different types of pages that are used in the website. These can be, for example, news pages, events, normal content pages or any other types that are part of the project.                                                                                                                                                                                                                                     |
| `ContentSectionsFacet`                    | Content section types are types of sections that are included in a page. These can be text sections, image sections and all others that the project provides for the website. For example, a search can be defined in which all pages containing a YouTube video can be found.                                                                                                                                                            |
| `CategoriesFacet`                         | The CMS can be used to define any number of category trees that can be used to categorize articles.                                                                                                                                                                                                                                                                                                                                       |
| `GroupsFacet`                             | In the CMS, articles are organized in hierarchical groups. For example, all articles in a rubric are managed in substructures of the rubric group. The groups filter can be used to restrict the search to groups. The hierarchy of the groups is also taken into account so that all articles in a group are found, even if they are contained in further nested subgroups.                                                              |
| `SitesFacet`                              | Several websites can be managed within the CMS. These can be several main websites, but also microsites that are subordinate to a main website. The Sites filter can be used to restrict the search to a single site. For example, you can define a search that only returns hits from a microsite. Without this filter, a search for the main website can be realized, for example, in which the pages of the microsites are also found. |
| `SourceFacet`                             | The source indicates which indexer was used to add the entry to the index                                                                                                                                                                                                                                                                                                                                                                 |
| `SourceFacet`                             | The source indicates which indexer was used to add the entry to the index                                                                                                                                                                                                                                                                                                                                                                 |
| `ContentTypeQuery`                        | Facete about the content type of the entry                                                                                                                                                                                                                                                                                                                                                                                                |
| `RelativeDateRangeFacet`                  | Facet over a date range. This can be a single value. If a `gap` is specified, the facet contains several values. In each case, the number of hits in the time window specified with `gap` within the specified time period                                                                                                                                                                                                                |
| `SpatialDistanceRangeFacet`               | This facet indicates the number of hits within a certain geo-radius.                                                                                                                                                                                                                                                                                                                                                                      |
| `FacetMultiQuery`                         | This facet contains a list of `FacetQuery` objects and combines them into a facet. This is useful if you want to combine several queries into one facet. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.                                                                                                                                                        |

!!! warning

    `FacetQuery` and `FacetMultiQuery`: If the schema is changed, the specified queries for these filters may no longer work.

A `key` must also be specified for facets. This is required so that the results of the facet can be accessed in the search result via the key.

The facet can be defined as follows via the builder:

```php
$builder = new SearchQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')
  ->facet([
    new ObjectTypesFacet('objectType', ['news', 'events']),
    new ContentSectionsFacet('contentSection', ['text', 'image']),
    new CategoriesFacet('categories', ['15949']),
    new GroupsFacet('groups', ['16811']),
    new SitesFacet('sites', ['3952']),
    new FacetQuery('myField', 'myValue'),
    new FacetMultiQuery('myMultiField', [
      new FacetQuery('myFieldA', 'myValue'),
      new FacetQuery('myFieldB', 'myValue'),
    ]),
```

Usually, you also want to filter according to a facet. However, the facet results should not be affected by the filter. A `key` can be specified for the filter for this purpose. This key is used for the facet as an exclude filter. This means that the corresponding filter is not taken into account when determining the facet.

Here is an example with a filter that contains a key

```php
$builder = new SearchQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')
  ->filter([
    new ObjectTypesFilter(['news', 'events'], 'objectType'),
  ])
  ->facet([
    new ObjectTypesFacet('objectTypeFacet', ['news', 'events'], 'objectType')
  ]);
```

#### Archive search

The indexed resources can be marked as "archived". This flag ensures that these resources are not normally included in the search. This can be used for news, for example, to include only the latest news in the general search. For a special search, such as a news archive search, the `archive` flag can be used to also find archived resources.

```php
$builder = new SearchQueryBuilder();
$builder->archive(true);
```

#### Boosting

Boosting makes it possible to increase the relevance of certain documents in the search results. This can be achieved by customizing query parameters, such as adding boosting factors to specific fields or applying custom functions. In this way, search results can be specifically influenced to place more relevant results at the top.

The following parameters can be used to influence the result:

| <div style="width:13em">Name</div> | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `queryFields`                      | This parameter specifies the fields to be searched and their relative importance. It is a list of fields, optionally with boost factors that indicate how heavily each field should be weighted when matching search terms. For example, qf=title^2.0 description means that the title field is twice as important as the description field.                                                 |
| `phraseFields`                     | This parameter increases the importance of whole phrases (word sequences) in the specified fields. It is used to increase the relevance of documents in which the search terms appear as phrases in these fields. For example, pf=title^1.5 content increases the relevance of documents in which the search terms appear as a phrase in the title field more than in the content field.     |
| `boostQueries`                     | This parameter allows additional query clauses that increase the relevance score of documents that match these clauses. These clauses do not affect whether a document matches the main query, but increase the score of documents that match them. For example, `contenttype:(text/html*)^10` would increase the relevance score of HTML documentserhöhen.                                  |
| `boostFunctions`                   | This parameter applies function-based boosts to the relevance score. These are mathematical functions that adjust the score based on field values or other criteria. For example, `if(termfreq(sp_objecttype,'news'),scale(sp_date,0,12),scale(sp_date,10,11)` could be used to score older news articles less highly                                                                        |
| `tie` (Tie-Breaker-Multiplikator)  | This parameter combine the best match points from multiple fields. The tie parameter adjusts how much lower scores affect the overall score. A higher tie value means that the lower scores have more influence on the final score. For example, tie=0.1 could be used to give the secondary fields some influence in the scoring process, preventing only the best matches from dominating. |

Setting the boosting parameters requires in-depth knowledge of how the search index works and its schema. If no boosting is specified, the default values of Sitepark are used, which have already proven themselves in many projects.

```php
$builder = new SearchQueryBuilder();
$builder->boosting(new Boosting(
  queryFields: [
    "sp_title^1.4",
    "keywords^1.2",
    "description^1.0",
    "title^1.0",
    "url^0.9",
    "content^0.8"
  ],
  phraseFields: [
    "sp_title^1.5",
    "description^1",
    "content^0.8"
  ],
  boostQueries: [
    "sp_objecttype:searchTip^100",
    "contenttype:(text/html*)^10"
  ],
  boostFunctions: [
    "if(termfreq(sp_objecttype,'news'),scale(sp_date,0,12),scale(sp_date,10,11))"
  ],
  tie: 0.1
));
```

!!! warning

    If the scheme is changed, the specified boosting may no longer work.

#### Result

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

### Searching (More like this)

A "More-Like-This" search is a technique in which a source document or item is used as a reference point to find similar documents in the search index. It is based on extracting characteristics from the source object and searching for other objects that have similar characteristics in order to present relevant results to the user.

The [`MoreLikeThisSearcher`](https://github.com/sitepark/atoolo-search/blob/main/src/MoreLikeThisSearcher.php){:target="\_blank"} service is available for this. The `moreLikeThis()` method expects a [`MoreLikeThisQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/MoreLikeThisQuery.php){:target="\_blank"} object with which the query can be defined.

The search returns a [`SearchResult`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Result/SearchResult.php){:target="\_blank"} object with which the results can be read.

The result returns the list of resources found, which can be iterated over.

```php
foreach ($result as $resource) {
  echo $resource->getLocation() . "\n";
}
```

### Suggest

A "suggest search" is a search function that automatically displays suggestions or auto-completions to users as they enter search queries.

The [`Suggest`](https://github.com/sitepark/atoolo-search/blob/main/src/Suggest.php){:target="\_blank"} service is available for this. The `moreLikeThis()` method expects a [`SuggestQuery`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Query/SuggestQuery.php){:target="\_blank"} object with which the query can be defined.

The search returns a [`SuggestResult`](https://github.com/sitepark/atoolo-search/blob/main/src/Dto/Search/Result/SuggestResult.php){:target="\_blank"} object with which the results can be read.

```php
foreach ($result as $suggest) {
  echo $suggest->term . ' (' . $suggest->hits . ")\n";
}
```

[Filters](#filter) can also be specified for the suggest search and the [archive flag](#archive-search) can be set. However, there is no builder for the suggest search; the filter and archive flag may have to be specified directly in the constructor.

## Use as a Symony service

To use the search service in a Symfony project, the service can be injected in a separate service.

Service IDs are available for the respective search service for this purpose:

| Service-Id                     | Service-Interface            |
| ------------------------------ | ---------------------------- |
| `atoolo_search.search`         | `Atoolo\Search\Search`       |
| `atoolo_search.suggest`        | `Atoolo\Search\Suggest`      |
| `atoolo_search.more_like_this` | `Atoolo\Search\MoreLikeThis` |

Mit Hilfe des Autowiring-Features von Symfony kann der Service in einem eigenen Service verwendet werden.

```php
use Atoolo\Search\Search;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

class MyService
{
    public function __construct(
        #[Autowire(service: 'atoolo_search.search')]
        private readonly Search $search
    ) {
    }

    public function doSomething(): void
    {
        $builder = new SearchQueryBuilder();
        $builder->text('test');

        $result = $this->search->search($builder->build());
    }
}
```

## Command line interface

This component also contains Symfony commands that can be integrated into Symfony projects.
`services.xml`

The commands are currently provided via the GraphQL bundle. To do this, the bundle must be integrated into the Symfony project.

The commands provided by Atoolo require the environment variable `RESOURCE_ROOT` in the rules, which defines in which directory the resources are located or which resource channel is currently to be used.

The environment variable can be set manually, but can also be determined automatically if `bin/console` is called via the resource channel path, e.g.

```sh
/var/www/example.com/www/app/bin/console ...
```

or

```sh
cd /var/www/example.com/www/
app/bin/console ...
```

The following commands are then available via `bin/console`:

| Command         | Description                      |
| --------------- | -------------------------------- |
| `search:mlt`    | Performs a more-like-this search |
| `search:search` | Performs a search                |
| `search:suggest`| Performs a suggest search        |

The indexer commands come from the [index bundle](../index-bundle.md#console-commands):
`index:indexer`, `index:update` and `index:dump-document`.

The commands `search:indexer`,
`search:indexer:update-internal-resources` and `search:dump-index-document`
still exist as deprecated aliases of these and are removed in 2.0.
