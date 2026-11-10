# Resource channel

The resource channel is the area in which the IES publishes resources. A channel is a directory that is always assigned to a specific virtual host.

Directory layout For example, for the `www` area:

```
/var/www/example.com/www/
├── app/ (symlink to application directory)
│   └── bin/
│   │   └── console
│   ├── public/
│   │   └── index.php
│   └── ...
├── frontend/ (symlink to frontend dirctory)
│   └── public/
└── resources/
    ├── objects/
    ├── media/
    │   ├── public/
    │   └── protected/
    ├── security/
    ├── redirects/
    ├── configs/
    └── context.php
```

The resource channel is the directory `/var/www/example.com/www/resources/`. This directory is described exclusively by the IES.

## Resource channel context

The `resources/context.php` contains information about the resource channel. The information is divided into 3 sections: `server`, `tenant` and `channel`.

| Keys                 | Description                                                        |
| -------------------- | ------------------------------------------------------------------ |
|                      |                                                                    |
| `server`             | Information about the CMS system that provides the resources       |
| `server.host`        | The host of the CMS system                                         |
| `server.version`     | Version of the CMS system                                          |
|                      |                                                                    |
| `tenant`             | Information about the client for which the resources are provided  |
| `tenant.id`          | ID of the tenant                                                   |
| `tenant.anchor`      | Anchor of the tenant                                               |
| `tenant.name`        | Name of the tenant                                                 |
|                      |                                                                    |
| `channel`            | Information about the resource channel                             |
| `channel.id`         | ID of the resource channel                                         |
| `channel.name`       | Name of the resource channel                                       |
| `channel.serverName` | Server name under which the website for this channel is accessible |
| `channel.locale`     | Default locale for the resources in this channel                   |

## Objects

The resource objects are stored below `/resources/objects`. These objects are the data objects that are published by the IES. They can be articles, but also other objects that can be published by CMS. The files are stored using the ID scheme `/123/123/123.php`, whereby the ID of the object is divided into three parts. Missing positions are filled with `0`. For example, the resource with the ID `123` is stored under `/resources/objects/000/000/123.php`.

```
/var/www/example.com/www/
└── resources/
    └── objects/
        └── 000/
            └── 000/
                └── 123.php
```

The CMS can automatically translate the textual data of a resource. The complete data records with the translated textual data are stored in a separate directory level, which is derived from the path of the original resource. For the above example, the translation would be stored in the directory `/resources/objects/000/000/123.translations`. The file name of the translation corresponds to the locale of the translation, for example `it_IT.php` for an Italian translation.

```
/var/www/example.com/www/
└── resources/
    └── objects/
        └── 000/
            └── 000/
                ├── 123.php
                └── 123.translations/
                    ├── fr_FR.php
                    ├── it_IT.php
                    └── nl_NL.php
```

## Manifest

The channel provides a compiled manifest file, located at `/resources/configs/manifest.php`, that the delivery layer uses to resolve incoming paths to their target. It covers system routes (such as the homepage and the error pages, which have no ID-ending URL to resolve), the exact path-to-content mappings behind [ID-ending URLs](id-ending-urls.md), and centrally managed redirects.

