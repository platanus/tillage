#!/bin/sh

####################
# node module script
####################

# Load node module environment
# shellcheck disable=1090
. "$_TILLAGE_ENV_D/$MODULE_ENV_PRIORITY-$MODULE_NAME.sh"

# Install the latest node version
node_version="$(curl -sSL http://node.platan.us/latest)"
node_version_alias="$(echo $node_version | cut -d "." -f -2)"
if ! nodenv versions --bare | grep -Fq "$node_version"; then
  nodenv install -s "$node_version"
  nodenv global "$node_version_alias"
fi

export NODENV_VERSION=$node_version_alias

# Install or update base packages
tillage npm 'npm'
tillage npm 'yo'
tillage npm 'generator-platanus-ionic'
