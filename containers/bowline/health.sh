#!/bin/sh
set -eu
answer="$(dig +time=1 +tries=1 +short @127.0.0.1 -p 1053 health.invalid. A)"
test "$answer" = "127.0.0.1"
