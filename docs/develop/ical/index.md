# ICal API

The iCal API is used to retrieve [iCalendar](https://icalendar.org/RFC-Specifications/iCalendar-RFC-5545/) data from atoolo resources.

## Endpoints

Currently, the iCal API consists of one endpoint. Given a resource, e.g. a resource that represents an event, this endpoint returns the corresponding scheduling data as an `.ics`-file:

`/api/ical/resource/{lang}/{resource-path}`

`lang`
: Language code for the language in which the resource data should be displayed. This parameter is optional. If it is not specified, the default language of the website is used.

`resource-path`
: Path to the resource whose ical data should be retrieved. This path can also contain `/`.

curl example:

```sh
curl "https://www.example.com/api/ical/en/path/to/resource"
```

The response would be an `.ics`-file that could look like this:

```
BEGIN:VCALENDAR
PRODID:-//atoolo/events-calendar-bundle//1.0/EN
VERSION:2.0
CALSCALE:GREGORIAN
BEGIN:VEVENT
UID:12345-0@www.example.com
DTSTAMP:20250127T143240Z
SUMMARY:Some Event
URL:https://www.example.com/path/to/resource.php
DTSTART;TZID=Europe/Berlin:20241210T000000
DTEND;TZID=Europe/Berlin:20241210T235959
END:VEVENT
END:VCALENDAR
```

Keep in mind that if the requested resource has no scheduling data, the response will still consist of an `.ics`-file that, however, is empty, meaning it would have no `VEVENT` data. 