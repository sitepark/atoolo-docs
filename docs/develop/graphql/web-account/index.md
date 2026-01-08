# WebAccount

The WebAccount is a central user account with which users can register and log in to a website. It is used for identification, authorization and personalization within a site.

The basis for the WebAccount functionality is the [WebAccount Bundle](../../bundles/web-account.md). This bundle provides a GraphQL API for user authentication and thus enables flexible integration into front-end applications.

## Authentication

Authentication takes place via user name and password. See also: [Webaccount authentication](../../../concepts/web-account.md#authentication).

```graphql
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

## Registration

The registration process is implemented through two GraphQL mutations that correspond to the two-phase registration workflow. See also: [WebAccount Registration](../../../concepts/web-account.md#registration).

### webAccountStartRegistration

Initiates the registration process by requesting a verification code to be sent to the provided email address.

**Input:**

```graphql
input StartRegistrationInput {
  configName: String!
  emailAddress: String!
  lang: String!
}
```

- `configName`: The configuration name identifying which WebAccount configuration to use. This allows for multiple WebAccount configurations within the same system.
- `emailAddress`: The email address where the verification code will be sent.
- `lang`: The language code for the email template (e.g., "en", "de", "fr").

**Output:**

```graphql
type StartRegistrationResult {
  challengeId: String!
  createAt: DateTime!
  expiresAt: DateTime!
}
```

- `challengeId`: A unique identifier for this registration attempt, used to complete the registration in the second phase.
- `createAt`: Timestamp indicating when the challenge was created.
- `expiresAt`: Timestamp indicating when the challenge expires and can no longer be used.

**Example:**

```graphql
mutation {
  webAccountStartRegistration(
    input: {
      configName: "default"
      emailAddress: "user@example.com"
      lang: "en"
    }
  ) {
    challengeId
    createAt
    expiresAt
  }
}
```

**Response:**

```json
{
  "data": {
    "webAccountStartRegistration": {
      "challengeId": "550e8400-e29b-41d4-a716-446655440000",
      "createAt": "2026-01-08T10:30:00Z",
      "expiresAt": "2026-01-08T11:00:00Z"
    }
  }
}
```

### webAccountFinishRegistration

Completes the registration process by verifying the code and creating the user account with the provided information.

**Input:**

```graphql
input FinishRegistrationInput {
  configName: String!
  lang: String!
  challengeId: String!
  code: Int!
  firstName: String
  lastName: String!
  password: String!
}
```

- `configName`: The configuration name used in the start registration phase.
- `lang`: The language code for the confirmation email template.
- `challengeId`: The challenge ID received from the start registration mutation.
- `code`: The numeric verification code sent to the user's email address.
- `firstName`: The user's first name (optional).
- `lastName`: The user's last name.
- `password`: The password for the new account.

**Output:**

```graphql
union FinishUserRegistrationResultType =
    FinishRegistrationResult
  | EmailAlreadyExistsError

type FinishRegistrationResult {
  id: ID!
  email: String!
}

type EmailAlreadyExistsError {
  email: String!
}
```

The mutation returns a union type that can be either:

- `FinishRegistrationResult`: Successful registration with the new user's ID and email.
- `EmailAlreadyExistsError`: Error indicating that the email address is already associated with an existing account.

**Example:**

```graphql
mutation {
  webAccountFinishRegistration(
    input: {
      configName: "default"
      lang: "en"
      challengeId: "550e8400-e29b-41d4-a716-446655440000"
      code: 123456
      firstName: "John"
      lastName: "Doe"
      password: "SecurePassword123!"
    }
  ) {
    __typename
    ... on FinishRegistrationResult {
      id
      email
    }
    ... on EmailAlreadyExistsError {
      email
    }
  }
}
```

**Successful Response:**

```json
{
  "data": {
    "webAccountFinishRegistration": {
      "__typename": "FinishRegistrationResult",
      "id": "100010100000002500",
      "email": "user@example.com"
    }
  }
}
```

**Error Response (Email Already Exists):**

```json
{
  "data": {
    "webAccountFinishRegistration": {
      "__typename": "EmailAlreadyExistsError",
      "email": "user@example.com"
    }
  }
}
```

## Password Recovery

The password recovery process is implemented through two GraphQL mutations that correspond to the two-phase recovery workflow. See also: [WebAccount Password Recovery](../../../concepts/web-account.md#password-recovery).

### webAccountStartPasswordRecovery

Initiates the password recovery process by requesting a verification code to be sent to the email address associated with the provided username.

**Input:**

```graphql
input StartPasswordRecoveryInput {
  configName: String!
  username: String!
  lang: String!
}
```

- `configName`: The configuration name identifying which WebAccount configuration to use.
- `username`: The username (typically email address or login name) for which to recover the password.
- `lang`: The language code for the email template.

**Output:**

```graphql
type StartPasswordRecoveryResult {
  challengeId: String!
  createAt: DateTime!
  expiresAt: DateTime!
}
```

- `challengeId`: A unique identifier for this recovery attempt, used to complete the recovery in the second phase.
- `createAt`: Timestamp indicating when the challenge was created.
- `expiresAt`: Timestamp indicating when the challenge expires and can no longer be used.

**Example:**

```graphql
mutation {
  webAccountStartPasswordRecovery(
    input: { configName: "default", username: "user@example.com", lang: "en" }
  ) {
    challengeId
    createAt
    expiresAt
  }
}
```

**Response:**

```json
{
  "data": {
    "webAccountStartPasswordRecovery": {
      "challengeId": "660e8400-e29b-41d4-a716-446655440001",
      "createAt": "2026-01-08T10:45:00Z",
      "expiresAt": "2026-01-08T11:15:00Z"
    }
  }
}
```

### webAccountFinishPasswordRecovery

Completes the password recovery process by verifying the code and updating the user's password.

**Input:**

```graphql
input FinishPasswordRecoveryInput {
  configName: String!
  lang: String!
  challengeId: String!
  code: Int!
  newPassword: String!
}
```

- `configName`: The configuration name used in the start recovery phase.
- `lang`: The language code for the confirmation email template.
- `challengeId`: The challenge ID received from the start recovery mutation.
- `code`: The numeric verification code sent to the user's email address.
- `newPassword`: The new password to set for the account.

**Output:**

```graphql
Boolean!
```

The mutation returns `true` if the password was successfully updated, or throws an error if the recovery fails.

**Example:**

```graphql
mutation {
  webAccountFinishPasswordRecovery(
    input: {
      configName: "default"
      lang: "en"
      challengeId: "660e8400-e29b-41d4-a716-446655440001"
      code: 654321
      newPassword: "NewSecurePassword456!"
    }
  )
}
```

**Response:**

```json
{
  "data": {
    "webAccountFinishPasswordRecovery": true
  }
}
```

## Common Patterns

All GraphQL mutations in the WebAccount API follow these common patterns:

**Configuration Parameter:**
All mutations require a `configName` parameter that identifies which WebAccount configuration to use. This enables multi-tenancy and different configurations for different contexts within the same application.

**Language Support:**
All mutations include a `lang` parameter to specify the language for email templates. This ensures that users receive emails in their preferred language.

**Challenge-Based Verification:**
Both registration and password recovery use a challenge-based verification system where:

1. The first mutation generates a challenge ID and sends a verification code via email.
2. The second mutation requires the challenge ID and verification code to complete the operation.
3. Challenges have expiration timestamps to limit the time window for completion.

**Error Handling:**
Errors are communicated through:

- Union types that allow returning either success or error objects (e.g., `FinishUserRegistrationResultType`).
- GraphQL errors with specific error classes for handling different failure scenarios.
- Boolean return values combined with exceptions for simple success/failure operations.
