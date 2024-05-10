# Schema Types


## Query (RootQuery)
<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>indexerStatus</strong></td>
<td valign="top"><a href="#indexerstatus">IndexerStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>suggest</strong></td>
<td valign="top"><a href="#suggestresult">SuggestResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">input</td>
<td valign="top"><a href="#suggestinput">SuggestInput</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>ping</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>search</strong></td>
<td valign="top"><a href="#searchresult">SearchResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">input</td>
<td valign="top"><a href="#searchinput">SearchInput</a>!</td>
<td></td>
</tr>
</tbody>
</table>

## Mutation (RootMutation)
<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>index</strong></td>
<td valign="top"><a href="#indexerstatus">IndexerStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>indexUpdate</strong></td>
<td valign="top"><a href="#indexerstatus">IndexerStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">paths</td>
<td valign="top">[<a href="#string">String</a>!]!</td>
<td>

List of resource paths that are to be updated.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>indexRemove</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">idList</td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td>

list of id's of the entries to be deleted

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>indexAbort</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
</tbody>
</table>

## Objects

### ArticleTeaser

An article teaser is a short summary or preview designed to pique the reader's interest by highlighting the main points or most exciting aspects of an article.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

Teaser URL

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>date</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

Teaser date

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser headline

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser kicker text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>asset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

Teaser asset can be e.g. pictures or videos

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The teaser variant is used to decide which image format is to be returned.

</td>
</tr>
</tbody>
</table>

### Facet

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>hits</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### FacetGroup

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>facets</strong></td>
<td valign="top">[<a href="#facet">Facet</a>!]!</td>
<td></td>
</tr>
</tbody>
</table>

