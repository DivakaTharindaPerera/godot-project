#!/bin/sh
echo -ne '\033c\033]0;20001292\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/20001292.x86_64" "$@"
