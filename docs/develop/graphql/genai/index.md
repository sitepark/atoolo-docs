# GenAI

A question is answered by an external GenAI application from the resources
indexed there. The basis is the [GenAI Bundle](../../bundles/genai.md). It
offers asking a question and giving feedback on the answer as fields of the
Atoolo GraphQL API.

The request is not passed on to the GenAI application as it is. The bundle
sends fixed operations of its own, so only the public part of the application
can be reached, and the channel is always the one of the site.

The GenAI application limits the requests per ip address of the visitor. See
[Client ip](../../bundles/genai.md#client-ip) for what this requires of the
setup.

## Ask a question

```graphql
query {
  genAiQuestion(query: "When is the citizens' office open?", lang: "en") {
    id
    error
    sections {
      type
      headline
      html
      links {
        url
        label
      }
      sources {
        url
        title
      }
      questions
    }
  }
}
```

| Argument | Description |
| --- | --- |
| `query` | The question. |
| `lang` | Language of the question, e.g. `en`. Without it, the language of the channel is used. |
| `categoryIds` | Restricts the retrieved resources to these categories. A parent category also matches its subcategories, several ids are combined with OR. |

The answer is made up of sections, each of which is one of two types:

- `TEXT` - prose, lists or tables in `html`. E-mail addresses and phone
  numbers are links with `mailto:` and `tel:`.
- `LINKS` - a list of links in `links`, each with a `label`, which is empty
  if the source offers none.

The field that does not apply to the type is empty. `sources` names the
resources the content of a section comes from, so that the frontend can link
them.

```json
{
  "data": {
    "genAiQuestion": {
      "id": "8f1c2a4e-3b7d-4e0a-9c55-1d2e3f4a5b6c",
      "error": null,
      "sections": [
        {
          "type": "TEXT",
          "headline": "Opening hours",
          "html": "<p>The citizens' office is open Monday to Friday from 8 am to 4 pm.</p>",
          "links": [],
          "sources": [
            {
              "url": "https://www.example.com/citizens-office.php",
              "title": "Citizens' office"
            }
          ],
          "questions": []
        },
        {
          "type": "LINKS",
          "headline": "More information",
          "html": "",
          "links": [
            {
              "url": "https://www.example.com/appointments.php",
              "label": "Book an appointment"
            }
          ],
          "sources": [],
          "questions": []
        }
      ]
    }
  }
}
```

`id` is the id under which the GenAI application stored the answer. It is
needed to [give feedback](#give-feedback) and is `null` if the answer was not
stored.

### Unanswered questions

If the indexed resources do not answer the question, `error` says why:

| Error | Meaning |
| --- | --- |
| `NO_DOCUMENTS` | No resource was similar enough to the question. |
| `NO_MATCHING_DOCUMENTS` | Resources were found, but none of them answers the question. |

What the user is told about it is up to the frontend. The sections of such an
answer are hints how to ask more precisely, possibly none. `questions` lists
questions the user probably meant, which can be offered for asking with one
click.

```json
{
  "data": {
    "genAiQuestion": {
      "id": "0b9e7d6c-5a4f-4321-8e7d-6c5b4a3f2e1d",
      "error": "NO_MATCHING_DOCUMENTS",
      "sections": [
        {
          "type": "TEXT",
          "headline": "",
          "html": "<p>Please say which office you mean.</p>",
          "links": [],
          "sources": [],
          "questions": [
            "When is the citizens' office open?",
            "When is the registry office open?"
          ]
        }
      ]
    }
  }
}
```

## Give feedback

A user can rate an answer as `GOOD` or `BAD`:

```graphql
mutation {
  genAiAnswerFeedback(
    answerId: "8f1c2a4e-3b7d-4e0a-9c55-1d2e3f4a5b6c"
    feedback: GOOD
  )
}
```

Without `feedback` a rating given before is withdrawn. The result is `false`
if the GenAI application knows no answer with this id.

```json
{
  "data": {
    "genAiAnswerFeedback": true
  }
}
```

The feedback given cannot be read back through the API. A frontend that shows
the rating keeps what it has set itself.

## Errors

If the GenAI application cannot be reached or rejects the request, the field
fails with an error whose message names the cause. See also
[Error handling](../error-handling.md).
