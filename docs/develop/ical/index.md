# ICal API

The **ICal API** allows you to retrieve [iCalendar](https://icalendar.org/RFC-Specifications/iCalendar-RFC-5545/) data from atoolo resources. This data is returned as standard `.ics` files, compatible with most calendar applications.

---

## Endpoints

### 1. Get Resource Calendar

Retrieves the scheduling data for a specific resource.

**Endpoint:**
`GET /api/ical/resource/{lang}/{resource-path}`

**Parameters:**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `lang` | `string` | No | Language code for the output (e.g., `en`, `de`). If omitted, the website's default language is used. |
| `resource-path` | `string` | **Yes** | The path to the specific resource. This path may contain slashes (e.g., `path/to/resource`). |

**Request Example:**

```bash
curl "https://www.example.com/api/ical/resource/en/path/to/resource"

```

**Response Example:**

The API returns a `.ics` file.

```ics
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

> **Note:** If the requested resource exists but has no scheduling data, the API returns a valid `.ics` file without `VEVENT` entries.

---

### 2. Search Resource Calendars

Retrieves scheduling data for multiple resources based on a search query, combined into a single calendar file.

**Endpoint:**
`GET /api/ical/search?query={query}`

**Parameters:**

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `query` | `JSON` | **Yes** | A JSON-serialized [SearchQuery](https://github.com/sitepark/atoolo-search-bundle/blob/main/src/Dto/Search/Query/SearchQuery.php) object. |

**Request Example:**

```bash
curl "https://www.example.com/api/ical/search?query={\"filter\":[{\"type\":\"group\",\"values\":[\"11431\"]},{\"type\":\"category\",\"values\":[\"11052\"]}]}"

```