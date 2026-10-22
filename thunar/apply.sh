#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
gtk_dir="$config_dir/gtk-3.0"
gtk_css="$gtk_dir/gtk.css"
gtk_import='@import url("noctalia-thunar.css");'

mkdir -p "$gtk_dir"

if [[ -e "$gtk_css" || -L "$gtk_css" ]]; then
    if [[ ! -f "$gtk_css" ]]; then
        printf 'Thunar theme: expected a GTK stylesheet at %s\n' "$gtk_css" >&2
        exit 1
    fi

    if grep -Fq -- "$gtk_import" "$gtk_css"; then
        exit 0
    fi

    temporary_file="$(mktemp "$gtk_dir/.gtk.css.tmp.XXXXXX")"
    trap 'rm -f "$temporary_file"' EXIT
    printf '%s\n' "$gtk_import" >"$temporary_file"
    cat "$gtk_css" >>"$temporary_file"

    if [[ -L "$gtk_css" ]]; then
        chmod 644 "$temporary_file"
    else
        chmod --reference="$gtk_css" "$temporary_file"
    fi

    mv -f "$temporary_file" "$gtk_css"
    trap - EXIT
else
    printf '%s\n' "$gtk_import" >"$gtk_css"
fi
