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
<td colspan="2" valign="top"><strong id="rootquery.indexerstatus">indexerStatus</strong></td>
<td valign="top"><a href="#indexerstatus">IndexerStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootquery.suggest">suggest</strong></td>
<td valign="top"><a href="#suggestresult">SuggestResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">input</td>
<td valign="top"><a href="#suggestinput">SuggestInput</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootquery.ping">ping</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootquery.search">search</strong></td>
<td valign="top"><a href="#searchresult">SearchResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">input</td>
<td valign="top"><a href="#searchinput">SearchInput</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootquery.morelikethis">moreLikeThis</strong></td>
<td valign="top"><a href="#searchresult">SearchResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">input</td>
<td valign="top"><a href="#morelikethisinput">MoreLikeThisInput</a>!</td>
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
<td colspan="2" valign="top"><strong id="rootmutation.index">index</strong></td>
<td valign="top"><a href="#indexerstatus">IndexerStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootmutation.indexupdate">indexUpdate</strong></td>
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
<td colspan="2" valign="top"><strong id="rootmutation.indexremove">indexRemove</strong></td>
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
<td colspan="2" valign="top"><strong id="rootmutation.indexabort">indexAbort</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootmutation.webaccountauthenticationwithpassword">webAccountAuthenticationWithPassword</strong></td>
<td valign="top"><a href="#authenticationresult">AuthenticationResult</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">username</td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">password</td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">setJwtCookie</td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="rootmutation.webaccountunsetjwtcookie">webAccountUnsetJwtCookie</strong></td>
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
<td colspan="2" valign="top"><strong id="articleteaser.url">url</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser URL

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Use field 'link' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.link">link</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td>

Teaser Link

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.date">date</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

Teaser date

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.headline">headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser headline

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.kicker">kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser kicker text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.asset">asset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

Teaser asset can be e.g. pictures or videos

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.symbolicasset">symbolicAsset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

symbolic asset associated with the teaser

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="articleteaser.features">features</strong></td>
<td valign="top">[<a href="#teaserfeature">TeaserFeature</a>!]!</td>
<td>

additional, context dependent teaser features indicating information about the underling resource

</td>
</tr>
</tbody>
</table>

### AuthenticationResult

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
<td colspan="2" valign="top"><strong id="authenticationresult.status">status</strong></td>
<td valign="top"><a href="#authenticationstatus">AuthenticationStatus</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="authenticationresult.user">user</strong></td>
<td valign="top"><a href="#user">User</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### CopyrightDetails

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
<td colspan="2" valign="top"><strong id="copyrightdetails.original">original</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="copyrightdetails.author">author</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="copyrightdetails.license">license</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td></td>
</tr>
</tbody>
</table>

### EventTeaser

Event teaser

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
<td colspan="2" valign="top"><strong id="eventteaser.url">url</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser URL

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Use field 'link' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.link">link</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td>

Teaser Link

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.headline">headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser headline

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.kicker">kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser kicker text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.asset">asset</strong></td>
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
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.symbolicasset">symbolicAsset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

symbolic asset associated with the teaser

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.schedulings">schedulings</strong></td>
<td valign="top">[<a href="#scheduling">Scheduling</a>!]!</td>
<td>

schedulings

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="eventteaser.icalurl">iCalUrl</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Downlaod url for the event scheduling as an .ics file

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
<td colspan="2" valign="top"><strong id="facet.key">key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="facet.hits">hits</strong></td>
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
<td colspan="2" valign="top"><strong id="facetgroup.key">key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="facetgroup.facets">facets</strong></td>
<td valign="top">[<a href="#facet">Facet</a>!]!</td>
<td></td>
</tr>
</tbody>
</table>

### Geo

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
<td colspan="2" valign="top"><strong id="geo.primary">primary</strong></td>
<td valign="top"><a href="#geopoint">GeoPoint</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="geo.secondary">secondary</strong></td>
<td valign="top"><a href="#geojson">GeoJson</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="geo.distance">distance</strong></td>
<td valign="top"><a href="#float">Float</a></td>
<td></td>
</tr>
</tbody>
</table>

