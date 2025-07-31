# WebAccount

The WebAccount is a central user account with which users can register and log in to a website. It is used for identification, authorization and personalization within a site.

The basis for the WebAccount functionality is the [WebAccount Bundle](../../bundles/web-account.md). This bundle provides a GraphQL API for user authentication and thus enables flexible integration into front-end applications.

## Authentication

Authentication takes place via user name and password. See also: [Webaccount authentication](../../../concepts/web-account.md#authentication).

```grahql
mutation {
  webAccountAuthenticationWithPassword(
    username: "peterpan"
    password: "tinkerbell"
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

The `setJwtCookie` option can be used to specify whether a JWT cookie should be set that is used for authentication in the application. If this option is set to `true`, a cookie with the name `WEB_ACCOUNT_TOKEN` is set, which contains the JWT token. This token can then be used in subsequent requests to identify and authenticate the user.

### Authentication successful

If authentication is successful, the `WEB_ACCOUNT_TOKEN` cookie is set and the response contains the status `SUCCESS` and the user data:

```
set-cookie WEB_ACCOUNT_TOKEN=eyJ0eXA...; expires=Fri, 29 Aug 2025 09:08:58 GMT; Max-Age=2592000; path=/; secure; httponly; samesite=strict
```

```json
{
  "data": {
    "webAccountAuthenticationWithPassword": {
      "status": "SUCCESS",
      "user": {
        "id": "100010100000002469",
        "username": "peterpan",
        "firstName": "Peter",
        "lastName": "Pan",
        "email": "pan@neverland.com",
        "roles": [
          "IES_ID_100010100000001012",
          "IES_USRP_EDITORIAL",
          "IES_ID_100010100000001028",
          "USRP_INTERNETWEBSITE_PROTECTED"
        ]
      }
    }
  }
}
```

### Authentication failed

```json
{
  "data": {
    "webAccountAuthenticationWithPassword": {
      "status": "FAILURE"
  }
}
```

## Unset JWT Cookie

To log out a user and unset the JWT cookie, you can use the following mutation:

```graphql
mutation webAccountUnsetJwtCookie {
  webAccountUnsetJwtCookie
}
```

This mutation removes the `WEBACCOUNT_TOKEN` cookie from the user's browser by sending the `Set-Cookie` header with an expired date, effectively logging the user out of the application.

```
set-cookie WEB_ACCOUNT_TOKEN=deleted; expires=Tue, 30 Jul 2024 09:15:25 GMT; Max-Age=0; path=/; secure; httponly; samesite=strict
```

The JSON response is:

```json
{
  "data": {
    "webAccountUnsetJwtCookie": true
  }
}
```
