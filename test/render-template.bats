#!/usr/bin/env bats

load test_helper

@test "invocation without 1 arguments prints usage" {
  run tillage-render-template
  assert_failure
  assert_line "Usage: tillage render-template <template-path>"
  assert_line "Render a file to STDOUT using the current environment"
}

@test "writes a rendered template to stdout using the enviornment" {
  export VARIABLE_1="tillage"
  export VARIABLE_2="tested with bats"

  TEMPLATE="${TILLLAGE_TEST_DIR}/template"
  cat << 'EOF' > TEMPLATE
First line
Second line with $VARIABLE_1
Third line $VARIABLE_2
EOF

  run tillage-render-template TEMPLATE
  assert_success
  assert_line --index 0 "First line"
  assert_line --index 1 "Second line with tillage"
  assert_line --index 2 "Third line tested with bats"
}
