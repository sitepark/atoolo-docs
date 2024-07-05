# Symfony Flex integration

[Symfony-Flex](https://symfony.com/doc/current/setup/flex.html){:target="\_blank"} is a powerful tool designed to simplify dependency management and configuration for Symfony projects. It aims to enhance developer productivity and efficiency. The main goals of Symfony-Flex are:

1. **Simplified Installation and Management of Packages**:
   Symfony-Flex integrates with Composer to streamline the installation and updating of dependencies. It provides a user-friendly way to add and configure Symfony bundles and other PHP libraries.

2. **Automatic Configuration**:
   When a new package is installed, Symfony-Flex automatically configures it by creating the necessary configuration files and folders. This reduces the manual effort typically required for configuring new packages.

3. **Optimized Project Structure**:
   Symfony-Flex promotes best practices and a standardized structure for Symfony projects. It establishes a uniform directory structure and best practices that make maintaining and evolving applications easier.

4. **Reduction of Boilerplate Code**:
   By automating configuration and providing predefined recipes for many common libraries and bundles, Symfony-Flex reduces the amount of boilerplate code developers need to write. This accelerates development and simplifies the implementation of new features.

5. **Facilitates Migration and Updates**:
   Symfony-Flex helps manage dependencies and configurations during the migration or updating of Symfony projects. It ensures that the latest versions of packages and their configurations are smoothly integrated.

6. **Improved Developer Experience**:
   Overall, Symfony-Flex enhances the developer experience by simplifying dependency management, configuration, and project structure. It offers seamless integration and tools that optimize the development process.

Through these features, Symfony-Flex aims to make the development of Symfony applications more efficient, consistent, and less error-prone.

## Sitepark Flex Repository

Sitepark provides its own Symfony Flex repository, which contains recipes for various Symfony bundles and libraries. These recipes are tailored to Atoolo Suite and ensure that the configurations are set up correctly. By using the Sitepark Flex repository, developers can benefit from preconfigured recipes that are optimized for Symfony projects in conjunction with Atoolo.

To use the [Sitepark Flex repository](https://github.com/sitepark/symfony-recipes){:target="\_blank"}, add the following entry to the `composer.json` file of your Symfony project:

```sh
composer config extra.symfony.allow-contrib true
composer config --json extra.symfony.endpoint \
'["'\
'https://api.github.com/repos/sitepark/'\
'symfony-recipes/contents/index.json'\
'?ref=flex/main'\
'"]'
composer config --json --merge extra.symfony.endpoint \
'["flex://defaults"]'
```
