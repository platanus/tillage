#!/usr/bin/env fish

# Automatically generated by Tillage. Don't edit directly. This file
# sets up paths and basic environment for the Tillage dev environment,
# and is intended to be sourced in your shell profile.

# Make the root of Boxen available.
set -gx TILLAGE_HOME $TILLAGE_HOME

# Make the github username available
set -gx TILLAGE_GITHUB_USER $STRAP_GITHUB_USER

# Source any module specific env file
for env_file in \$TILLAGE_HOME/env.d/*.fish
  if [ -f \$env_file ]
    source \$env_file
  end
end

# Tillage is active.
if [ -d "\$TILLAGE_HOME/repo/.git" ]
  set -gx TILLAGE_SETUP_VERSION (git --git-dir \$TILLAGE_HOME/repo/.git rev-parse --short HEAD)
else
  echo "Tillage could not load properly!"
end
