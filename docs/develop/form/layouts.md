# Layouts

Layout elements in the UI Schema contain other UI Schema elements like controls or other layouts and serve the purpose of defining the layout of those, e.g. a layout could arrange all its contained UI Schema Elements into a horizontal alignment.

See also [UI Schema](https://jsonforms.io/docs/uischema/layouts){:target="\_blank"}.

The form editor currently only uses the following layout:

The input fields can be combined into individual groups in the form editor. These groups are arranged in a vertical layout.

```
- VerticalLayout
  - Group
    - Control
    - Control
    - ...
  - Group
    - Control
    - Control
    - ...
  ...
```

The form editor also provides a contact block. This is arranged below the group and contains additional layout levels for the arrangement of the contact data fields.

```
- VerticalLayout
  - Group
    - ...
    - Group (Start of the contact block)
      - HorizontalLayout (E.g. for the first name and surname field, which should be next to each other.)
        - Control (First name)
        - Control (Surname)
      - ...
  ...
```

## Group

For Group there is an additional option `hideLabel`. This can be used to specify that the label of the group should not be displayed. However, for accessibility reasons, for example, it may be useful to have the label anyway.

```json
{
  "type": "Group",
  "label": "Group",
  "elements": [
    {
      "type": "Control",
      "scope": "#/properties/name"
    }
  ],
  "options": {
    "hideLabel": true
  }
}
```