### GeoPoint

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
<td colspan="2" valign="top"><strong id="geopoint.lng">lng</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="geopoint.lat">lat</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
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
<td colspan="2" valign="top"><strong id="hierarchy.root">root</strong></td>
<td valign="top"><a href="#resource">Resource</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hierarchy.primaryparent">primaryParent</strong></td>
<td valign="top"><a href="#resource">Resource</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hierarchy.primarypath">primaryPath</strong></td>
<td valign="top">[<a href="#resource">Resource</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hierarchy.children">children</strong></td>
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
<td colspan="2" valign="top"><strong id="image.copyright">copyright</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.copyrightdetails">copyrightDetails</strong></td>
<td valign="top"><a href="#copyrightdetails">CopyrightDetails</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.caption">caption</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.alternativetext">alternativeText</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.original">original</strong></td>
<td valign="top"><a href="#imagesource">ImageSource</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.characteristic">characteristic</strong></td>
<td valign="top"><a href="#imagecharacteristic">ImageCharacteristic</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.sources">sources</strong></td>
<td valign="top">[<a href="#imagesource">ImageSource</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.static">static</strong> ⚠️</td>
<td valign="top"><a href="#imagesource">ImageSource</a>!</td>
<td>
<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

'static' might be a reserved keyword. Use field 'staticImage' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.staticimage">staticImage</strong></td>
<td valign="top"><a href="#imagesource">ImageSource</a>!</td>
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
<td colspan="2" valign="top"><strong id="imagesource.variant">variant</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesource.url">url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesource.width">width</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesource.height">height</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesource.mediaquery">mediaQuery</strong></td>
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
<td colspan="2" valign="top"><strong id="indexerstatus.starttime">startTime</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.endtime">endTime</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.lastupdate">lastUpdate</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.total">total</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.processed">processed</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.skipped">skipped</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.updated">updated</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.errors">errors</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="indexerstatus.statusline">statusLine</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### Link

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
<td colspan="2" valign="top"><strong id="link.url">url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="link.label">label</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="link.accessibilitylabel">accessibilityLabel</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="link.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="link.opensnewwindow">opensNewWindow</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="link.isexternal">isExternal</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
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
<td colspan="2" valign="top"><strong id="mediateaser.url">url</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser URL

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Use field 'link' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.link">link</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td>

Teaser Link

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.headline">headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.kicker">kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.contenttype">contentType</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.contentlength">contentLength</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.asset">asset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

Teaser asset can be e.g. pictures or videos

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.symbolicasset">symbolicAsset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

symbolic asset associated with the teaser

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="mediateaser.features">features</strong></td>
<td valign="top">[<a href="#teaserfeature">TeaserFeature</a>!]!</td>
<td>

additional, context dependent teaser features indicating information about the underling resource

</td>
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
<td colspan="2" valign="top"><strong id="newsteaser.url">url</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser URL

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Use field 'link' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.link">link</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td>

Teaser Link

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.date">date</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

News Teaser date

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.headline">headline</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

News Teaser headline

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

News Teaser text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.kicker">kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser kicker text

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.asset">asset</strong></td>
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
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.symbolicasset">symbolicAsset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td>

symbolic asset associated with the teaser

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The asset variant is used to decide which image format is to be returned.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="newsteaser.features">features</strong></td>
<td valign="top">[<a href="#teaserfeature">TeaserFeature</a>!]!</td>
<td>

additional, context dependent teaser features indicating information about the underling resource

</td>
</tr>
</tbody>
</table>

### OnlineService

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
<td colspan="2" valign="top"><strong id="onlineservice.link">link</strong></td>
<td valign="top"><a href="#link">Link</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### OnlineServiceFeature

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
<td colspan="2" valign="top"><strong id="onlineservicefeature.label">label</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="onlineservicefeature.onlineservices">onlineServices</strong></td>
<td valign="top">[<a href="#onlineservice">OnlineService</a>!]!</td>
<td></td>
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
<td colspan="2" valign="top"><strong id="resource.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.name">name</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.location">location</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.objecttype">objectType</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.contentsectiontypes">contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.teaser">teaser</strong></td>
<td valign="top"><a href="#teaser">Teaser</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.navigation">navigation</strong></td>
<td valign="top"><a href="#hierarchy">Hierarchy</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.kicker">kicker</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.date">date</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.geo">geo</strong></td>
<td valign="top"><a href="#geo">Geo</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.asset">asset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.symbolicasset">symbolicAsset</strong></td>
<td valign="top"><a href="#asset">Asset</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">variant</td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resource.explain">explain</strong></td>
<td valign="top"><a href="#resultexplain">ResultExplain</a></td>
<td></td>
</tr>
</tbody>
</table>

### ResultExplain

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
<td colspan="2" valign="top"><strong id="resultexplain.score">score</strong></td>
<td valign="top"><a href="#float">Float</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resultexplain.type">type</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resultexplain.field">field</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resultexplain.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="resultexplain.details">details</strong></td>
<td valign="top">[<a href="#resultexplain">ResultExplain</a>!]</td>
<td></td>
</tr>
</tbody>
</table>

### Scheduling

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
<td colspan="2" valign="top"><strong id="scheduling.start">start</strong></td>
<td valign="top"><a href="#datetime">DateTime</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="scheduling.end">end</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="scheduling.rrule">rRule</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="scheduling.isfullday">isFullDay</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="scheduling.hasstarttime">hasStartTime</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="scheduling.hasendtime">hasEndTime</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
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
<td colspan="2" valign="top"><strong id="searchresult.total">total</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.querytime">queryTime</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.offset">offset</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.limit">limit</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.results">results</strong></td>
<td valign="top">[<a href="#resource">Resource</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.facetgroups">facetGroups</strong></td>
<td valign="top">[<a href="#facetgroup">FacetGroup</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchresult.spellcheck">spellcheck</strong></td>
<td valign="top"><a href="#spellcheck">Spellcheck</a></td>
<td></td>
</tr>
</tbody>
</table>

### Spellcheck

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
<td colspan="2" valign="top"><strong id="spellcheck.suggestions">suggestions</strong></td>
<td valign="top">[<a href="#spellchecksuggestion">SpellcheckSuggestion</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spellcheck.collation">collation</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SpellcheckSuggestion

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
<td colspan="2" valign="top"><strong id="spellchecksuggestion.original">original</strong></td>
<td valign="top"><a href="#spellcheckword">SpellcheckWord</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spellchecksuggestion.suggestion">suggestion</strong></td>
<td valign="top"><a href="#spellcheckword">SpellcheckWord</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SpellcheckWord

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
<td colspan="2" valign="top"><strong id="spellcheckword.word">word</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spellcheckword.frequency">frequency</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
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
<td colspan="2" valign="top"><strong id="suggestresult.suggestions">suggestions</strong></td>
<td valign="top">[<a href="#suggestion">Suggestion</a>!]!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestresult.querytime">queryTime</strong></td>
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
<td colspan="2" valign="top"><strong id="suggestion.term">term</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestion.hits">hits</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### Svg

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
<td colspan="2" valign="top"><strong id="svg.copyright">copyright</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="svg.copyrightdetails">copyrightDetails</strong></td>
<td valign="top"><a href="#copyrightdetails">CopyrightDetails</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="svg.caption">caption</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="svg.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="svg.url">url</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### User

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
<td colspan="2" valign="top"><strong id="user.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="user.username">username</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="user.firstname">firstName</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="user.lastname">lastName</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="user.email">email</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="user.roles">roles</strong></td>
<td valign="top">[<a href="#string">String</a>!]!</td>
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
<td colspan="2" valign="top"><strong id="absolutedaterangeinputfacet.from">from</strong></td>
<td valign="top"><a href="#datetime">DateTime</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="absolutedaterangeinputfacet.to">to</strong></td>
<td valign="top"><a href="#datetime">DateTime</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="absolutedaterangeinputfacet.gap">gap</strong></td>
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
<td colspan="2" valign="top"><strong id="absolutedaterangeinputfilter.from">from</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="absolutedaterangeinputfilter.to">to</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputBoosting

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
<td colspan="2" valign="top"><strong id="inputboosting.queryfields">queryFields</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputboosting.phrasefields">phraseFields</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputboosting.boostqueries">boostQueries</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputboosting.boostfunctions">boostFunctions</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputboosting.tie">tie</strong></td>
<td valign="top"><a href="#float">Float</a></td>
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
<td colspan="2" valign="top"><strong id="inputfacet.key">key</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.excludefilter">excludeFilter</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.objecttypes">objectTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.contentsectiontypes">contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.categories">categories</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.sites">sites</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.sources">sources</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.contenttypes">contentTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.groups">groups</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.absolutedaterange">absoluteDateRange</strong></td>
<td valign="top"><a href="#absolutedaterangeinputfacet">AbsoluteDateRangeInputFacet</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.relativedaterange">relativeDateRange</strong></td>
<td valign="top"><a href="#relativedaterangeinputfacet">RelativeDateRangeInputFacet</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.spatialdistancerange">spatialDistanceRange</strong></td>
<td valign="top"><a href="#spatialdistancerangeinputfacet">SpatialDistanceRangeInputFacet</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.query">query</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfacet.querytemplate">queryTemplate</strong></td>
<td valign="top"><a href="#querytemplateinput">QueryTemplateInput</a></td>
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
<td colspan="2" valign="top"><strong id="inputfilter.key">key</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.ids">ids</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.objecttypes">objectTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.contentsectiontypes">contentSectionTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.teaserproperty">teaserProperty</strong></td>
<td valign="top"><a href="#teaserpropertyinputfilter">TeaserPropertyInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.categories">categories</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.sites">sites</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.sources">sources</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.contenttypes">contentTypes</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.groups">groups</strong></td>
<td valign="top">[<a href="#string">String</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.absolutedaterange">absoluteDateRange</strong></td>
<td valign="top"><a href="#absolutedaterangeinputfilter">AbsoluteDateRangeInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.relativedaterange">relativeDateRange</strong></td>
<td valign="top"><a href="#relativedaterangeinputfilter">RelativeDateRangeInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.geolocated">geoLocated</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.spatialorbital">spatialOrbital</strong></td>
<td valign="top"><a href="#spatialorbitalinputfilter">SpatialOrbitalInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.spatialarbitraryrectangle">spatialArbitraryRectangle</strong></td>
<td valign="top"><a href="#spatialarbitraryrectangleinputfilter">SpatialArbitraryRectangleInputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.and">and</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.or">or</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.not">not</strong></td>
<td valign="top"><a href="#inputfilter">InputFilter</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.query">query</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputfilter.querytemplate">queryTemplate</strong></td>
<td valign="top"><a href="#querytemplateinput">QueryTemplateInput</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputGeoPoint

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
<td colspan="2" valign="top"><strong id="inputgeopoint.lng">lng</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputgeopoint.lat">lat</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
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
<td colspan="2" valign="top"><strong id="inputsortcriteria.name">name</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteria.date">date</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteria.natural">natural</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteria.score">score</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteria.spatialdist">spatialDist</strong></td>
<td valign="top"><a href="#inputsortcriteriaspatialdist">InputSortCriteriaSpatialDist</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteria.custom">custom</strong></td>
<td valign="top"><a href="#inputsortcriteriacustom">InputSortCriteriaCustom</a></td>
<td></td>
</tr>
</tbody>
</table>

### InputSortCriteriaCustom

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
<td colspan="2" valign="top"><strong id="inputsortcriteriacustom.field">field</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteriacustom.direction">direction</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### InputSortCriteriaSpatialDist

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
<td colspan="2" valign="top"><strong id="inputsortcriteriaspatialdist.spatialpoint">spatialPoint</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="inputsortcriteriaspatialdist.direction">direction</strong></td>
<td valign="top"><a href="#sortdirection">SortDirection</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### MoreLikeThisInput

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
<td colspan="2" valign="top"><strong id="morelikethisinput.id">id</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="morelikethisinput.context">context</strong></td>
<td valign="top"><a href="#searchcontextinput">SearchContextInput</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="morelikethisinput.lang">lang</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="morelikethisinput.filter">filter</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="morelikethisinput.limit">limit</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="morelikethisinput.archive">archive</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
</tbody>
</table>

### QueryTemplateInput

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
<td colspan="2" valign="top"><strong id="querytemplateinput.query">query</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="querytemplateinput.variables">variables</strong></td>
<td valign="top"><a href="#json">Json</a>!</td>
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
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.base">base</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

Defaults to the current datetime if null

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.baseoffset">baseOffset</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.before">before</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td>

Sets the lower date boundary. Implicitely directed toward the past.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.after">after</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td>

Sets the upper date boundary. Implicitely directed toward the future.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.from">from</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td>

Sets the lower date boundary

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.to">to</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td>

Sets the upper date boundary

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.gap">gap</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.roundstart">roundStart</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfacet.roundend">roundEnd</strong></td>
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
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.base">base</strong></td>
<td valign="top"><a href="#datetime">DateTime</a></td>
<td>

Defaults to the current datetime if null

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.baseoffset">baseOffset</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.before">before</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td>

Sets the lower date boundary. Implicitely directed toward the past.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.after">after</strong></td>
<td valign="top"><a href="#dateinterval">DateInterval</a></td>
<td>

Sets the upper date boundary. Implicitely directed toward the future.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.from">from</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td>

Sets the lower date boundary

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.to">to</strong></td>
<td valign="top"><a href="#signeddateinterval">SignedDateInterval</a></td>
<td>

Sets the upper date boundary

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.roundstart">roundStart</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="relativedaterangeinputfilter.roundend">roundEnd</strong></td>
<td valign="top"><a href="#daterangeround">DateRangeRound</a></td>
<td></td>
</tr>
</tbody>
</table>

### SearchContextInput

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
<td colspan="2" valign="top"><strong id="searchcontextinput.urlbasepath">urlBasePath</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchcontextinput.resourcelocation">resourceLocation</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchcontextinput.options">options</strong></td>
<td valign="top"><a href="#searchcontextoptionsinput">SearchContextOptionsInput</a></td>
<td></td>
</tr>
</tbody>
</table>

### SearchContextOptionsInput

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
<td colspan="2" valign="top"><strong id="searchcontextoptionsinput.samenavigation">sameNavigation</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
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
<td colspan="2" valign="top"><strong id="searchinput.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.offset">offset</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.limit">limit</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.lang">lang</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.context">context</strong></td>
<td valign="top"><a href="#searchcontextinput">SearchContextInput</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.defaultqueryoperator">defaultQueryOperator</strong></td>
<td valign="top"><a href="#queryoperator">QueryOperator</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.sort">sort</strong></td>
<td valign="top">[<a href="#inputsortcriteria">InputSortCriteria</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.filter">filter</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.facets">facets</strong></td>
<td valign="top">[<a href="#inputfacet">InputFacet</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.spellcheck">spellcheck</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.archive">archive</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.timezone">timeZone</strong></td>
<td valign="top"><a href="#datetimezone">DateTimeZone</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.boosting">boosting</strong></td>
<td valign="top"><a href="#inputboosting">InputBoosting</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.distancereferencepoint">distanceReferencePoint</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="searchinput.explain">explain</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
</tbody>
</table>

### SpatialArbitraryRectangleInputFilter

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
<td colspan="2" valign="top"><strong id="spatialarbitraryrectangleinputfilter.lowerleftcorner">lowerLeftCorner</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spatialarbitraryrectangleinputfilter.upperrightcorner">upperRightCorner</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SpatialDistanceRangeInputFacet

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
<td colspan="2" valign="top"><strong id="spatialdistancerangeinputfacet.point">point</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spatialdistancerangeinputfacet.from">from</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spatialdistancerangeinputfacet.to">to</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SpatialOrbitalInputFilter

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
<td colspan="2" valign="top"><strong id="spatialorbitalinputfilter.distance">distance</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spatialorbitalinputfilter.centerpoint">centerPoint</strong></td>
<td valign="top"><a href="#inputgeopoint">InputGeoPoint</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spatialorbitalinputfilter.mode">mode</strong></td>
<td valign="top"><a href="#spatialorbitalmode">SpatialOrbitalMode</a></td>
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
<td colspan="2" valign="top"><strong id="suggestinput.text">text</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestinput.limit">limit</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestinput.lang">lang</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestinput.filter">filter</strong></td>
<td valign="top">[<a href="#inputfilter">InputFilter</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="suggestinput.archive">archive</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
</tbody>
</table>

### TeaserPropertyInputFilter

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
<td colspan="2" valign="top"><strong id="teaserpropertyinputfilter.image">image</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="teaserpropertyinputfilter.imagecopyright">imageCopyright</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="teaserpropertyinputfilter.headline">headline</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="teaserpropertyinputfilter.text">text</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
</tbody>
</table>

## Enums

### AuthenticationStatus

<table>
<thead>
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td valign="top"><strong>SUCCESS</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>PARTIAL</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>FAILURE</strong></td>
<td></td>
</tr>
</tbody>
</table>

### DateRangeRound

<table>
<thead>
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
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
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
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
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
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
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
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

### SpatialOrbitalMode

<table>
<thead>
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td valign="top"><strong>GREAT_CIRCLE_DISTANCE</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>BOUNDING_BOX</strong></td>
<td></td>
</tr>
</tbody>
</table>

## Scalars

### Boolean

The `Boolean` scalar type represents `true` or `false`.

### DateInterval

The scalar type `DateInterval` represents a date interval duration string. It is specified in ISO-8601 format (e.g. `P3Y6M4DT12H30M5S`).

### DateTime

The scalar type `DateTime` represents a date and time string. It is specified with the UTC time zone in ISO-8601 format (e.g. `2024-05-22T10:13:00Z`).

### DateTimeZone

The scalar type `DateTimeZone` represents a timezone string. It is specified in the IANA timezone database format (e.g. `America/New_York`).

### Float

The `Float` scalar type represents signed double-precision fractional
values as specified by
[IEEE 754](http://en.wikipedia.org/wiki/IEEE_floating_point). 

### GeoJson

### ID

The `ID` scalar type represents a unique identifier, often used to
refetch an object or as key for a cache. The ID type appears in a JSON
response as a String; however, it is not intended to be human-readable.
When expected as an input type, any string (such as `"4"`) or integer
(such as `4`) input value will be accepted as an ID.

### Int

The `Int` scalar type represents non-fractional signed whole numeric
values. Int can represent values between -(2^31) and 2^31 - 1. 

### Json

### SignedDateInterval

The scalar type `SignedDateInterval` represents a date interval duration string that additionally allows for a leading minus sign (as specified in ISO 8601-2:2019).

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
<td colspan="2" valign="top"><strong id="asset.copyright">copyright</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="asset.copyrightdetails">copyrightDetails</strong></td>
<td valign="top"><a href="#copyrightdetails">CopyrightDetails</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="asset.caption">caption</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="asset.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

**Possible Types:** [Image](#image), [Svg](#svg)

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
<td colspan="2" valign="top"><strong id="teaser.url">url</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Teaser URL

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Use field 'link' instead

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="teaser.link">link</strong></td>
<td valign="top"><a href="#link">Link</a></td>
<td>

Teaser Link

</td>
</tr>
</tbody>
</table>

**Possible Types:** [ArticleTeaser](#articleteaser), [MediaTeaser](#mediateaser), [NewsTeaser](#newsteaser), [EventTeaser](#eventteaser)

### TeaserFeature

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
<td colspan="2" valign="top"><strong id="teaserfeature.label">label</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

**Possible Types:** [OnlineServiceFeature](#onlineservicefeature)
