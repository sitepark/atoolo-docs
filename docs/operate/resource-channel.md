# Resource channel

The resource channel is the area in which the IES (Sitepark's content management system) publishes resources. A channel is a directory that is always assigned to a specific virtual host.

Directory layout For example, for the `www` area:

```
/var/www/example.com/www/
├── app/
│   └── bin/
│   │   └── console
│   ├── public/
│   │   └── index.php
│   └── ...
├── frontend/
│   └── public/
├── resources/
├── objects/
├── media/
│   ├── public/
│   └── protected/
├── security/
├── redirects/
├── configs/
└── context.php
```
