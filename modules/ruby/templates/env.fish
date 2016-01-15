# Allow bundler to use all the cores for parallel installation
set -gx BUNDLE_JOBS 4

# Configure RBENV_ROOT and put RBENV_ROOT/bin on PATH
set -gx RBENV_ROOT /usr/local/opt/rbenv
set -gx PATH \$RBENV_ROOT/bin \$PATH

# Load rbenv
source (rbenv init - | psub)
