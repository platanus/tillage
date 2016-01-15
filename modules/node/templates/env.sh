#!/bin/sh

# Configure NODENV_ROOT and put NODENV_ROOT/bin on PATH
export NODENV_ROOT=/usr/local/opt/nodenv
export PATH=\$NODENV_ROOT/bin:\$PATH

# Load nodenv
eval "\$(nodenv init -)"
