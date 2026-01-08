# Error Handling

In addition to the `data` key, the GraphQL specification defines how errors should be formatted in responses. Whether the GraphQL implementation provides partial data along with error information depends on the type of error that occurred. Errors are returned in the `errors` key of the response.

```graphql
mutation webAccountAuthenticationWithPassword {
  webAccountAuthenticationWithPasswordXXX(
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
      "message": "Cannot query field \"webAccountAuthenticationWithPasswordXXX\" on type \"RootMutation\". Did you mean \"webAccountAuthenticationWithPassword\"?",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "extensions": {
        "classification": "ValidationError"
      }
    }
  ]
}
```

Top-level errors work well for certain types of errors but are less suitable for others. They lack a fixed structure and strong typing—key advantages of a GraphQL schema—which makes them less useful for clients to handle programmatically.

## Errors as Data

In the errors-as-data pattern, errors are encoded directly in the schema when the error information is relevant to the end-user experience. Other types of errors should remain in the error array.

Generally, the error array is reserved for [System Errors](#system-errors). These errors typically occur unexpectedly and cannot be handled gracefully by the client. They should be logged and monitored on the server side, while the client displays a generic error message to the user.

Another use case for the error array is errors that can occur across all queries and should be processed centrally by the client. An example is an access-denied error.

In contrast, [Domain Errors](#domain-errors) in the business logic are useful for clients to recognize and communicate to users. These errors should become part of the defined response types in your schema.

GraphQL's Union Types enable elegant and expressive error handling. Instead of relying on traditional exceptions, you explicitly define all possible response scenarios in the schema.

Consider user registration: normally, a registration either succeeds or fails. With Union Types, you can model this precisely in the GraphQL schema. You define a return type that can be either a successfully registered user or a detailed registration error.

The key advantage is predictability and clarity. The client knows exactly which scenarios can occur and must handle them explicitly. This leads to more robust code and better error handling. Instead of catching unexpected exceptions, the client can respond specifically to different error types—such as when an email address already exists or when a password doesn't meet security requirements.

GraphQL essentially forces developers to think through all error cases and document them in the schema. This improves API quality and makes API behavior more predictable.

The following example shows a mutation to complete user registration that can return a domain error when the email address already exists.

```graphql
mutation webAccountFinishRegistration {
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

## System Errors

System Errors represent unexpected technical failures that occur outside of business logic and typically cannot be handled by the client. These errors indicate fundamental infrastructure or runtime problems.

Characteristics of System Errors:

- Prevent complete processing of the request
- Typically require server-side intervention or fixes
- Cannot be directly resolved by the client

Examples of System Errors:

- Database connection failures
- Unhandled exceptions in server code
- Resource exhaustion (e.g., memory, CPU)
- Authentication system failures
- Critical infrastructure problems

The following error types also fall under System Errors:

### Request Errors

Request errors typically occur because the client has made a mistake. For example, the document may contain a syntax error, such as a missing bracket or the use of an unknown keyword for a root operation type.

In this case, no `data` key is returned. Instead, an `errors` key with a list of errors is returned.

### Field Errors

Field errors occur when something unexpected happens during execution. For example, a resolver may throw an error directly or return invalid data, such as a null value for a field with a non-null output type.

In these cases, GraphQL attempts to continue executing other fields and returns a partial response, displaying the data key alongside the errors key.

The `data` key is returned with fields that could not be resolved set to `null`. Additionally, an `errors` key with a list of errors is returned.

### Network Errors

As with network calls to any type of API, network errors that are not specific to GraphQL can occur at any time during a request. These errors block communication between client and server before the request completes, such as SSL errors or connection timeouts. Depending on your GraphQL server and client libraries, they may have built-in features that support special handling of network errors, such as retries for failed operations.

In this case, no response can be received as communication between client and server is blocked. A corresponding HTTP status code may be returned.

### Access Denied Errors

Access-denied errors occur when the client is not authorized to access a particular resource or perform a specific operation. This can happen due to insufficient permissions, invalid authentication tokens, or other security-related issues.

## Domain Errors

Domain Errors represent errors directly related to business logic that are relevant to the client. These errors occur when a request is syntactically correct but cannot be processed due to business rules.

Characteristics of Domain Errors:

- Directly connected to business logic
- Understandable and actionable by the end user
- Enable specific user actions or corrections
- Part of the application model

Examples of Domain Errors:

- Business rule violations
- Duplicate resource creation (e.g., email already exists)
- Invalid state transitions
- Constraint violations (e.g., password requirements not met)

## Client-Side Handling

When consuming the GraphQL API, proper error handling is essential for providing a good user experience. This section explains how to handle both Domain Errors and System Errors in your client application.

### Identifying Error Types

GraphQL responses can contain errors in two different locations:

1. **Domain Errors**: Returned as part of the `data` response using Union Types
2. **System Errors**: Returned in the `errors` array

To distinguish between different Domain Error types, always request the `__typename` field:

```graphql
mutation webAccountFinishRegistration($input: FinishRegistrationInput!) {
  webAccountFinishRegistration(input: $input) {
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

### Handling System Errors Centrally

System Errors should be handled centrally to avoid repetitive error handling code in every query or mutation. Configure your GraphQL client once to handle all System Errors globally.

**Example using urql:**

```javascript
import { Client, cacheExchange, fetchExchange } from 'urql';
import { errorExchange } from '@urql/exchange-error';

// Central error handling exchange
const errorHandlingExchange = errorExchange({
  onError: (error) => {
    const { graphQLErrors, networkError } = error;

    // Handle GraphQL System Errors
    if (graphQLErrors) {
      graphQLErrors.forEach((err) => {
        const classification = err.extensions?.classification;

        console.error('GraphQL System Error', {
          message: err.message,
          classification: classification,
          path: err.path,
        });

        // Show appropriate message based on error type
        switch (classification) {
          case 'ACCESS_DENIED':
            showErrorNotification(
              'You do not have permission to perform this action'
            );
            redirectToLogin();
            break;

          case 'AUTHENTICATION_REQUIRED':
            showErrorNotification('Please log in to continue');
            redirectToLogin();
            break;

          case 'INTERNAL_ERROR':
          default:
            showErrorNotification(
              'An unexpected error occurred. Please try again later'
            );
            reportToErrorTracking(err);
            break;
        }
      });
    }

    // Handle Network Errors
    if (networkError) {
      console.error('Network Error', networkError);
      showErrorNotification('Unable to connect. Please check your connection');
      reportToErrorTracking(networkError);
    }
  },
});

// Create urql client with central error handling
const client = new Client({
  url: '/graphql',
  exchanges: [cacheExchange, errorHandlingExchange, fetchExchange],
});
```

**Using the client with gql.tada:**

```typescript
import { graphql } from 'gql.tada';
import { client } from './client';

// Define query with gql.tada for type safety
const FinishRegistrationMutation = graphql(`
  mutation webAccountFinishRegistration($input: FinishRegistrationInput!) {
    webAccountFinishRegistration(input: $input) {
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
`);

// Execute mutation - System Errors are handled centrally
const result = await client.mutation(FinishRegistrationMutation, { input });
```

### Handling Domain Errors

Unlike System Errors, Domain Errors are handled individually for each query or mutation. Use the `__typename` field to determine the response type and react accordingly.

```typescript
import { graphql } from 'gql.tada';
import { client } from './client';

const FinishRegistrationMutation = graphql(`
  mutation webAccountFinishRegistration($input: FinishRegistrationInput!) {
    webAccountFinishRegistration(input: $input) {
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
`);

// Execute mutation
const result = await client.mutation(FinishRegistrationMutation, { input });

// Handle Domain Errors based on __typename
const registration = result.data?.webAccountFinishRegistration;

if (!registration) {
  // System Error was handled centrally
  return;
}

switch (registration.__typename) {
  case 'FinishRegistrationResult':
    // Success - proceed with normal flow
    showSuccessMessage('Registration completed successfully');
    navigateToLogin(registration.id);
    break;

  case 'EmailAlreadyExistsError':
    // User can fix this - show specific error
    showFieldError(
      'email',
      `${registration.email} is already registered`
    );
    suggestAction('Try logging in or use a different email');
    break;

  default:
    // Unexpected type - log for debugging
    console.error('Unexpected response type:', registration.__typename);
    showGenericError();
}
```

**React Hook Example:**

```typescript
import { useMutation } from 'urql';
import { graphql } from 'gql.tada';

const FinishRegistrationMutation = graphql(`
  mutation webAccountFinishRegistration($input: FinishRegistrationInput!) {
    webAccountFinishRegistration(input: $input) {
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
`);

function RegistrationForm() {
  const [result, executeMutation] = useMutation(FinishRegistrationMutation);

  const handleSubmit = async (formData) => {
    const { data } = await executeMutation({ input: formData });

    // System Errors are already handled centrally
    // Only handle Domain Errors here
    const registration = data?.webAccountFinishRegistration;

    if (!registration) return;

    switch (registration.__typename) {
      case 'FinishRegistrationResult':
        showSuccessMessage('Registration completed');
        navigateToLogin(registration.id);
        break;

      case 'EmailAlreadyExistsError':
        setFieldError('email', `${registration.email} is already registered`);
        break;
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Form fields */}
    </form>
  );
}
```

### Best Practices

**For System Errors:**

- Configure central error handling once at application startup using urql exchanges
- Display generic, user-friendly error messages
- Log detailed error information for debugging and monitoring
- Don't expose technical details to end users
- Report to error tracking systems (e.g., Sentry)
- Handle authentication and authorization errors consistently

**For Domain Errors:**

- Always check `__typename` to identify the response type
- Handle each Domain Error specifically in your query/mutation logic
- Display specific, actionable error messages
- Provide suggestions on how to fix the problem
- Don't treat them as exceptions - they're expected business cases
- Don't log them as errors in monitoring systems

**General Guidelines:**

- Request only the error fields you actually need
- Use gql.tada for type-safe queries and automatic type inference
- Validate input client-side before sending requests when possible
- System Errors are handled centrally, Domain Errors are handled individually
