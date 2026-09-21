# Atoolo

_Web Data Processing Suite_

## Overview

Atoolo (pronounced *[aˈtuːlu]*) is a comprehensive collection of PHP libraries and tools specifically designed to optimize the processing of pre-produced data for websites. Atoolo is not a stand-alone framework, but serves as a supplement to the Symfony framework. It extends projects with special functionalities that are not included in Symfony as standard. Atoolo contains various Symfony bundles that integrate seamlessly into Symfony projects. Atoolo takes on the task of a front-end delivery system and prepares the data of a content management system (CMS) for the requirements of a front-end system.

## Key Features

### GraphQL interface

Atoolo facilitates the creation and deployment of GraphQL interfaces. These interfaces enable web applications to access structured data, perform complex search queries and interact with the components of the suite for dynamic data processing.

### Full-text index integration

Atoolo provides tools and methods for full-text indexing of data. This functionality enables large amounts of data to be searched efficiently and relevant information to be found quickly.

### GenAI

Atoolo can index the same data into an external GenAI application - embedding and vector database - and ask that application questions about it. The GenAI technology itself is not part of the suite, just as the search server is not: Atoolo prepares the content, keeps the index up to date and provides the interface to query it. A project decides per target which ones it feeds, so a GenAI index can be built next to a full-text index or on its own.

### Form processing

Atoolo offers a comprehensive system for form processing. The forms defined by the CMS system are validated and the submitted form data is further processed. The form processing system is highly customizable and can be adapted to the specific requirements of the web application.

### WebAccount

The WebAccount is a central user account with which users can register and log in to a website. It is used for identification, authorization and personalization within a site.

### Extranet

The extranet is a special operating module in which all requests are initially protected. Only authenticated users can access the resources. The only exceptions to this are requests for login, registration and password recovery.

### SEO

Atoolo provides a set of tools for search engine optimization (SEO). These tools help to improve the visibility of web applications in search engine results and increase the number of visitors to the site. (Currently only the sitemap XML functionality is offered.)

### Microsites

Atoolo offers a system to support microsites. Microsites are compact, thematically focused websites that deal exclusively with a specific topic. They are often used to highlight specific topics such as events, projects, offers or campaigns.

### URL rewriting

Atoolo offers a URL rewriting system that allows URLs to be manipulated centrally. This system is used to manipulate URLs that are returned by the system via a centralized point. The URL rewriter can be used to manipulate URLs within returned JSON or XML data, for example.

### Runtime checks

To ensure the proper functioning of web applications, Atoolo offers a series of runtime checks. These monitoring mechanisms help to detect potential problems at an early stage and ensure the reliability and stability of the application.

### Deployment

Atoolo provides various tools and methods to facilitate and automate the deployment of web applications.
