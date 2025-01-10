# Translator Bundle

The CMS IES supports the automatic translation of texts managed by the CMS. In most cases, a translation via PHP is therefore not necessary. However, there are cases where external content is provided via PHP, which then also needs to be translated. This translator can be used for this purpose. An example of this is an external RSS feed that is to be displayed on the website as a teaser list.

With this bundle, texts can be translated via an external translation service (such as DeepL).
Caches ensure that the texts do not have to be retranslated with every request.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-translator-bundle](https://github.com/sitepark/atoolo-translator-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/translator-bundle
```

## Usage

### Cache configuration

To be able to use the Translator, a cache is required which saves the texts that have already been translated so that they do not have to be translated again with every request.

A Redis cache can be used for this purpose, for example. The corresponding configuration must be made in the Symfony project.

`config/packages/cache.yaml`

```yaml
parameters:
  redis_host: "%env(REDIS_HOST)%"
  env(REDIS_HOST): localhost

framework:
  cache:
    default_redis_provider: "redis://%redis_host%"

    pools:
      translation.cache:
        adapter: cache.adapter.redis
```

The name of the pool `translation.cache` is relavant and cannot be changed. See: [Creating Custom (Namespaced) Pools](https://symfony.com/doc/current/cache.html#creating-custom-namespaced-pools){:target="\_blank"}

With the standard installation of Redis, the backup file is created at regular intervals according to certain rules.

Possible standard configuration of Redis `/etc/redis/redis.conf`:

```
# Unless specified otherwise, by default Redis will save the DB:
#   * After 3600 seconds (an hour) if at least 1 change was performed
#   * After 300 seconds (5 minutes) if at least 100 changes were performed
#   * After 60 seconds if at least 10000 changes were performed
#
# You can set these explicitly by uncommenting the following line.
#
# save 3600 1 300 100 60 10000
```

This is not optimal for the translations. The configuration should therefore be adapted.

```
save 60 1 30 100 10 10000
```

### Service configuration

Der Service benötigt noch Konfigurations-Parameter

`config/services.yaml`

```yaml
parameters:
  atoolo_translator.adapter.deepl.authKey: "%env(resolve:DEEPL_AUTH_KEY)%"
  atoolo_translator.translator.ttl: "P1D"
```

| <div style="width:21em">Name</div>        | Description                                                                                                                                             |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `atoolo_translator.adapter.deepl.authKey` | The Auth-Key for the Deepl API.                                                                                                                         |
| `atoolo_translator.translator.ttl`        | Specifies how long the translation should be kept in the cache. See: [format](https://www.php.net/manual/de/dateinterval.format.php){:target="\_blank"} |

### Service usage

The service is now available via the alias `atoolo_translator.translator` and can now be used via dependency injection. E.g. via autowiring:

```php
use Atoolo\Translator\Dto\Format;
use Atoolo\Translator\Dto\TranslationParameter;
use Atoolo\Translator\Service\Translator;
use Symfony\Component\DependencyInjection\Attribute\Autowire;

class MyService
{
    public function __construct(
        #[Autowire(service: 'atoolo_translator.translator')]
        private readonly Translator $translator,
    ) {
    }

    public function toSomething(): void
    {

        $textEn = 'Hello World';
        $parameter = new TranslationParameter(
            sourceLang: 'en',
            targetLang: 'de',
            format: Format::TEXT,
        );

        $translated = $this->translator->translate([$text], $parameter);

        $textDe = $translated[0];
    }
}
```