### Hierarchy

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>root</strong></td>
<td valign="top"><a href="#resource">Resource</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>primaryParent</strong></td>
<td valign="top"><a href="#resource">Resource</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>primaryPath</strong></td>
<td valign="top">[<a href="#resource">Resource</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>children</strong></td>
<td valign="top">[<a href="#resource">Resource</a>!]</td>
<td></td>
</tr>
</tbody>
</table>

### Image

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>copyright</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>caption</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>alternativeText</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>original</strong></td>
<td valign="top"><a href="#imagesource">ImageSource</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>characteristic</strong></td>
<td valign="top"><a href="#imagecharacteristic">ImageCharacteristic</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>sources</strong></td>
<td valign="top">[<a href="#imagesource">ImageSource</a>!]!</td>
<td></td>
</tr>
</tbody>
</table>

### ImageSource

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>variant</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>width</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>height</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>mediaQuery</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### IndexerStatus

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>startTime</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>endTime</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>lastUpdate</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>total</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>processed</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>skipped</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>updated</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>errors</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>statusLine</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### MediaTeaser

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

Teaser URL

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>contentType</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>contentLength</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### NewsTeaser

An news teaser is a short summary or preview designed to pique the reader's interest by highlighting the main points or most exciting aspects of an article.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

Teaser URL

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>date</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

News Teaser date

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

News Teaser headline

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

News Teaser text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>asset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

Teaser asset can be e.g. pictures or videos

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The teaser variant is used to decide which image format is to be returned.

</td>
</tr>
</tbody>
</table>

### Resource

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>name</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>location</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>objectType</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>teaser</strong></td>
<td valign="top"><a href="#teaser">Teaser</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>navigation</strong></td>
<td valign="top"><a href="#hierarchy">Hierarchy</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SearchResult

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>total</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>queryTime</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>offset</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>limit</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>results</strong></td>
<td valign="top">[<a href="#resource">Resource</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>facetGroups</strong></td>
<td valign="top">[<a href="#facetgroup">FacetGroup</a>!]!</td>
<td></td>
</tr>
</tbody>
</table>

### SuggestResult

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>suggestions</strong></td>
<td valign="top">[<a href="#suggestion">Suggestion</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>queryTime</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### Suggestion

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>term</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>hits</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

## Inputs

### AbsoluteDateRangeInputFacet

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>from</strong></td>
<td valign="top"><a href="#datetime">DateTime</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>to</strong></td>
<td valign="top"><a href="#datetime">DateTime</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>gap</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
</tbody>
</table>

### AbsoluteDateRangeInputFilter

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>from</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>to</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputFacet

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>excludeFilter</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>objectTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>categories</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>sites</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>groups</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>absoluteDateRange</strong></td>
<td valign="top"><a href="#absolutedaterangeinputfacet">AbsoluteDateRangeInputFacet</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>relativeDateRange</strong></td>
<td valign="top"><a href="#relativedaterangeinputfacet">RelativeDateRangeInputFacet</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputFilter

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>key</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>objectTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>categories</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>sites</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>groups</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>absoluteDateRange</strong></td>
<td valign="top"><a href="#absolutedaterangeinputfilter">AbsoluteDateRangeInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>relativeDateRange</strong></td>
<td valign="top"><a href="#relativedaterangeinputfilter">RelativeDateRangeInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>archive</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>and</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>or</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>not</strong></td>
<td valign="top"><a href="#inputfilter">InputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>query</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputSortCriteria

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>name</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>headline</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>date</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>natural</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>score</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
</tbody>
</table>

### RelativeDateRangeInputFacet

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>base</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>before</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>after</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>gap</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>roundStart</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>roundEnd</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
</tbody>
</table>

### RelativeDateRangeInputFilter

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>base</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>before</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>after</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>roundStart</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>roundEnd</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
</tbody>
</table>

### SearchInput

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>offset</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>limit</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>lang</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>defaultQueryOperator</strong></td>
<td valign="top"><a href="#queryoperator">QueryOperator</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>sort</strong></td>
<td valign="top">[<a href="#inputsortcriteria">InputSortCriteria</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>filter</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>facets</strong></td>
<td valign="top">[<a href="#inputfacet">InputFacet</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>timeZone</strong></td>
<td valign="top"><a href="#datetimezone">DateTimeZone</a></td>
<td></td>
</tr>
</tbody>
</table>

### SuggestInput

<table>
<thead>
<tr>
<th colspan="2" align="left">Field</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>text</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>limit</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>lang</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>filter</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
</tbody>
</table>

## Enums

### DateRangeRound

<table>
<thead>
<th align="left">Value</th>
<th align="left">Description</th>
</thead>
<tbody>
<tr>
<td valign="top"><strong>START_OF_DAY</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>START_OF_PREVIOUS_DAY</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_DAY</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_PREVIOUS_DAY</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>START_OF_MONTH</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>START_OF_PREVIOUS_MONTH</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_MONTH</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_PREVIOUS_MONTH</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>START_OF_YEAR</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>START_OF_PREVIOUS_YEAR</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_YEAR</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>END_OF_PREVIOUS_YEAR</strong></td>
<td></td>
</tr>
</tbody>
</table>

### ImageCharacteristic

<table>
<thead>
<th align="left">Value</th>
<th align="left">Description</th>
</thead>
<tbody>
<tr>
<td valign="top"><strong>NORMAL</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>INFOGRAPHIC</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>DECORATIVE_IMAGE</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>DECORATIVE_IMAGE_NOT_CUT</strong></td>
<td></td>
</tr>
</tbody>
</table>

### QueryOperator

<table>
<thead>
<th align="left">Value</th>
<th align="left">Description</th>
</thead>
<tbody>
<tr>
<td valign="top"><strong>AND</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>OR</strong></td>
<td></td>
</tr>
</tbody>
</table>

### SortDirection

<table>
<thead>
<th align="left">Value</th>
<th align="left">Description</th>
</thead>
<tbody>
<tr>
<td valign="top"><strong>ASC</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>DESC</strong></td>
<td></td>
</tr>
</tbody>
</table>

## Scalars

### Boolean

The `Boolean` scalar type represents `true` or `false`.

### DateInterval

### DateTime

### DateTimeZone

### ID

The `ID` scalar type represents a unique identifier, often used to
refetch an object or as key for a cache. The ID type appears in a JSON
response as a String; however, it is not intended to be human-readable.
When expected as an input type, any string (such as `"4"`) or integer
(such as `4`) input value will be accepted as an ID.

### Int

The `Int` scalar type represents non-fractional signed whole numeric
values. Int can represent values between -(2^31) and 2^31 - 1. 

### String

The `String` scalar type represents textual data, represented as UTF-8
character sequences. The String type is most often used by GraphQL to
represent free-form human-readable text.


## Interfaces


### Asset

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>copyright</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>caption</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong>description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### Teaser

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong>url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

Teaser URL

</td>
</tr>
</tbody>
</table>