The full structure and semantics of the manifest – mappings, redirects, delivery modes and resolution order – are described in [Site Manifest](id-ending-urls.md#site-manifest). The excerpt below shows the system routes (which make cases like the homepage `https://www.example.com` and the 404 error page resolvable at all) together with one exact path mapping:

```php
<?php return [
   // System routes
   "home" => 1118,
   "errors" => [
      "401" => 1140,
      "404" => 1138,
      "403" => 1139,
      "500" => 1136,
      "410" => 1137
   ],

   // Exact path -> content mapping (redirects omitted, see Site Manifest)
   "mappings" => [
      "/kultur" => [
         "id"   => 16711,
         "mode" => "FORWARD"
      ]
   ]
];
```

Microsites have their own homepage and also their own error pages. Therefore, a manifest file is also provided for each microsite, which is located in the directory `/resources/configs/microsite/{microsite-name}/manifest.php`. This file has the same structure as the manifest file for the main channel.

```
/var/www/example.com/www/
└── configs/
    ├── manifest.php
    └── microsite/
        └── spezial-example/
            └── manifest.php
```

## Media

The media files provided via the CMS, such as images and PDFs, are stored in the `/resources/media` directory. There are two subdirectories: `public` and `protected`. Media files that are publicly accessible are stored in `public`. Media files that are only accessible to certain user groups are stored in `protected`.

A media URL contains the stable ID of the medium, but its path (slug) can change over time. Requests are therefore not simply served from the file system: they are resolved so that a changed URL can issue a redirect while the medium itself is always identified by the unchanged ID. For performance there is a _bypass_ that lets the web server (Apache) deliver media directly – in practice this is only used for images. Protected media are always delivered via a PHP endpoint that checks the access rights before the file is delivered. How media URLs are resolved, redirected and bypassed is described in [Media delivery](media-delivery.md).

The file names of the media do not follow the ID scheme of the resource objects, as the file name of the media should be retained. The path in the file system also corresponds to the path used in the URL. For protected media, it is nevertheless necessary to know the ID of the medium in order to be able to check the necessary authorizations. The ID is therefore specified in the last path segment before the file name. The path of a medium can then be `/dir/1233/filename.pdf` where `1233` is the ID of the medium. Even if this ID is not necessary for the public media, it is also specified here in order to standardize the handling of the media.

```
/var/www/example.com/www/
└── resources/
    └── media/
        ├── public/
        │   └── dir/
        │       └── 1233
        │           └── filename.pdf
        └── protected/
            └── dir/
                └── 1234
                    └── filename.pdf
```

### Scaled image variants

Image media can have scaled variants (e.g. different display sizes). These variants are stored next to the original file in a directory named after the original file name with a `.scaled` suffix. The individual variants are named by a hash. For the medium `image.jpg` with the ID `1163`, the layout is:

```
/var/www/example.com/www/
└── resources/
    └── media/
        └── public/
            └── dir/
                └── 1163/
                    ├── image.jpg
                    └── image.jpg.scaled/
                        └── fb0918db219ac3539f2c82e83665a235.jpg
```

The exact on-disk layout is derived from the URL form (see [Media delivery](media-delivery.md#scaled-image-variants)); the hash naming should be confirmed against the implementation.

### Media meta file

In addition to the media files, the CMS also provides meta data for the media. This meta data is stored as a resource object. For the medium with the ID `1233`, the meta file is stored under `/resources/objects/000/001/233.php`. This file contains the meta data of the medium. For example, the authorizations for the medium that are relevant for protected media. Meta files are also translated automatically.

```
/var/www/example.com/www/
└── resources/
    ├── media/
    │   └── public/
    │       └── dir/
    │           └── 1233
    │               └── filename.pdf
    └── objects/
        └── 000/
            └── 001/
                ├── 233.php
                └── 233.translations/
                    ├── fr_FR.php
                    ├── it_IT.php
                    └── nl_NL.php
```

## Embedded Media

If an article in the CMS uses a medium, e.g. to display an image on the website or a PDF as a download link, then the article can create a link to a centrally provided medium and a medium as in [Media](#media) is used. Alternatively, a medium can also be uploaded directly to the article and thus become part of the article. These media are referred to as embedded media. These media must be handled separately by the CMS and are also assigned to the corresponding resource of the article in the file system. For this purpose, a `.media` suffix is appended based on the URL path of the article and provided as a directory in which the media is stored.

`/resources/media/public/dir/article-filename.media`

A subdirectory with the ID of the resource and the ID of the medium is created for each medium. The ID is also required here if the medium is protected. This is implicitly the case if the article is protected. The media file is stored in this directory. With a medium ID of `432`, the path would look like this:

`/resources/media/public/dir/article-filename.media/1123-432/filename.pdf`.

Embedded media also have a meta data file, which is also stored as a resource object, but is subordinate to the article. For the medium with the ID `432`, the meta file would be stored under `/resources/objects/000/001/123.media/432.php`.

The embedded media can also be translated automatically and have a `.translations` directory. For the above example, the translation would be stored in the directory `/resources/objects/000/001/123.media/432.translations`.

```
/var/www/example.com/www/
└── resources/
    ├── media/
    │   └── public/
    │       └── dir/
    │           └── article-filename.media
    │               └── 1123-432
    │                    └── filename.pdf
    └── objects/
        └── 000/
            └── 001/
                └── 123.media
                        ├── 432.php
                        └── 432.translations/
                                ├── fr_FR.php
                                ├── it_IT.php
                                └── nl_NL.php
```

Embedded image media can also have scaled variants. As with central media, these are stored next to the embedded file in a `{file-name}.scaled/` directory whose entries are named by a hash, e.g. `article-filename.media/1123-432/image.jpg.scaled/<hash>.jpg`.

## Embedded media from media

There is a special case when embedded media exist that are not subordinate to an article but to a medium. This can be the case, for example, if you want to store a preview image for a PDF in the CMS. In this case, the suffix of the medium is also part of the URL path.

```
/var/www/example.com/www/
└── resources/
    ├── media/
    │   └── public/
    │       └── dir/
    │           └── 123/
    │               └── filename.pdf.media/
    │                   └── 123-432/
    │                       └── preview.jpg
    └── objects/
        └── 000/
            └── 001/
                └── 123.media
                        ├── 432.php
                        └── 432.translations/
                                ├── fr_FR.php
                                ├── it_IT.php
                                └── nl_NL.php
```

## Temporary resources

The CMS could be used to provide resource objects via a preview function that are not permanently stored in the resource channel, but are only temporarily available for the preview. These temporary resources are stored under `/resources/objects/tmp` and deleted regularly. The temporary file names are derived from a counter that is reset to 0 each time the CMS is started. The file names have the form `001.php`, `002.php` etc.

Temporary resources can also have embeddd meanings. The meta file for the embedded media is then saved under `/resources/objects/tmp/001.media/432.php`. The translated resources are saved under `/resources/objects/tmp/001.media/432.translations`.

The resource can then be accessed via the web server using URLs of the form `/path/tmp-1`. As with permanent embedded media, the sub-directory carries a two-part ID `{tmp-counter}-{mediaId}` – the first part is the ID of the temporary resource (the counter), the second is the ID of the medium. The embedded media are then stored under paths such as `/dir/tmp-1.media/1-432/image.jpg`. They are then also stored accordingly under `media/public`.

```
/var/www/example.com/www/
└── resources/
    ├── media/
    │   └── public/
    │       └── dir/
    │           └── tmp-1.media/
    │               └── 1-432/
    │                   └── image.jpg
    └── objects/
        └── tmp/
            ├── 001.php
            └── 001.translations/
                ├── fr_FR.php
                ├── it_IT.php
                └── nl_NL.php
```

## Security - Users and Roles

Files containing information about users and roles can be stored below `/resources/security`.
These can be generated by the CMS and are evaluated by the [Security Bundle](../develop/bundles/security.md).

## Redirects

Here the CMS can store alias and redirect rules that are evaluated by the routing. The file names are freely selectable. An example of a redirect rule could look like this:

`/resources/redirects/aliases.php`

```php
<?php return [[
   "pattern" => "^\\Q/home\\E[/]?\$",
   "replacement" => "/",
   "alias" => true
]];
```

## Configs

Any configuration files provided by the CMS can be stored below `/resources/configs`. These are evaluated by various Atoolo bundles. For example, the [Site Manifest](id-ending-urls.md#site-manifest) is stored under `/resources/configs/manifest.php` (see the [Manifest](#manifest) section above).

Possible configuration directories can be:

| Directory                    | Description                                              |
| ---------------------------- | -------------------------------------------------------- |
| `indexer`                    | Configurations for various indexers for full-text search |
| `email`                      | Email templates and themes                               |
| `microsite/{microsite-name}` | Configurations for specific microsites                   |
