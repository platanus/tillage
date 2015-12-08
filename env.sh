#!/bin/bash

set +e
set +u

# Make the root of Boxen available.

export TILLAGE_HOME=

# Add any binaries specific to tillage to the path.
for env_file in $TILLAGE_HOME/env.d/*.sh ; do
  if [ -f "$env_file" ] ; then
    #shellcheck disable=1090
    . "$env_file"
  fi
done

# Tillage is active.
if [ -d "$TILLAGE_HOME/repo/.git" ]; then
  export TILLAGE_SETUP_VERSION=`GIT_DIR=$TILLAGE_HOME/repo/.git git rev-parse --short HEAD`
else
  echo "Tillage could not load properly!"
fi
