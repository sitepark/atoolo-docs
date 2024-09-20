# Form API

The Form API is used to display forms defined by the CMS on the website and to provide functions for processing the form data.

## Form definition

Forms can be defined within the CMS with the help of a form editor.
These definitions are provided to the frontend in [JSON Forms](https://jsonforms.io/){:target="\_blank"} format to the frontend. The task of the frontend is to display the forms according to these definitions, validate form data and send the completed forms to the Form API.

The forms defined by the CMS are stored in resources (see also [Resource Bundle](../bundles/resource.md)). The content of a website is also contained within the resources. These are divided into individual components. A form is a component.

The Form API can be used to retrieve the form definitions of a website. The corresponding form is localized via the URL and the definition is returned.

The URL consists of the path

`/api/form/{lang}/{resource-path}/{componentId}`

`lang`
: Language code for the language in which the form should be displayed. This parameter is optional. If it is not specified, the default language of the website is used.

`resource-path`
: Path to the resource that contains the form. This path can also contain `/`.

`componentId`
: ID of the component that contains the form within the specified resource.

curl example:

```sh
curl "https://www.example.com/api/form/en/contact/form-1"
```

The response contains the form definition in JSON format:

```json
{
  "component" : "form-1",
  "schema" : { ... },
  "uischema" : { ... },
  "data" : { ... },
  "buttons" : {
    "submit" : "Send",
  },
  "messages" : {
    "success": {
      "headline": "Confirmation",
      "text": "Thank you for your inquiry."
    }
  }
}
```

`component`
: ID of the component for the form.

`schema`
: [JSON schema](https://json-schema.org/){:target="\_blank"} which is used to define the form data. The input data is also validated against the schema.

`uischema`
: [UI Schema](https://jsonforms.io/docs/uischema/){:target="\_blank"} which describes the layout of the form.

`data`
: Preset data for the form. The form is pre-filled with this data.

`buttons`
: Contains the labeling of the form buttons.

`messages`
: Contains texts for messages that are displayed for the form. E.g. when the form is successfully sent.

### JSON Schema

The JSON schema defines the structure of the form data. It is used to validate the input data on the frontend and server side. The schema of a field also influences how the field is displayed in the frontend. For example, a field of type 'string' is displayed as a text field, while a field of type 'boolean' is displayed as a checkbox.

See also [JSON Schema](https://json-schema.org/){:target="\_blank"}.

Individual error messages can be specified via the form editor. These must be evaluated by the frontend validator. See also [Validation](https://jsonforms.io/docs/validation/){:target="\_blank"}.

The errors are transferred in the following form:

```json
{
  "type": "object",
  "required": ["foo", "bar"],
  "properties": {
    "foo": { "type": "integer" },
    "bar": { "type": "string" }
  },
  "errorMessage": {
    "required": {
      "foo": "should have an integer property \"foo\"",
      "bar": "should have a string property \"bar\""
    }
  }
}
```

See also [Messages for keywords](https://github.com/ajv-validator/ajv-errors?tab=readme-ov-file#messages-for-keywords)

### UI Schema

The UI schema is used to define how the form is displayed in the frontend. It contains information about how the fields of the form should be arranged and displayed. The UI schema is independent of the JSON schema and makes it possible to influence the display of the form without having to change the JSON schema.

The form editor is used to define the form on the CMS page. The editor generates the JSON schema and the UI schema. The standard layouts and controls of JSON Forms are used.

However, there are also extended controls for which a separate renderer and validator must be implemented on the frontend side.

The layouts and their properties are described on the [Layouts](layouts.md) page.

The controls and their properties are described on the [Controls](controls.md) page.

The form editor also defines a UI schema element `Annotation`, which is not included in the standard. This can be used to place annotations and notes in the form.

The annotaions are described on the [Annotations](annotations.md) page.

## Submit processing

The Form API provides an endpoint for sending form data. The URL is:

`/api/form/{lang}/{resource-path}/{componentId}`

The form data is sent as a POST request to this URL. The data is sent as JSON in the request body.

curl example:

```sh
curl "https://www.example.com/api/form/en/contact/form-1" \
  --header "Content-Type: application/json" \
  --request POST \
  --data '{"field-1": "value-1", "field-2": "value-2"}'
```

The processing of the form can be very individual. The form data passes through several submit processors. Which processors are used is either stored centrally or determined for each form.

The following processors can be used:

`IpLimiter`
: Limits the submits from an IP address in a certain period of time.

`IpBlocker`
: Blocks submits from stored IP addresses.

`SubmitLimiter`
: Limits the number of submits of a form in a certain period of time.

`JsonSchemaValidator`
: Validates the form data against the JSON schema of the form.

`EmailSender`
: Sends the form data by e-mail to an e-mail address specified by the form editor. All other data required for the email, such as the subject line, is also stored via the form editor.

## Captcha

We deliberately do not use Captcha support at all.
Ensuring the accessibility of a website is part of Sitepark's basic understanding.

Captchas effectively exclude certain groups of people from using the form. Visual and auditory captchas are inaccessible for people with visual or hearing impairments, and motor or cognitive impairments also often make it difficult to solve the tasks. Even alternative captcha methods do not offer complete accessibility and therefore contradict the basic principle of providing unrestricted access to all users.

## Spam protection

The elimination of captchas makes spam protection an even more important task. The Form API therefore offers various mechanisms to protect against spam.

### IP blockings

It is possible to block IP addresses using IP lists. For example, known IP lists that are regularly updated can be used for this purpose.
Furthermore, IP addresses of cloud providers can be used, as the form api is intended exclusively for use on websites and not as an open interface for external applications and therefore it should never be a regular case that form data is sent via the IP address of a cloud provider.

### IP-Limiter

The IP limiter limits the number of submissions from an IP address in a certain period of time. This mechanism prevents a botnet or a single attacker from flooding the form with a large number of requests.

### Spam-Detection

Spam detection can be carried out based on the content of the form data.

### No confirmation e-mail

Emails are never sent to the sender of the form or to an email address submitted via the form. This is to prevent the Form API from being misused as a spam relay.

### Use of external services

- [Fail2Ban](https://github.com/fail2ban/fail2ban){:target="\_blank"} to detect attacks and block them.

### Conclusion

These mechanisms cannot guarantee 100% protection against spam. However, it is possible to minimize the probability of spam attacks and reduce their impact. This is the price that is paid to ensure that the forms are accessible to as many people as possible.

## Cross-Site Request Forgery (CSRF)

The Form API has no state. Attack vectors that aim to manipulate data via an active session are not possible with the Form API.
CSRF is therefore not relevant for the Form API.

## Breaking changes

Should the Form API change in a way that is not backward compatible, these changes are called "Breaking Changes" and may involve removing or renaming fields, arguments, or other parts of the schema.

These are communicated via the version numbers (semantic versioning) of the corresponding bundles.

A versioning strategy within the URL is not used. The reason for this is that the Form API should only be used within the website context. It is not intended as an open interface for external applications.
