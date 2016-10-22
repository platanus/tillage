#!/usr/bin/env bash

load ../node_modules/bats-support/load
load ../node_modules/bats-assert/load

if [ -z "$TILLLAGE_TEST_DIR" ]; then
  TILLLAGE_TEST_DIR="${BATS_TMPDIR}/tillage"
  export TILLLAGE_TEST_DIR="$(mktemp -d "${TILLLAGE_TEST_DIR}.XXX" 2>/dev/null || echo "$TILLLAGE_TEST_DIR")"
  export TILLLAGE_ROOT="${TILLLAGE_TEST_DIR}/root"
  export HOME="${TILLLAGE_TEST_DIR}/home"

  PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
  PATH="${BATS_TEST_DIRNAME}/../libexec:$PATH"
  PATH="${TILLLAGE_TEST_DIR}/bin:$PATH"
  export PATH

  for xdg_var in `env 2>/dev/null | grep ^XDG_ | cut -d= -f1`; do unset "$xdg_var"; done
  unset xdg_var
fi

teardown() {
  rm -rf "$TILLLAGE_TEST_DIR"
}
