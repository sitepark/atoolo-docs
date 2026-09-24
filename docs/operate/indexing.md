# Indexing

Atoolo offers console tools via which an index can be created and updated.

The following command is used to create a completely new index:

```sh
/var/www/example.com/www/app/bin/console index:indexer
```

There may be several sources in a project that are used to fill an index, and
there may be several targets - the Solr index of the search and a GenAI
application for example. If more than one indexer is available, you are asked
which one to use. It can also be selected directly:

```sh
/var/www/example.com/www/app/bin/console index:indexer --source internal
```

Single resource paths are updated with `index:update`, and
`index:dump-document` shows the document an indexer would write without
sending it anywhere.

Resources that are published or depublished in the CMS are updated
automatically: the IES notifies the website, and the
[worker](worker.md) brings the changes into every index within a few seconds.
Every channel needs a worker of its own. Without it the changes are collected in
`var/spool/<anchor>/` and only arrive once the worker runs again.

!!! note

    Up to `atoolo/search-bundle` 1.17 the command was called `search:indexer`.
    That name still works and is removed in 2.0.
