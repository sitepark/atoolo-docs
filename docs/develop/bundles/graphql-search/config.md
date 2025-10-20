# Config

This bundle comes with a custom config: `config/package/atoolo_graphql.yaml`. 
Usually, it will be created automatically during installation by a symfony flex recipe.

Here's an example config:

```yaml
# config/package/atoolo_graphql.yaml
atoolo_graphql:
    graphql_query_dirs:
        - '%kernel.project_dir%/src/resources/graphql/queries'
```

## Configuration reference

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| `graphql_query_dirs` | `array` | `[]` | A list of directories to scan for `.graphql` files. |
