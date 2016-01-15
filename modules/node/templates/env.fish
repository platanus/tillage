# Configure NODENV_ROOT and put NODENV_ROOT/bin on PATH
set -gx NODENV_ROOT /usr/local/opt/nodenv
set -gx PATH \$NODENV_ROOT/bin \$PATH

# Load nodenv
source (nodenv init - | psub)
