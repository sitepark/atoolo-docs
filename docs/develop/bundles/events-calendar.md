# Events Calendar Bundle

The event calendar is a Sitepark product that enables the publication and management of events on websites. It offers various options for integrating events, including internal management via the content management system (CMS), external entry via web forms and import from other databases. Visitors to the website can search for events filtered by category, keyword and time period, enabling targeted and interest-based navigation. This module is a powerful tool for website operators to efficiently provide and manage information about upcoming events. It also provides integrations to external event calendars.

## Sources

The sources can be accessed via the GibHub project [https://github.com/sitepark/atoolo-events-calendar-bundle](https://github.com/sitepark/atoolo-events-calendar-bundle){:target="\_blank"}.

## Installation

First add the Sitepark Flex Repository before installing the bundle.

See: [Sitepark Flex Repository](../symfony-flex-integration.md#sitepark-flex-repository)

Use [Composer](https://getcomposer.org/){:target="\_blank"} to install this component in your PHP project:

```sh
composer require atoolo/events-calendar-bundle
```

## RCE-Event integration

[RCE-Event](https://www.rce.de/produkte/rce-event/uebersicht/){:target="\_blank"} is establishing itself as the standard in German-speaking countries for the recording, administration, distribution and publication of events.

This bundle provides an indexer that transfers the events from RCE-Event to the search index. This allows the events to be found as an external page via the search.
