# Worker

Workers are required to process asynchronous tasks. These must be set up and configured in the system.

The workers are set up with the help of Supervisor. Supervisor is a process control system that enables processes to be monitored and restarted if necessary.

```sh
sudo apt-get install supervisor
```

The workers are configured in a configuration file that is stored in `/etc/supervisor/conf.d/`. For `www`, the configuration could look like this:

`/etc/supervisor/conf.d/www-worker.conf`

```ini
[program:www-worker]
command=/var/www/example.com/www/app/bin/console messenger:consume --all
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/path/to/log/dir/www-worker.out.log
autostart=true
autorestart=true
process_name=%(program_name)s_%(process_num)02d
```

See [`supervisorctl`](http://supervisord.org/running.html#running-supervisorctl){:target="\_blank"} for more information on how to manage Supervisor.
