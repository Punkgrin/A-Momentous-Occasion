#!/bin/sh
echo -ne '\033c\033]0;A Momentous Occasion\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/A-M-O.x86_64" "$@"
