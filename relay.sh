#!/usr/bin/env sh
# Arcel Relay — private, end-to-end encrypted messaging for high-trust networks.
#
#   curl -fsSL https://get.arcel.org/relay.sh | sh
#   curl -fsSL https://get.arcel.org/relay.sh | sh -s -- --url https://relay.example.com --yes
#
# Relay's official quickstart (in the Arcel-Org/Relay repo) does the real work:
# it fetches the compose files, generates a production .env with random secrets
# (SESSION_SECRET, TOTP_ENCRYPTION_KEY via openssl), creates the shared
# proxy-net network, pulls the prebuilt GHCR image, and starts the stack. This
# script is just the short, easy-to-remember entry point.
set -eu

QUICKSTART_URL="https://raw.githubusercontent.com/Arcel-Org/Relay/master/scripts/quickstart.sh"

echo ">> Arcel Relay installer"
echo "   Fetching Relay's official quickstart..."
echo

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

if ! curl -fsSL -o "$TMP" "$QUICKSTART_URL"; then
  echo "ERROR: could not fetch Relay's quickstart from $QUICKSTART_URL" >&2
  exit 1
fi

if [ ! -s "$TMP" ]; then
  echo "ERROR: downloaded quickstart is empty (got a 200 but no bytes?)." >&2
  exit 1
fi

exec bash "$TMP" "$@"
