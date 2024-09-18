# Form Bundle

This bundle provides an HTTP interface via which forms can be displayed and processed with the help of [JSON Forms](https://jsonforms.io/).

See also [Form API](../form/index.md).

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-form-bundle](https://github.com/sitepark/atoolo-form-bundle{:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/form-bundle
```

## Submit Processors

The form data is submitted to the Form API. This is then processed by one or more submit processors.

All submit processors implement the `SubmitProcessor`- interface and process the form data in a chain of processors.

```php
/**
 * @template T of SubmitProcessorOptions
 */
#[AutoconfigureTag('atoolo_form.processor')]
interface SubmitProcessor
{
    /**
     * @template E of T
     * @param E $options
     */
    public function process(FormSubmission $submission, SubmitProcessorOptions $options): FormSubmission;
}
```

Each processor must have a key. This key is specified in the configuration of the form definition to define which processor processes the data. This can be done via the PHP attribute `AsTaggedItem`.

```php
#[AsTaggedItem(index: 'my-processor')]
class MyProcessor implements SubmitProcessor
{
    public function process(FormSubmission $submission, SubmitProcessorOptions $options): FormSubmission
    {
        return $submission;
    }
}
```

### JsonSchemaValidator (`json-schema-validator`)

The `JsonSchemaValidator`-SubmitProcessor can be used to validate form data against a JSON schema.

For the validation of non-standardized [formats](https://json-schema.org/understanding-json-schema/reference/string#format), separate format validators can be implemented. These must implement the `FormatConstraint` interface.

```php

#[AutoconfigureTag('atoolo_form.jsonSchemaConstraint')]
interface Constraint {}

interface FormatConstraint extends Constraint
{
    /**
     * Returns the JSON-Schema type that this constraint applies to.
     */
    public function getType(): string;

    /**
     * Returns the format name to which this constraint applies.
     */
    public function getName(): string;

    /**
     * Validates the given value against the format constraint.
     *
     * @param mixed $value The value to validate.
     * @param stdClass $schema The schema that defines the format constraint.
     * @return bool Whether the value is valid.
     */
    public function check(mixed $value, stdClass $schema): bool;
}
```

### EmailSender (`email-sender`)

The `EmailSender`-SubmitProcessor can be used to send form data by e-mail.

#### E-Mail Template

The html email is generated from a Twig template. There are 3 templates for this

`@AtooloForm/email.html.twig`
: Contains the frame HTML with header and footer

`@AtooloForm/email.html.summary.twig` : Contains a summary of the submitted forms.
: Contains a summary of the transmitted form data

`@AtooloForm/email.html.styles.css` : Contains the CSS styles.
: Contains the CSS styles for the e-mail template

If necessary, these can also be overwritten in your own project by storing the corresponding templates in your own project under `templates/bundles/AtooloFormBundle`.
