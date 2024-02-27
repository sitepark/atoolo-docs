# Resource Component

In the Atoolo context, resources from IES (Siteparks content management system) are aggregated data that can be handled through this library.

There can be different formats in which the resource is aggregated by the CMS. The current format is the `SiteKit` format. Here, a PHP file is created for each article in which the data is stored in the form of PHP arrays. The data is read out via the corresponding `ResourceLoader` and made available in a `Resource` object.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-resource](https://github.com/sitepark/atoolo-resource){:target="\_blank"}.

## Installation

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/resource
```

## The Resource

The resource represents a data object published by the IES (Siteparks content management system). This can be an article but also other objects that can be published by CMS.

Eine Resource hat folgende Eigenschaften:

- `location` - The path to the aggregated file
- `id` - An ID assigned by the CMS for the object
- `name` - Name of the resource
- `objectType` - Specifies the type of the object. These types are managed in the CMS.
- `data` - A generic data object containing the data structure of the resource. Depending on the object type, the schema of the data can be different.

Die Daten werden in einem `DataBag` gehalten, über den sie typisiert ausgelesen werden können. Über eine String mit Punkt-Notation können tiefer verschachtelte Daten aufgefagt werden.

For a given data structure:

```json
{
  "init": {
    "id": 1,
    "name": "name",
    "groupPath": [
      {
        "id": 123,
        "name": "A"
      },
      {
        "id": 456,
        "name": "B"
      }
    ]
  }
}
```

The data can be queried as follows, for example.

- `$resource->getData()->getInt('init.id')`
- `$resource->getData()->getString('init.name', 'Unnamed')`
- `$resource->getData()->getArray('init.groupPath')`
- `$resource->getData()->getAssociativeArray('init')`

## Loading a resource

Resources are loaded via a `ResourceLoader`. Depending on the format in which the data is aggregated, a corresponding ResourceLoader must be used. The current format is the `SiteKit` format. The `Atoolo\Resource\Loader\SiteKitLoader` is available for this. The `SiteKitLoader` also requires a `ResourceBaseLocator` with which the base directory of the stored resources can be determined at runtime.

### `ResourceBaseLocator`

Various `ResourceBaseLocator` implementations are available.

#### `ServerVarResourceBaseLocator`

The constructor expects two arguments. The name of the server variable from which the path is to be read and, optionally, a path for a subdirectory that is appended to the path.

```php
use Atoolo\Resource\ResourceBaseLocator\ServerVarResourceBaseLocator;

$baseLocator = new ServerVarResourceBaseLocator(
  'RESOURCE_ROOT',
  'objects'
);
```

#### `StaticResourceBaseLocator`

Here the path is transferred directly to the consturctor

```php
use Atoolo\Resource\ResourceBaseLocator\StaticResourceBaseLocator;

$baseLocator = new StaticResourceBaseLocator(
  '/var/www/domain.com/www/resources/objects'
);
```

### `SiteKitLoader`

The `ResourceBaseLocator` can be used to create the `SiteKitLoader`.

```php
use Atoolo\Resource\Loader\SiteKitLoader;

$loader = new SiteKitLoader($baseLocator);
```

Resources can now be loaded.

```php
$resource = $loader->load('/index.php');
```

### Using Symfony Dependency Injection

The loader can be defined as a service in Symfony. This allows it to be used via dependency injection.

`service.xml`

```yaml
services:
  atoolo.resource.resourceBaseLocator:
    class: Atoolo\Resource\Loader\ServerVarResourceBaseLocator
    arguments:
      - "RESOURCE_ROOT"
      - "objects"
  atoolo.resource.resourceLoader:
    class: Atoolo\Resource\Loader\SiteKitLoader
    arguments:
      - "@atoolo.resource.resourceBaseLocator"
```

## Loading resource hierarchy

Resources can be linked to each other hierarchically. This is the case, for example, via the navigation. Here the root element is the homepage. Category resources are another case. Categories can also be structured hierarchically. These hierarchies can be read out with the `ResourceHierarchyLoader`.

There is a special case for navigation. Here, every resource (except the homepage) has a navigation parent. If no parent is explicitly defined, the current directory and all higher-level directories are searched for an `index.php` and checked to see if it is the homepage. If it is found, this is the implicit parent for the resource. Therefore, there is a special `SiteKitNavigationHierarchyLoader` for the navigation. The `SiteKitResourceHierarchyLoader` is used for all other cases.

`ResourceHierarchyLoader` also require a `ResourceLoader` (see above).

Create `SiteKitNavigationHierarchyLoader`:

```php
$hierarchyLoader = new SiteKitNavigationHierarchyLoader($loader);
```

or create a `SiteKitResourceHierarchyLoader`. The name of the hierarachy type is still required here. In this case for categories.

```php
$hierarchyLoader = new SiteKitResourceHierarchyLoader($loader, 'category');
```

Once the hierarchy loader has been created, the hierarchies can be queried. For example to load the root.

```php
$rootResource = $hierarchyLoader->loadRoot('/a/b/c.php')
```

### Using Symfony Dependency Injection

The hierarchy loader can be defined as a service in Symfony. This allows it to be used via dependency injection.

`service.xml`

```yaml
atoolo.resource.navigationHierarchyLoader:
  class: Atoolo\Resource\Loader\SiteKitNavigationHierarchyLoader
  arguments:
    - "@atoolo.resource.resourceLoader"
atoolo.resource.categoryHierarchyLoader:
  class: Atoolo\Resource\Loader\SiteKitResourceHierarchyLoader
  arguments:
    - "@atoolo.resource.resourceLoader"
    - "category"
```
