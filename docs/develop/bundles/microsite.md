# Microsite Bundle

Microsites are compact, thematically focused websites that deal exclusively with a specific topic. They are often used to highlight specific topics such as events, projects, offers or campaigns. Further information can be found in the [microsite concept](../../concepts/microsites.md).

This bundle provides the functionalities of microsites.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-microsite-bundle](https://github.com/sitepark/atoolo-microsite-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/microsite-bundle
```

## Configuration

Pages from the main website or other microsites can be integrated into microsites. A so-called "mounting" is used for this purpose. This is defined in the microsite configuration.

`config/package/microsite.yaml`

```yaml
atoolo_microsite:
  mountable_object_types: ["event"]
```
