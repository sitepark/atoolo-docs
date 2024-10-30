# Resolve resource

The resource is the root object of the individual search hits. The necessary data can be queried from there.

See also

- [Resolve navigation hierarchy](resolve-navigation-hierarchy.md)
- [Resolve teaser](resolve-teaser.md)

Die Stammdaten der Resource sind:

`id`

: The unique identifier of the resource.

`name`

: The name of the resource.

`location`

: The location of the resource. This is the Path where the resource is stored.

`objectType`

: The type of the resource.

`contentSectionTypes`

: A list of the Content Section Types contained in the resource.

`ticker`

: A ticker is a short text that cat displayed in the search results to provide a brief overview of the content.

`date`

: The date of the resource. This can have different meanings depending on the object type. For normal articles this is an editorial date, for events the date of the event, for news the date of publication, etc.

`asset`

: An asset is a media file that can be displayed in the search results. This can be an image, a video, etc.

`symbolicImage`

: A symbolic image is a small image that can be displayed in the search results, if no asset is available.

`geo`

: The geographical location of the resource. See also [Geo data](#geo-data)

## Geo data

The geo data indicates the geographical location of the resource. This data can be used in the search to filter or sort the results according to geographical criteria. The geo data consists of up to three fields

`primary`

: The primary geographical location of the resource. This is used for the search and is returned as a longitude and latitude point.

`secondary`

: It is possible to define secondary geo-elements via the CMS. These can be used for display on a map, for example. These are returned as a FeatureCollection in GeoJSON format.

`distance`

: Die Entfernung der pimären Geo-Position zu einem Referenzpunkt. Diese Referenzpunkt muss bei der Suche mit `distanceReferencePoint` angegeben werden.

```graphql
query {
  search(
    input: {
      text: "chocolate"
      distanceReferencePoint: { lng: 8.200000, lat: 50.07858 }
    }
  ) {
    total
    offset
    queryTime
    results {
      id
      geo {
        distance
      }
    }
  }
}
```
