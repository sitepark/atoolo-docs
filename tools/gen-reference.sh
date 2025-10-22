#!/usr/bin/env bash

# creates a Markdown file as API documentation of the GraphQL schema
# See: https://github.com/exogen/graphql-markdown
#
# usage: gen-reference.sh <host>
#

SCHEME=https

while [ True ]; do
if [ "$1" = "--http" ]; then
    SCHEME=http
    shift 1
else
    HOST=$1
    break
fi
done

if [ "$HOST" != "" ]; then
	ENDPOINT_URL="$SCHEME://$HOST/api/graphql/"
else
	ENDPOINT_URL=http://www-atoolo-e2e-test:9090/api/graphql/
fi


SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    BIN_DIR="$(cd -P "$(dirname "$SOURCE")" > /dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$BIN_DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BIN_DIR="$(cd -P "$(dirname "$SOURCE")" > /dev/null 2>&1 && pwd)"
PROJECT_DIR=$(realpath "$BIN_DIR"/..)


WORK_DIR="$PROJECT_DIR"/tmp/graphql-markdown

if [ ! -d $WORK_DIR ]; then
    mkdir -p "${WORK_DIR}"
    cd $WORK_DIR && npm install graphql-markdown --save-dev
fi

BIN="$WORK_DIR"/node_modules/.bin/graphql-markdown

if [ ! -f $BIN ]; then
    echo $BIN not found
    exit 1;
fi



echo "$ENDPOINT_URL"

curl -s "$ENDPOINT_URL" \
  -H 'content-type: application/json' \
  --data-raw '{"query":"\n    query IntrospectionQuery {\n      __schema {\n        \n        queryType { name }\n        mutationType { name }\n        subscriptionType { name }\n        types {\n          ...FullType\n        }\n        directives {\n          name\n          description\n          \n          locations\n          args {\n            ...InputValue\n          }\n        }\n      }\n    }\n\n    fragment FullType on __Type {\n      kind\n      name\n      description\n      \n      fields(includeDeprecated: true) {\n        name\n        description\n        args {\n          ...InputValue\n        }\n        type {\n          ...TypeRef\n        }\n        isDeprecated\n        deprecationReason\n      }\n      inputFields(includeDeprecated: true) {\n        ...InputValue\n      }\n      interfaces {\n        ...TypeRef\n      }\n      enumValues(includeDeprecated: true) {\n        name\n        description\n        isDeprecated\n        deprecationReason\n      }\n      possibleTypes {\n        ...TypeRef\n      }\n    }\n\n    fragment InputValue on __InputValue {\n      name\n      description\n      type { ...TypeRef }\n      defaultValue\n      \n      \n    }\n\n    fragment TypeRef on __Type {\n      kind\n      name\n      ofType {\n        kind\n        name\n        ofType {\n          kind\n          name\n          ofType {\n            kind\n            name\n            ofType {\n              kind\n              name\n              ofType {\n                kind\n                name\n                ofType {\n                  kind\n                  name\n                  ofType {\n                    kind\n                    name\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  ","operationName":"IntrospectionQuery"}' \
  --compressed > "$WORK_DIR"/schema.json

$BIN --no-toc "$WORK_DIR"/schema.json > "$PROJECT_DIR"/docs/develop/graphql/reference.md
