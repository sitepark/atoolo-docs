The generated documentation is available at the following URL.

https://sitepark.github.io/atoolo-docs/

The documentation is generated with the static site generator [MkDocs](https://www.mkdocs.org/).

# Install MkDocs

```sh
pip install mkdocs
```

See [here](https://www.mkdocs.org/user-guide/installation/) if `pip` is not available.

Install [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)

```sh
pip install mkdocs-material
```

# Update requirements

```sh
pip install --upgrade -r requirements.txt
```

# Update GraphQL API Reference

The API reference `docs/develop/graphql/reference.md` is generated automatically using a GraphQL schema. The script `tools/gen-reference.sh` is available for this purpose. This expects a URL to a GraphQL endpoint via which the schema is to be read.

```sh
./tools/gen-reference.sh https://www.domain.de/graphql
```

This creates the Markdown file `docs/develop/graphql/reference.md` from the schema.

# Building the site

```sh
mkdocs build
```

This will create a new directory named `public`` where the generated documentation will be stored.

# Write documentation

MkDocs comes with a built-in dev-server that lets you preview your documentation as you work on it.

```sh
mkdocs serve
```
