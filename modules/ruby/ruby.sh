#!/bin/sh
set -e
[ -n "$TILLAGE_DEBUG" ] && set -x
####################
# ruby module script
####################

# Load ruby module environment
# shellcheck disable=1090
. "$_TILLAGE_ENV_D/$MODULE_ENV_PRIORITY-$MODULE_NAME.sh"

# Install the latest ruby version
ruby_version="$(curl -sSL http://ruby.platan.us/latest)"
ruby_version_alias="$(echo $ruby_version | cut -d "." -f -2)"
if ! rbenv versions --bare | grep -Fq "$ruby_version"; then
  rbenv install -s "$ruby_version"
  rbenv global "$ruby_version_alias"
fi

export RBENV_VERSION=$ruby_version_alias

# Install or update base system gems
gem update --system
tillage gem 'bundler'
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

# Install or update base gems
tillage gem 'negroku'
tillage gem 'potassium'
tillage gem 'powder'
tillage gem 'rubocop'
