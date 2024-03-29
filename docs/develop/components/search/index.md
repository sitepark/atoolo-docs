---
status: draft
---

# Search Component

Provides services with which a Solr index can be filled and searched for [resources](../resource.md) via a index.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-search](https://github.com/sitepark/atoolo-search){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/search
```

## Indexing

To be able to search in a Solr index, it must first be filled. This is done via the indexer.

[Resources](../resource.md#the-resource) are indexed. These are stored as files in the file system. The indexer can search an entire directory structure for the resources and thus rebuild an entire index. The resources are loaded via the files and mapped to index documents. The mapping is carried out via document enricher that read the resource data and set the corresponding fields of the index document. The index document are passed to Solr so that they can be indexed. Searches can then be performed on a Solr index created in this way.

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

The document enricher is required, for example, in the [GraphQL Search Bundle](../../bundles/graphql-search.md). This offers a mutation that is also used by the CMS IES to trigger indexing. See also [GraphQl Indexing](../../graphql/search/indexing.md). So that your own document enricher can be used, it must be registered as [tagged Symfony service](https://symfony.com/doc/current/service_container/tags.html){:target="\_blank"}.

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

### Custom Content Matcher

For the full-text search, the 'content' field is filled with all content relevant to the search. It may be necessary for special content to be extracted from the resources and written to the `content` field. A `ContentMatcher` can be implemented for this purpose.

The `content` array of the resource is run through recursively and the `ContentMatcher` is called for each value. The `ContentMatcher` can then check whether the value should be written to the `content` field. The value can also be an array so that the `ContentMatcher` can extract the required value from the underlying structure.

```php
declare(strict_types=1);

namespace Atoolo\Examples\Search\Indexer\Matcher;

use Atoolo\Resource\Resource;

class CustomContentMatcher implements ContentMatcher
{
    public function match(Resource $resource, string $key, $value): string:bool
    {
        $len = count($path);
        if ($len < 2) {
            return false;
        }

        if (
            $path[$len - 2] !== 'items' ||
            $path[$len - 1] !== 'model'
        ) {
            return false;
        }

        $headline = $value['headline'] ?? false;
        return is_string($headline) ? $headline : false;
    }
}
```

So that your own content matcher can be used, it must be registered as [tagged Symfony service](https://symfony.com/doc/current/service_container/tags.html){:target="\_blank"}.

`services.yaml`

```yaml
services:
  Atoolo\Search\Service\Indexer\SiteKit\HeadlineMatcher:
    tags:
      - { name: "atoolo.search.indexer.sitekit.contentMatcher", priority: 10 }
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

#### Full text search

To find resources using a full-text search, the text is specified using the builder methode `$builder-text()`.
The index is searched for the text and the corresponding hits are returned. The search is performed word by word. If several words (separated by spaces) are entered, an AND search is carried out in the standard case and the hits must contain both words. An OR search can also be carried out. To do this, the builder method `$builder->queryDefaultOperator()` must be specified with `QueryDefaultOperator::OR`:

```php
$builder = new SelectQueryBuilder();
$builder->index('myindex-www')
  ->text('cacao coffee')
  ->queryDefaultOperator(QueryDefaultOperator::OR);
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

The sorting can be defined as follows via the QueryBuilder:

```php
$builder = new SelectQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')
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
| `SitesFilter`                              | Several websites can be managed within the CSM. These can be several main websites, but also microsites that are subordinate to a main website. The Sites filter can be used to restrict the search to a single site. For example, you can define a search that only returns hits from a microsite. Without this filter, a search for the main website can be realized, for example, in which the pages of the microsites are also found. |
| `ArchiveFilter`                            | Articles can be marked as achrivated in the CMS. This flag ensures that these articles are not normally included in the search. This can be used for news, for example, to include only the latest news in the general search. For a special search, such as a news archive search, the "Including marked as archived" filter can be used to also find archived articles.                                                                 |
| `AndFilter`                                | The AND filter is used to combine several filters. This means that only the hits are returned that match all the filters.                                                                                                                                                                                                                                                                                                                 |
| `OrFilter`                                 | The OR filter is used to combine several filters. This means that the hits are returned that match at least one of the filters.                                                                                                                                                                                                                                                                                                           |
| `NotFilter`                                | The NOT filter is used to exclude hits that match the filter.                                                                                                                                                                                                                                                                                                                                                                             |
| `QueryFilter`                              | This filter accepts a query that is passed directly to the search engine. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.                                                                                                                                                                                                                                       |

!!! warning

    `QueryFilter`: If the schema is changed, the specified queries for these filters may no longer work.

The filters can be defined as follows via the builder:

```php
$builder = new SelectQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')
  ->filter([
    new ObjectTypesFilter(['news', 'events']),
    new CategoriesFilter(['15949']),
    new GroupsFilter(['16811']),
    new SitesFilter(['3952']),
    new ArchiveFilter(false),
    new AndFilter([
      new ObjectTypesFilter(['news', 'events']),
      new CategoriesFilter(['15949']),
      new GroupsFilter(['16811']),
      new SitesFilter(['3952']),
      new ArchiveFilter(false),
      new QueryFilter('myField:myValue'),
    ]),
    new OrFilter([
      new ObjectTypesFilter(['news', 'events']),
      new CategoriesFilter(['15949']),
      new GroupsFilter(['16811']),
      new SitesFilter(['3952']),
      new ArchiveFilter(false),
      new QueryFilter('myField:myValue'),
    ]),
    new NotFilter(
      new ObjectTypesFilter(['news', 'events'])
    ),
    new QueryFilter('myField:myValue')
  ]);
```

#### Filter key

A `key` can also be specified for filters. This is only necessary if the filter only influences the facet search. The key is then used for the faceted search to identify the filters that must not be taken into account. See [Facetts](#facets)

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
| `SitesFacet`                              | Several websites can be managed within the CSM. These can be several main websites, but also microsites that are subordinate to a main website. The Sites filter can be used to restrict the search to a single site. For example, you can define a search that only returns hits from a microsite. Without this filter, a search for the main website can be realized, for example, in which the pages of the microsites are also found. |
| `FacetQuery`                              | This facet accepts a query that is passed directly to the search engine. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.                                                                                                                                                                                                                                        |
| `FacetMultiQuery`                         | This facet contains a list of `FacetQuery` objects and combines them into a facet. This is useful if you want to combine several queries into one facet. This filter should only be used in absolute exceptions where the fields of the current schema must be specified directly.                                                                                                                                                        |

!!! warning

    `FacetQuery` and `FacetMultiQuery`: If the schema is changed, the specified queries for these filters may no longer work.

A `key` must also be specified for facets. This is required so that the results of the facet can be accessed in the search result via the key.

The facet can be defined as follows via the builder:

```php
$builder = new SelectQueryBuilder();
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
$builder = new SelectQueryBuilder();
$builder->index('myindex-www')
  ->text('chocolate')
  ->filter([
    new ObjectTypesFilter(['news', 'events'], 'objectType'),
  ])
  ->facet([
    new ObjectTypesFacet('objectTypeFacet', ['news', 'events'], 'objectType')
  ]);
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
