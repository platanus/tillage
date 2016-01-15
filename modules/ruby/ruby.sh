#!/bin/sh

####################
# ruby module script
####################

# Load ruby module environment
# shellcheck disable=1090
. "$TILLAGE_HOME/env.d/$MODULE_ENV_PRIORITY-$MODULE_NAME.sh"

# Install the latest ruby version
ruby_version="$(curl -sSL http://ruby.platan.us/latest)"
if ! rbenv versions --bare | grep -Fq "$ruby_version"; then
  rbenv install -s "$ruby_version"
fi

# Install or update gems defined in the gems file
export RBENV_VERSION=$ruby_version
while IFS='' read -r line || [ -n "$line" ]; do
	gem_install_or_update "$line"
done < $MODULE_PATH/gems
