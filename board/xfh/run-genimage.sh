#!/bin/sh
set -eu
BIN="$1"; HOST="$2"; CFG="$3"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/root" "$TMP/tmp"
"${HOST}/bin/genimage" \
 --rootpath="${TMP}/root" \
 --tmppath="${TMP}/tmp" \
 --inputpath="${BIN}" \
 --outputpath="${BIN}" \
 --config="${CFG}"
