# Annotations

The form editor defines an additional UI schema element `Annotation` that is not included in the standard. This allows annotations and notes to be placed in the form.

=== "JSON Schema"

    As an annotation does not contain any input fields, it is not defined in the JSON schema.

=== "UI Schema"

    ```json
    {
      "type": "Annotation",
      "htmlLabel": {
          "text": "Note with <strong>html</strong>"
      }
    }
    ```

    `htmlLabel.text`
    : The text of the annotation. HTML tags can be used here.
