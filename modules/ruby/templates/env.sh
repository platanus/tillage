#!/bin/sh

# Allow bundler to use all the cores for parallel installation
export BUNDLE_JOBS=4

# Configure RBENV_ROOT and put RBENV_ROOT/bin on PATH
export RBENV_ROOT=/usr/local/opt/rbenv
export PATH=\$RBENV_ROOT/bin:\$PATH

# Load rbenv
eval "\$(rbenv init -)"
