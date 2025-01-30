# Controls

Controls are the building blocks of forms. They are the elements that allow users to interact with the form. Controls can be simple, like a text input, or complex, like a date picker.

The controls that can be used in the forms are described below.

The indicator that should be used to define the tester for the renderer is also specified for each control type. The indicator is derived from various attributes of the JSON schema and the UI schema.
See also [Custom Renderers](https://jsonforms.io/docs/tutorial/custom-renderers/){:target="\_blank"}

## Text field

A simple input field.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Firstname"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/firstname",
      "label": "Firstname",
      "options": {
        "autocomplete": "name",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"`

## Email field

A input field for email addresses.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "E-Mail",
      "format": "email"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/email",
      "label": "E-Mail",
      "options": {
        "autocomplete": "email",
        "spaceAfter": true,
        "asReplyTo": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

    `asReplyTo`
    : The "asReplyTo" attribute is used to specify that the email address should be used as the reply address. This is not a standard attribute of the JSON schema, but does not have to be evaluated on the frontend side. This attribute is only relevant if the `EmailSender` form processor is used.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "email"`

## Phone field

A input field for email addresses.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Phone number",
      "format": "phone"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/email",
      "label": "Phone number",
      "options": {
        "autocomplete": "tel",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "phone"`

## Number field

A input field for Numbers.

=== "JSON Schema"

    ```json
    {
      "type": "integer",
      "title": "Age"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/age",
      "label": "Age",
      "options": {
        "autocomplete": "off",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "integer"`

## Date

A input field for Dates.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Date",
      "format": "date"
    }
    ```

    `format`
    : The `format` must be set to `date`. The date is expected in the format `YYYY-MM-DD`.

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/date",
      "label": "Date",
      "options": {
        "autocomplete": "off",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "date"`

## Time

A input field for Times.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Time",
      "format": "time"
    }
    ```

    `format`
    : The `format` must be set to `time`. The date is expected in the format `hh:mm:ss.sTZD`.
    : | Input | Status |
     | ----- | ------ |
     | `"10:05:08"` | <span style="color:green">valid</div>  |
     | `"10:05:08.5"` | <span style="color:green">valid</div>  |
     | `"10:05:08-02:30"` | <span style="color:green">valid</div>  |
     | `"10:05:08Z"` | <span style="color:green">valid</div>  |
     | `"45:60:62"` | <span style="color:red">invalid</div>  |
     | `"10:05"` | <span style="color:red">invalid</div>  |

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/time",
      "label": "Time",
      "options": {
        "autocomplete": "off",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "time"`

## Date-Time

A input field for Date with Time.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Time",
      "format": "date-time"
    }
    ```

    `format`
    : The `format` must be set to `time`. The date is expected in the format `YYYY-MM-DDThh:mm:ss.sTZD`.
    : | Input | Status |
     | ----- | ------ |
     | `"1970-01-01T10:05:08""` | <span style="color:green">valid</div>  |
     | `"1970-01-01T10:05:08.10"` | <span style="color:green">valid</div>  |
     | `"1970-01-01T10:05:08+01:00"` | <span style="color:green">valid</div>  |
     | `"1970-01-01"` | <span style="color:red">invalid</div>  |
     | `"1970-01-01T10:05"` | <span style="color:red">invalid</div>  |

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/datetime",
      "label": "Date and Time",
      "options": {
        "autocomplete": "off",
        "spaceAfter": true
      }
    }
    ```

    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "date-time"`

## Multiline text field

A input field for multiline text.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Supplementary remarks"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/remarks",
      "label": "Supplementary remarks",
      "options": {
        "multi": true,
        "autocomplete": "off",
        "spaceAfter": true
      }
    }
    ```
    `multi`
    : Indicates that this is a multi-line text field.
    `autocomplete`
    : The `autocomplete` attribute specifies whether a form field should have autocomplete enabled. This is not to be confused with the `autocomplete` attribute for `enum` and `oneOf` for the [Autocomplete Renderer](https://jsonforms.io/examples/autocomplete).
    This attribute can be used to set the HTML `autocomplete` attribute as described [here](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#autofill). The React standard renderer does not evaluate this.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    - JSON-Schema: `type: "string"`
    - UI-Schema: `options.multi: true`

## Rich text field

Input field that can contain HTML.

This is not included in the JSON From standard. The validator and renderer must be implemented on the frontend side.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "Description",
      "format": "html",
      "allowedElements": [ "p", "strong", "em", "li", "ul", "ol" ]
    }
    ```

    `format`
    : The `format` must be set to `html`. This is not a standard JSON schema format.

    `allowedElements`
    : The accepted HTML elements are specified as an array. This is not included in the JSON schema standard. The validator must be implemented on the frontend side.

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/description",
      "label": "Description",
      "options": {
        "htmleditor": true,
        "spaceAfter": true
      }
    }
    ```
    `htmleditor`
    : Indicates that an HTML editor is to be used here.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    - JSON-Schema: `type: "string"` and `format: "html"`
    - UI-Schema: `options.htmleditor: true`

## Checkbox field

A input field for Dates.

=== "JSON Schema"

    ```json
    {
      "type": "boolean",
      "title": "Accept terms and conditions"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/acceptTermsAndConditions",
      "label": "Accept terms and conditions",
      "options": {
        "spaceAfter": true
      }
    }
    ```

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "boolean"`

