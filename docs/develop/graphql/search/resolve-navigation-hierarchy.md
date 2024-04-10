# Resolve navigation hierarchy

Articles can be linked to each other via a hierarchy of any depth. Navigation is a specific type of hierarchy. The navigation field provides a [`Hierarchy`](../reference.md#hierarchy) object that can be used to navigate through the levels.

The methods of [`Hierarchy`](../reference.md#hierarchy) always return a [`Resource`](../reference.md#resource) object or a list of [`Resource`](../reference.md#resource) objects which can then be used to navigate further in the hierarchy.

## Get the root

The `root` field is used to obtain the root of the navigation.

```graphql
{
  search(input: { filter: [{ groups: ["1195"] }] }) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        root {
          id
        }
      }
    }
  }
}
```

## Get the parent

The `parent` field is used to determine the parent resource in the navigation hierarchy.

The example also shows how the parents are determined over two levels.

```graphql
{
  search(input: { filter: [{ groups: ["1195"] }] }) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        parent {
          id
          navigation {
            parent {
              id
            }
          }
        }
      }
    }
  }
}
```

## Get the children

The subordinate resources in the navigation are queried via the `children` field.

```graphql
{
  search(input: { filter: [{ groups: ["1195"] }] }) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        children {
          id
        }
      }
    }
  }
}
```

## Get the path

The path describes all higher-level parents up to the root element. The returned list provides the root resource as the first resource, followed by all resources that form the navigation path. The last resource in the list is the resource that should be used to determine the path.

```graphql
{
  search(input: { filter: [{ key: "musterseiten", groups: ["1195"] }] }) {
    total
    offset
    queryTime
    results {
      id
      navigation {
        path {
          id
          location
          navigation {
            children {
              name
            }
          }
        }
      }
    }
  }
}
```
