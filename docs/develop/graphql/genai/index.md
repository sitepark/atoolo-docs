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

The fields follow the [errors as data](../error-handling.md#errors-as-data)
pattern of the Atoolo GraphQL API: a question the indexed resources do not
answer is no failure but a result of its own type, a
[domain error](../error-handling.md#domain-errors) the frontend tells the user
about. Only a question that cannot be asked at all is a
[system error](../error-handling.md#system-errors) in the `errors` array, see
[Errors](#errors).

## Ask a question

```graphql
query {
  genAiQuestion(query: "When is the citizens' office open?", lang: "en") {
    __typename
    ... on GenAiAnsweredQuestion {
      id
      feedbackToken
    }
    ... on GenAiAnswer {
      sections {
        __typename
        headline
        sources {
          url
          title
        }
        ... on GenAiTextSection {
          html
        }
        ... on GenAiLinksSection {
          links {
            url
            label
          }
        }
      }
    }
    ... on GenAiNoMatchingDocumentsError {
      hints {
        headline
        html
      }
      suggestedQuestions
    }
  }
}
```

| Argument | Description |
| --- | --- |
| `query` | The question. |
| `lang` | Language of the question, e.g. `en`. Without it, the language of the channel is used. |
| `categoryIds` | Restricts the retrieved resources to these categories. A parent category also matches its subcategories, several ids are combined with OR. |

`genAiQuestion` returns the union `GenAiQuestionResult`. `__typename` says
which of its types the result is:

| Type | Meaning |
| --- | --- |
| `GenAiAnswer` | The answer to the question. |
| `GenAiNoDocumentsError` | No resource was similar enough to the question. |
| `GenAiNoMatchingDocumentsError` | Resources were found, but none of them answers the question. |
| `GenAiAnswerCutOffError` | The answer became longer than the GenAI application allows and was discarded. |
| `GenAiUnansweredError` | Any other reason the GenAI application did not answer, one this version of the bundle does not know yet. |

All of them implement the interface `GenAiAnsweredQuestion` with `id`,
`feedbackToken` and `duration`, the runtime in seconds. `id` is the id under
which the GenAI application stored the result, `null` if it was not stored.
The `feedbackToken` is needed to [give feedback](#give-feedback); an
unanswered question can be rated as well. Request the fields of the types
you handle; a frontend should also handle a type it does not know, as the
list may grow.

### The answer

A `GenAiAnswer` is made up of sections. Each implements the interface
`GenAiAnswerSection` with `headline` and `sources` and is one of two types:

- `GenAiTextSection` - prose, lists or tables in `html`. E-mail addresses and
  phone numbers are links with `mailto:` and `tel:`.
- `GenAiLinksSection` - a list of links in `links`, each with a `label`, which
  is empty if the source offers none.

`sources` names the resources the content of a section comes from, so that
the frontend can link them.

```json
{
  "data": {
    "genAiQuestion": {
      "__typename": "GenAiAnswer",
      "id": "8f1c2a4e-3b7d-4e0a-9c55-1d2e3f4a5b6c",
      "feedbackToken": "q4Zr8vK2pT1nX7bL0sYwE5mH",
      "sections": [
        {
          "__typename": "GenAiTextSection",
          "headline": "Opening hours",
          "sources": [
            {
              "url": "https://www.example.com/citizens-office.php",
              "title": "Citizens' office"
            }
          ],
          "html": "<p>The citizens' office is open Monday to Friday from 8 am to 4 pm.</p>"
        },
        {
          "__typename": "GenAiLinksSection",
          "headline": "More information",
          "sources": [],
          "links": [
            {
              "url": "https://www.example.com/appointments.php",
              "label": "Book an appointment"
            }
          ]
        }
      ]
    }
  }
}
```

### Unanswered questions

What the user is told about an unanswered question is up to the frontend.
Only a `GenAiNoMatchingDocumentsError` carries more than the common fields:
`hints` are text sections how to ask more precisely, and
`suggestedQuestions` lists at most three questions the user probably meant,
which can be offered for asking with one click. Both may be empty.

```json
{
  "data": {
    "genAiQuestion": {
      "__typename": "GenAiNoMatchingDocumentsError",
      "id": "0b9e7d6c-5a4f-4321-8e7d-6c5b4a3f2e1d",
      "feedbackToken": "Hn3Wc9aQ6xR0uJ4mZ8kD2fVt",
      "hints": [
        {
          "headline": "",
          "html": "<p>Please say which office you mean.</p>"
        }
      ],
      "suggestedQuestions": [
        "When is the citizens' office open?",
        "When is the registry office open?"
      ]
    }
  }
}
```

## Give feedback

A user can rate a result as `GOOD` or `BAD` with the `feedbackToken` it came
with:

```graphql
mutation {
  genAiAnswerFeedback(feedbackToken: "q4Zr8vK2pT1nX7bL0sYwE5mH", feedback: GOOD)
}
```

The token is valid for 15 minutes by default. Within that time the feedback
can be set, changed or withdrawn as often as wanted; without `feedback` a
rating given before is withdrawn. Afterwards, or if the content of the answer
was deleted, the result is `false`. A result without a token (`null`) cannot
be rated. The token binds the feedback to the user who asked: keep it in the
memory of the page only, never in `localStorage` or the URL.

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

If a question cannot be asked or a feedback not be given, the field fails
with an error in the `errors` array. Its `extensions.classification` says
why, so that the frontend can tell the user what to do:

| Classification | Meaning |
| --- | --- |
| `BAD_REQUEST` | The GenAI application does not accept the request, the message says why: the question is longer than 1000 characters, the language is no ISO 639 code like `de`, more than 20 categories are given, or nothing is indexed in the channel yet. |
| `TOO_MANY_REQUESTS` | The visitor, or all visitors together, asked too many questions in the last minute. The question may be asked again later. |
| `INTERNAL_ERROR` | The GenAI application cannot be reached or failed. The message is a general one, the cause is logged by the website. |

```json
{
  "errors": [
    {
      "message": "Too many questions, please try again later",
      "path": ["genAiQuestion"],
      "extensions": {
        "classification": "TOO_MANY_REQUESTS"
      }
    }
  ],
  "data": null
}
```

An operation may ask only one question. Selecting `genAiQuestion` more than
once, e.g. under aliases, fails with `BAD_REQUEST`.

See [Error handling](../error-handling.md) for how a client handles both
kinds of error.
