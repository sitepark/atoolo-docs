# Error handling

The response of a GraphQL query always contains a `data` field in case of success. In the event of an error, the `data` field is not set; instead, an `errors` field containing a list of errors is returned.

## Example of a failed request

```graphql
mutation webaccountAuthenticationWithPassword {
  webaccountAuthenticationWithPasswordXXX(
    username: "peterpan"
    password: "develop"
    setJwtCookie: true
  ) {
    status
    user {
      id
      username
      firstName
      lastName
      email
      roles
    }
  }
}
```

```json
{
  "errors": [
    {
      "message": "Cannot query field \"webaccountAuthenticationWithPasswordXXX\" on type \"RootMutation\". Did you mean \"webaccountAuthenticationWithPassword\"?",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ]
    }
  ]
}
```
