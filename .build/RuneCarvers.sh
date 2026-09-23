#!/bin/sh
printf '\033c\033]0;%s\a' RuneCarvers
base_path="$(dirname "$(realpath "$0")")"
"$base_path/RuneCarvers.x86_64" "$@"
