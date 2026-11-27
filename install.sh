#!/usr/bin/env bash
set -euo pipefail

missing=0
for command_name in make makeinfo; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command_name" >&2
    missing=1
  fi
done

if ! command -v texi2pdf >/dev/null 2>&1; then
  printf 'Optional PDF dependency missing: texi2pdf (install a TeX Live distribution)\n'
fi

if ! command -v python3 >/dev/null 2>&1; then
  printf 'Optional test dependency missing: python3\n'
fi

if [ "$missing" -ne 0 ]; then
  printf 'Install GNU Texinfo before building this repository.\n' >&2
  exit 1
fi

printf 'Required documentation build tools are available.\n'
