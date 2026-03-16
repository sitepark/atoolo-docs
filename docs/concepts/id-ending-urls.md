# ID-ending URLs

Modern CMS systems generate URLs that fulfill two functions: On the one hand, they are readable and descriptive for people, and on the other hand, they are uniquely identifiable for the system. The concept combines a descriptive title (slug) with a unique identification number (ID) at the end of the URL.

A typical URL follows this pattern: `/speaking-path/speaking-title-127`. The slug describes the content clearly, while the number at the end represents the unique ID of the data record. When a user calls up this URL, the ID is extracted and loads the correct data record via it.

The system can always reliably retrieve the correct data record, regardless of whether the slug was entered exactly or not. This makes content management considerably more flexible. If the URL has been changed, a redirect can be used to redirect to the new URL without invalidating the old URL. Content can therefore be easily updated and renamed without breaking existing links.

Speaking URLs are self-explanatory and user-friendly. The slug contains relevant keywords that search engines recognize.

## Translated URLs (RTL languages)

Like the website itself, its URLs are also automatically translated by the CMS. For Arabic pages, for example, this can result in the ID suffix not being on the far right but on the left. The reason for this is the ["Unicode Bidirectional Algorithm"](https://www.unicode.org/reports/tr9/). With UTF-8 characters, this ensures that the characters are displayed in the correct order. This means that the ID is always at the end of the URL, but is displayed either on the left or right depending on the language. An example of an Arabic URL could look like this:

`/مسار-تحدث-عن-الطبيعة-127`

A translated URL can also consist of Arabic and non-Arabic characters. Depending on where the non-Arabic characters are in the text, the ID may also be included on the right.

`/مسار_المشي/التحدث_عن_الطبيعة-vi/vii-123`
