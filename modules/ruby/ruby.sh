#!/bin/sh

####################
# ruby module script
####################

# Load ruby module environment
# shellcheck disable=1090
. "$TILLAGE_HOME/env.d/$MODULE_ENV_PRIORITY-$MODULE_NAME.sh"

# Install the latest ruby version
ruby_version="$(curl -sSL http://ruby.platan.us/latest)"
ruby_version_alias="$(echo $ruby_version | cut -d "." -f -2)"
if ! rbenv versions --bare | grep -Fq "$ruby_version"; then
  rbenv install -s "$ruby_version"
  rbenv global "$ruby_version_alias"
fi

export RBENV_VERSION=$ruby_version_alias

# Install or update base gems
gem_install_or_update 'bundler'
gem_install_or_update 'negroku'
gem_install_or_update 'potassium'
gem_install_or_update 'powder'
gem_install_or_update 'rubocop'
