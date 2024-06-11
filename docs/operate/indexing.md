# Indexing

Atoolo offers console tools via which the full text index can be created and updated.

The following command is used to create a completely new index:

```sh
/var/www/example.com/www/app/bin/console search:indexer
```

There may be several sources in a project that are used to fill the index. If this is the case, you are asked for which source the data should be re-indexed.
