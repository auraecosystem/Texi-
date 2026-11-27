#!/usr/bin/env bash
#
# This file includes tests to validate the behavior of the run-with-cleanup method

color_green="\e[32m"
color_red="\e[31m"
color_clear="\e[0m"

fail() {
    echo -e " $color_red[FAIL]$color_clear"
}

pass() {
    echo -e " $color_green[PASS]$color_clear"
}

assert_did_print() {
    input="$1"
    expected="$2"
    printf "  It should print '$expected'"
    echo "$input" | grep -q "^$expected\$" && pass || fail
}

assert_zero_exit_code() {
    printf "  It should return with exit code of zero"
    test "$1" -eq 0 && pass || fail
}

assert_non_zero_exit_code() {
    printf "  It should return with non-zero exit code"
    test "$1" -ne 0 && pass || fail
}

# success case
echo "Cleanup after success:"
try_success=`make test-success`
assert_zero_exit_code "$?"
assert_did_print "$try_success" "main"
assert_did_print "$try_success" "cleanup"

# failure case
echo "Cleanup after failure:"
try_failure=`make test-failure 2>/dev/null`
assert_non_zero_exit_code "$?"
assert_did_print "$try_failure" "main"
assert_did_print "$try_failure" "cleanup"
