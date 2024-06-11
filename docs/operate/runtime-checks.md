# Runtime checks

Atoolo provides a set of runtime checks to ensure that the application is running as expected. These checks can be used to monitor the application's health and to detect potential issues early on.

There are two levels of runtime checks. The first level checks whether the basic requirements are met. These include

- **PHP version**: The minimum PHP version required is stored in the application. This is compared with the currently installed PHP version.
- **PHP extensions**: The PHP extensions required are stored in the application. These are compared with the currently installed PHP extensions.
- **Process user**: The process user that may be used for execution is stored in the application. This is compared with the currently used process user.

These first-level runtime checks are carried out for every request and every CLI command before the application is started. If one of these checks fails, an error is thrown and the application is not started.

The second level of runtime checks checks further requirements. These include

- **Workers**: Checks whether the workers are set up and can process asynchronous tasks.
- **Indexing**: It is checked whether indexing is set up and the full-text search works.
- Other application-specific checks, which can also vary depending on the application.

The runtime checks of the second level are carried out by CLI command or by request.

CLI command:

```sh
/var/www/example.com/www/app/bin/console runtime:check
```

Request:

```
https://www.example.com/runtime-check
```

The URL is usually only accessible for defined IP addresses. The IP addresses can be stored in the configuration of the project.
This URL can be used for monitoring systems to carry out runtime checks regularly and to be notified of errors.
