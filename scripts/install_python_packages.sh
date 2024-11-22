#!/bin/bash
set -e

PYTHON_PACKAGES="$1"
EXTRA_INDEX_URL="$2"
TRUSTED_HOST="$3"

echo "current directory: $(pwd)"
echo "scripts directory: $(dirname "$0")"
LAMBDA_LAYER_DIR="$(dirname "$(dirname "$0")")"
echo "lambda layer module directory: ${LAMBDA_LAYER_DIR}"

echo "Changing directory to the lambda layer directory: ${LAMBDA_LAYER_DIR}"
pushd ${LAMBDA_LAYER_DIR}

echo "creating output/python directory"
mkdir -p output/python

PIP_COMMAND="pip install -t ./output/python ${PYTHON_PACKAGES}"
if [[ -n "$EXTRA_INDEX_URL" ]] && [[ -n "$TRUSTED_HOST" ]]; then
  PIP_COMMAND="${PIP_COMMAND} --extra-index-url ${EXTRA_INDEX_URL} --trusted-host ${TRUSTED_HOST}"
fi

echo "pip installing packages"
eval $PIP_COMMAND

echo "pip install finished"

echo "freeze requirements"
pip freeze --path ./output/python > requirements.txt