## Checkbox field with HTML label

A input field for Checkbox with HTML label.

This is not included in the JSON From standard. The renderer must be implemented on the frontend side.

=== "JSON Schema"

    ```json
    {
      "type": "boolean",
      "title": "Data protection notice accepted"
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/dataProtectionNoticeAccepted",
      "htmlLabel": {
        "text" : "I agree that my details and data will be processed to answer my request in accordance with the <a href=\"/privacy-policy\">privacy policy</a>."
      },
      "options": {
        "spaceAfter": true
      }
    }
    ```

    `htmlLabel.text`
    : Contains the text of the label. HTML tags can be used here.

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    - JSON-Schema: `type: "boolean"`
    - UI-Schema: `htmlLabel.text: "..."`

## Checkbox group

A input field for Checkbox group.

=== "JSON Schema"

    ```json
    {
      "type": "array",
      "title": "Your favorite pets",
      "items": {
        "oneOf": [
          {
            "const" => "dog",
            "title" => "Dog"
          },
          {
            "const" => "cat",
            "title" => "Cat"
          },
          {
            "const" => "mouse",
            "title" => "Mouse"
          }
        ]
      },
      "uniqueItems": true
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/favoritePets",
      "label": "Your favorite pets",
      "options": {
        "spaceAfter": true
      }
    }
    ```

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "array"` and `items.oneOf: [...]`

## Radio buttons

A input field for Checkbox group.

=== "JSON Schema"

    ```json
    {
      "type": "array",
      "title": "Your favorite pet",
      "oneOf": [
        {
          "const" => "dog",
          "title" => "Dog"
        },
        {
          "const" => "cat",
          "title" => "Cat"
        },
        {
          "const" => "mouse",
          "title" => "Mouse"
        }
      ]
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/favoritePets",
      "label": "Your favorite pets",
      "options": {
        "format": "radio",
        "spaceAfter": true
      }
    }
    ```

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    - JSON-Schema: `type: "array"` and `oneOf: [...]`
    - UI-Schema: `options.format: "radio"`

## Single Select

A input field for Checkbox group.

=== "JSON Schema"

    ```json
    {
      "type": "array",
      "title": "Your favorite pet",
      "oneOf": [
        {
          "const" => "dog",
          "title" => "Dog"
        },
        {
          "const" => "cat",
          "title" => "Cat"
        },
        {
          "const" => "mouse",
          "title" => "Mouse"
        }
      ]
    }
    ```

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "scope": "#/properties/favoritePets",
      "label": "Your favorite pets",
      "options": {
        "spaceAfter": true
      }
    }
    ```

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    - JSON-Schema: `type: "array"` and `oneOf: [...]`

## Upload Field

A simple input field.

=== "JSON Schema"

    ```json
    {
      "type": "string",
      "title": "File upload",
      "format": "data-url",
      "maxFileSize": 2000000,
      "acceptedFileNames": [
        "*.png",
        "*.jpg"
      ],
      "acceptedContentTypes": [
        "image/*"
      ]
    }
    ```

    Upload files are stored as a Base64 string in the JSON object. This is not included in the JSON schema standard. The validator must be implemented on the frontend side.

    `format`
    : The `format` must be set to `data-url`. This is not a standard JSON schema format.
    The [Data URI schema](https://en.wikipedia.org/wiki/Data_URI_scheme) is used here. The file name is expected as an additional parameter (`name=image.png`).

    : Example:
    ```json
    {
      "image": "data:image/png;name=image.png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABjElEQVR42mNk
    }
    ```

    `maxFileSize`
    : Maximum file size in bytes.

    `acceptedFileNames`
    : Pattern for the file names that are accepted.

    `acceptedContentTypes`
    : The accepted content types are specified as an array and can contain wildcards such as `*` and `?`. E.g. `image/*` or `image/jpeg`.

=== "UI Schema"

    ```json
    {
      "type": "Control",
      "label": "Image",
      "scope": "#/properties/image",
      "options": {
        "spaceAfter": true
      }
    }
    ```

    `spaceAfter`
    : Ensures that a space is inserted after the input field. The React standard renderer does not evaluate this.

=== "Indicator"

    JSON-Schema: `type: "string"` and `format: "data-url"`

## Required Fields

Required fields are defined within the JSON schema. See [Required Properties](https://json-schema.org/understanding-json-schema/reference/object#required){:target="\_blank"}.

## Rules

[Rules](https://jsonforms.io/docs/uischema/rules){:target="\_blank"} allow for dynamic aspects for a form, e.g. by hiding or disabling UI schema elements.

No rules are currently supported by the form editor.
