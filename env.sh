#!/bin/bash

set +e
set +u

# Make the root of Boxen available.

export TILLAGE_HOME=/Volumes/SharedFolders/src/tillage

# Add any binaries specific to tillage to the path.
PATH=$TILLAGE_HOME/bin:$PATH

for f in $TILLAGE_HOME/modules/**/env.sh ; do
  if [ -f "$f" ] ; then
    #shellcheck disable=1090
    . "$f"
  fi
done

# # Boxen is active.
#
# if [ -d "$TILLAGE_HOME/repo/.git" ]; then
#   export BOXEN_SETUP_VERSION=`GIT_DIR=$TILLAGE_HOME/repo/.git git rev-parse --short HEAD`
# else
#   echo "Boxen could not load properly!"
# fi
