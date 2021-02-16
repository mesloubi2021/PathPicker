#!/bin/bash
# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

set -e

# get the directory of this script so we can execute the related python
# http://stackoverflow.com/a/246128/212110
SOURCE=$0
# resolve $SOURCE until the file is no longer a symlink
while [ -h "$SOURCE" ]; do
  BASEDIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it relative to
  # the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$BASEDIR/$SOURCE"
done
BASEDIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
REPO_ROOT="$BASEDIR/.."

poetry install
poetry run isort "$REPO_ROOT/src" --check-only
poetry run black "$REPO_ROOT/src" --check
poetry run pytest "$REPO_ROOT/src/tests"
