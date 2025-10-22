# Resource

The resource represents a data object published by the IES. This can be an article but also other objects that can be published by CMS.

A resource has the following properties:

- `location` - The path to the aggregated file
- `id` - An ID assigned by the CMS for the object
- `name` - Name of the resource
- `objectType` - Specifies the type of the object. These types are managed in the CMS.
- `lang` - Language of the resource data.
- `data` - A generic data object containing the data structure of the resource. Depending on the object type, the schema of the data can be different.
