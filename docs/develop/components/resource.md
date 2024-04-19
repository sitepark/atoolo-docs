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
- `lang` - Language of the resource data.
- `data` - A generic data object containing the data structure of the resource. Depending on the object type, the schema of the data can be different.

The data is held in a `DataBag`, via which it can be read in a typed form. A string with dot notation can be used to retrieve more deeply nested data.

For a given data structure:

```json
{
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
  ],
  "base": {
    "teaser": {
      "date": 1713516141,
      "headline": "Headline",
      "text": "Text"
    }
  }
}
```

The data can be queried as follows, for example.

- `$resource->data->getInt('base.teaser.date')`
- `$resource->data->getString('base.teaser.headline', 'Untitled')`
- `$resource->data->getArray('groupPath')`
- `$resource->data->getAssociativeArray('base.teaser')`

## Loading a resource

Resources are loaded via a `ResourceLoader`. Depending on the format in which the data is aggregated, a corresponding ResourceLoader must be used. The current format is the `SiteKit` format. The `Atoolo\Resource\Loader\SiteKitLoader` is available for this. The `SiteKitLoader` also requires a `ResourceChannel`.

### `ResourceChannel`

The IES (Sitepark's content management system) recognizes various channels through which resources can be published. A channel is a directory that is always assigned to a specific virtual host.

A `ResourceChannel` can be created via a `ResourceChannelFactory`.

```php
$resourceChannel = $resourceChannelFactory->create();
```

#### `ResourceChannelFactory`

Die `ResourceChannelFactory` ist ein Interface. Die einzige implementierte Klasse ist die `SiteKitResourceChannelFactory`.

```php
use Atoolo\Resource\SiteKitResourceChannelFactory;

$resourceChannelFactory = new SiteKitResourceChannelFactory($resourceRoot);
$resourceChannel = $resourceChannelFactory->create();
```

### `SiteKitLoader`

The `ResourceChannel` can be used to create the `SiteKitLoader`.

```php
use Atoolo\Resource\Loader\SiteKitLoader;
use Atoolo\Resource\ResourceLocation;

$loader = new SiteKitLoader($resourceChannel);
```

Resources can now be loaded.

```php
$location = ResourceLocation::of ('/index.php');
$resource = $loader->load(location);
```

### `CachedResourceLoader`

The `CachedResourceLoader` class is used to load resources from a given location and cache them for future use. The cache is stored in memory and is not persistent. The `CachedResourceLoader` wrapped another `ResourceLoader` and caches the resources loaded by the wrapped loader.

```php
use Atoolo\Resource\Loader\CachedResourceLoader;
use Atoolo\Resource\ResourceLocation;

$cachedloader = new CachedResourceLoader($loader);
$location = ResourceLocation::of('/index.php');
$resource = $cachedloader->load($location);
```

### Using Symfony Dependency Injection

The loader can be defined as a service in Symfony. This allows it to be used via dependency injection.

`service.xml`

```yaml
parameters:
  atoolo_resource.resource_root: "%env(RESOURCE_ROOT)%"

services:
  atoolo.resource.resourceChannelFactory:
    class: Atoolo\Resource\SiteKitResourceChannelFactory
    arguments:
      - "%atoolo_resource.resource_root%"

  atoolo.resource.resourceChannel:
    class: Atoolo\Resource\SiteKitResourceChannel
    factory: ["@atoolo.resource.resourceChannelFactory", "create"]

  atoolo.resource.resourceLoader:
    class: Atoolo\Resource\Loader\SiteKitLoader
    arguments:
      - "@atoolo.resource.resourceChannel"

  atoolo.resource.cachedResourceLoader:
    class: Atoolo\Resource\Loader\CachedResourceLoader
    arguments:
      - "@atoolo.resource.resourceLoader"
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
$location = ResourceLocation::of('/a/b/c.php');
$rootResource = $hierarchyLoader->loadRoot($location');
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

## Using ResourceHierarchyWalker

The `ResourceHierarchyWalker` class is used to traverse a hierarchy of resources.
The walker needs a base resource to start with. This can be set with `init()`.

The walker can then be moved up and down in the hierarchy
with the help of methods like

- `down()`
- `child()`
- `up()`
- `nextSibling()`
- `previousSibling()`
- `next()`

With these methods, the walker can only move below the base resource.
To move above the base resource, the methods `primaryParent()`
and `parent()` can be used.

The walker can also be used to traverse the entire hierarchy
with the help of the `walk()` method.

```php
use Atoolo\Resource\ResourceHierarchyWalker;

$walker = new ResourceHierarchyWalker($hierarchyLoader);

// step by step
$location = ResourceLocation::of('/index.php');
$walker->init($location);
$walker->down();
$walker->nextSibling();
$walker->next();
// ...

// walk through the hierarchy
$walker->walk($location, function ($resource) {
  // do something with the resource
});
```

## Using ResourceHierarchyFinder

The `ResourceHierarchyFinder` class is used to find a resource in a hierarchy. Use `findFirst()` to find the first resource that matches the given condition.

```php
use Atoolo\Resource\ResourceHierarchyFinder;

$finder = new ResourceHierarchyFinder($this->loader);
$anchor = "anchor-to-find";
$location = ResourceLocation::of('/index.php');
$resource = $finder->findFirst(
    $location,
    function ($resource) use ($anchor) {
        $resourceAnchor =
            $resource->getData()->getString('anchor');
        return $resourceAnchor === $anchor;
    }
);
```
