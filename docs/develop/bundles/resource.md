# Resource Bundle

In the Atoolo context, resources from IES (Siteparks content management system) are aggregated data that can be handled through this library.

There can be different formats in which the resource is aggregated by the CMS. The current format is the `SiteKit` format. Here, a PHP file is created for each article in which the data is stored in the form of PHP arrays. The data is read out via the corresponding `ResourceLoader` and made available in a `Resource` object.

These resources created by the IES are referred to as "internal" resources. The term "external" resources is used when the resource object is filled with data that does not originate from the IES.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-resource-bundle](https://github.com/sitepark/atoolo-resource-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/resource-bundle
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

The `ResourceChannelFactory` is an interface. The only implemented class is the `SiteKitResourceChannelFactory`.

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

## P Parameter Service

The `Atoolo\Resource\Service\PParameterService` (`atoolo_resource.p_parameter_service`) can be used to generate **P parameters** with foreign parent.

For more information, see [P parameter with foreign parent](../../concepts/navigation.md#p-parameter-with-foreign-parent).

```php
$pParameter = $pParameterService->getPParameterForForeignParent(
  ResourceLocation::ofPath('/culture/event-search.php'),
  ResourceLocation::ofPath('/service/events-calendar/some-event'),
);
```

## Using Symfony parameter and services

The bundle defines the parameter `atoolo_resource.resource_root` which is used to determine.

```yaml
parameters:
  atoolo_resource.resource_root: "%env(RESOURCE_ROOT)%"
```

If the environment variable `RESOURCE_ROOT` is not set, the `Atoolo\Resource\Env\EnvVarLoader` intervenes. This can determine the resource root for command line calls via the path of the `bin/console` script if the script was called via the host path. Like e.g.

```sh
/var/www/example.com/www/app/bin/console
```

The bundle provides the corresponding classes via service IDs. These can be used in a Symfony project via dependency injection.

| <div style="width:12em">Service-Id</div>      | Description                                      |
| --------------------------------------------- | ------------------------------------------------ |
| `atoolo_resource.resource_channel`            | The `ResourceChannel`                            |
| `atoolo_resource.resource_loader`             | currently the `SiteKitLoader`                    |
| `atoolo_resource.navigation_hierarchy_loader` | currently the `SiteKitNavigationHierarchyLoader` |
| `atoolo_resource.category_hierarchy_loader`   | currently the `SiteKitResourceHierarchyLoader`   |

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
