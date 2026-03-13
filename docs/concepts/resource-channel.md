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

If pages are accessed via a URL, the correct resource can be loaded with the help of [ID-ending URLs](id-ending-urls.md).

However, there are special cases where no URL with ID is available and therefore no ID can be determined. This is the case with the homepage, for example. This should be accessible via a URL such as `https://www.example.com`.

Another case is the error page. If the content for the 404 error page is to be loaded when a page called up does not exist, it must also be possible to load the data provided by the CMS for the error page.

A manifest file is available for these cases, which is located in the directory `/resources/configs/manifest.php`. The IDs of the resources are stored in this file for special cases. For example, the manifest file could contain the following entries:

```php
<?php return [
   "home" => 1118,
   "errors" => [
      "401" => 1140,
      "404" => 1138,
      "403" => 1139,
      "500" => 1136,
      "410" => 1137
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

The publicly accessible media are delivered directly from the web server without the need for routing via PHP. The protected media are delivered via a PHP endpoint that checks the access rights before the file is delivered.

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

## Embedded media from media

There is a special case when embedded media exist that are not subordinate to an article but to a medium. This can be the case, for example, if you want to store a preview image for a PDF in the CMS. In this case, the suffix of the medium is also part of the URL path.

```
/var/www/example.com/www/
└── resources/
    ├── media/
    │   └── public/
    │       └── dir/
    │           └── 1233
    │               └── filename.pdf
    │                   └── 123-432
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

Any configuration files provided by the CMS can be stored below `/resources/configs`. These are evaluated by various Atoolo bundles. For example, the manifest file, which is stored under `/resources/configs/manifest.php`, contains information about the IDs of the resources for special cases such as the homepage and the error pages.

Possible configuration directories can be:

| Directory                    | Description                                              |
| ---------------------------- | -------------------------------------------------------- |
| `indexer`                    | Configurations for various indexers for full-text search |
| `email`                      | Email templates and themes                               |
| `microsite/{microsite-name}` | Configurations for specific microsites                   |
