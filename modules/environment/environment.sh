#!/bin/sh

####################
# environment module script
####################

TILLAGE_ENV_PATH=$TILLAGE_HOME/env.d

echo "--> Final touches ..."
if [ ! -d $TILLAGE_ENV_PATH ]; then
  sudo mkdir -p "$TILLAGE_ENV_PATH"
  sudo chown -R "$USER:staff" "$TILLAGE_ENV_PATH"
fi
