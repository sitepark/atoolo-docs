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
