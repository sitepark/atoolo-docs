# Worker

Workers are required to process asynchronous tasks. These must be set up and configured in the system.

The workers are set up with the help of Supervisor. Supervisor is a process control system that enables processes to be monitored and restarted if necessary.

```sh
sudo apt-get install supervisor
```

**Every channel needs a worker of its own.** A worker handles the messages of
one channel only - the changes the CMS reports for `www` are handled by the
worker of `www`. It knows its channel from the path `bin/console` is called by:
`/var/www/example.com/www/app/bin/console` is the channel `www` of the host
`example.com`, `/var/www/example.com/preview/app/bin/console` the channel
`preview`. Alternatively the channel can be set with the environment variable
`RESOURCE_ROOT`.

The workers are configured in a configuration file that is stored in `/etc/supervisor/conf.d/`. For `www` and `preview`, the configuration could look like this:

`/etc/supervisor/conf.d/example.com-worker.conf`

```ini
[program:example.com-www-worker]
command=/var/www/example.com/www/app/bin/console messenger:consume --all
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/path/to/log/dir/example.com-www-worker.out.log
autostart=true
autorestart=true
process_name=%(program_name)s_%(process_num)02d

[program:example.com-preview-worker]
command=/var/www/example.com/preview/app/bin/console messenger:consume --all
user=www-data
numprocs=1
redirect_stderr=true
stdout_logfile=/path/to/log/dir/example.com-preview-worker.out.log
autostart=true
autorestart=true
process_name=%(program_name)s_%(process_num)02d
```

The worker also handles the changes the CMS reports - see
[Indexing](indexing.md). `messenger:consume --all` covers them; without a
running worker, published articles do not reach the search index.

See [`supervisorctl`](http://supervisord.org/running.html#running-supervisorctl){:target="\_blank"} for more information on how to manage Supervisor.
