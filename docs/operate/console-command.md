## Console Command

Symfony projects provide a console command with which a large number of commands can be executed. The Atoolo suite extends the commands.

In Atoolo projects there is the special situation that a project can be used for several hosts. The contents of the websites of the virtual hosts are provided by the CMS in different [resource channels](resource-channel.md). As a rule, an Atoolo command always refers to a resource channel. The command must therefore be made aware of the resource channel for which it is to be executed. As the application is linked to the resource channel, the command can also be executed in the resource channel directory.

```sh
/var/www/example.com/www/app/bin/console
```

This means that the command knows for which resource channel it is to be executed.

When working on the server, commands may be executed as `root` users. Some commands write files and in this case would also create the files so that they belong to the `root` user. This can lead to problems if the files are to be read or written by the PHP process.

If the [Atoolo-Runtime-Checks](runtime-check.md) are active, an error message is displayed here and the execution of the command is prevented.
Therefore, the `www-data` user should always be used here.

The `su` command can be used for this:

```sh
su www-data \
  -s /bin/bash \
  -c '/var/www/example.com/www/app/bin/console <command> <arguments>'
```

`-s /bin/bash` is necessary because the user `www-data` has normally entered `/usr/sbin/nologin` as shell in `/etc/passwd`.
