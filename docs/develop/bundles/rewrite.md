# Rewrite Bundle

This bundle contains functions for URL rewriting.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-rewrite-bundle](https://github.com/sitepark/atoolo-rewrite-bundle{:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/rewrite-bundle
```

## Url rewriting

The url rewriter enables the manipulation of URLs via a central point. For this, however, it is necessary that the URLs to be manipulated are passed to the URL rewriter by the services to which these URLs are known.

For the central URL rewriter, the class `Atoolo\Rewrite\Service\UrlRewriteHandlerCollection` is available as a Symfony service under the alias `atoolo_rewrite.url_rewriter`. Various handlers can be registered for the `UrlRewriteHandlerCollection`. To do this, the handler must implement the interface `Atoolo\Rewrite\Service\UrlRewriterHandler`.

Example of a handler:

```php
use Atoolo\Rewrite\Dto\Url;
use Atoolo\Rewrite\Dto\UrlRewriterHandlerContext;
use Atoolo\Rewrite\Dto\UrlRewriteType;

class MyUrlRewriteHandler implements UrlRewriterHandler
{
    public function rewrite(
        Url $url,
        UrlRewriterHandlerContext $context,
    ): Url {
      $manipulatedUrl = $url->toBuilder()
          // manipulate the url
          ->build();

      return $manipulatedUrl;
    }
}
```

The handler can then be registered via tagging in the Symfony service configuration:

```yaml
services:
  MyUrlRewriteHandler:
    class: MyUrlRewriteHandler
    tags:
      - { name: atoolo_rewrite.url_rewrite_handler }
```

### Using the rewriter

The rewriter can be used in a Symfony service:

```php
use Atoolo\Rewrite\Dto\UrlRewriteOptions;
use Atoolo\Rewrite\Dto\UrlRewriteType;
use Atoolo\Rewrite\Service\UrlRewriter;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

class MyService
{
    public function __construct(
        #[Autowire(service: 'atoolo_rewrite.url_rewriter')]
        private readonly UrlRewriter $urlRewriter,
    ) {}

    public function doSomething(): void
    {
        $url = $this->urlRewriter->rewrite(
            'https://example.com',
            UrlRewriteType::Link,
            UrlRewriteOptions::none(),
        );
    }
```

All URLs transferred in this way can then be manipulated centrally via the various handlers.

There may be cases where only certain types of URLs are to be changed. Therefore, the type of URL must always be specified. The possible types are

| Type    | Description                     |
| ------- | ------------------------------- |
| `Link`  | The URL is a link.              |
| `Image` | The URL is an image.            |
| `Media` | The url is a medium e.g. a PDF. |

### Build-in Handler

The bundle provides several handlers that are already available for the standard URL rewriter (`atoolo_rewrite.url_rewriter`).

#### Language prefix handler (`atoolo_rewrite.url_rewrite_handler.lang_prefix`)

This handler is used to set a prefix path for a language. Various rules apply to determine the language code to be used.

The parameter `atoolo_rewrite.url_rewrite_handler.lang_prefix.default` can be used to specify a default code in the format `[lang-code]:[redirect-to-default-lang-prefix]` (e.g. `en:false`).

`config/service.xml`

```
parameters:
  atoolo_rewrite.url_rewrite_handler.lang_prefix.default: 'en:false'
```

This defines what the default language is and whether or not the prefix should be set for the default language.

The language to be used can be specified to the rewriter via the `UrlRewriteOptions`:

```php
UrlRewriteOptions::builder()->lang('en')->build();
```

If the language is not specified via the `UrlRewriteOptions`, the language is determined via the request. This checks whether the language code has been specified as a path prefix for the request.

#### `.php` suffix handler (`atoolo_rewrite.url_rewrite_handler.php_suffix`)

URLs with the extension `.php` are removed.

`/foo/bar.php` becomes `/foo/bar`. A special case here is when the URL ends with `/index.php`. In this case, `index.php` is removed so that the URL ends with `/`. For example, `/foo/bar/index.php` becomes `/foo/bar/`.

### Special url rewriter

Wenn nicht der zentrale URL-Rewriter genutzt werde soll, sonder nur bestimmte Handler verwendet werden soll, kann auch ein eigenen Service definiert werden.

`config/service.yml`

```yml
services:
  my.url_rewriter:
    class: Atoolo\Rewrite\Service\UrlRewriteHandlerCollection
    arguments:
      - ["@my_handler"]
```
