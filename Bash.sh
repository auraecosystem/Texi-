#!/usr/bin/env bash
set -euo pipefail

# Build the manual and run the repository's local checks.
make all
make pdf
make test
