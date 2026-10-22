#!/usr/bin/env bash
set -euo pipefail

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}"
gtk_dir="$config_dir/gtk-3.0"
gtk_css="$gtk_dir/gtk.css"
gtk_import='@import url("noctalia-thunar.css");'
target_file="$gtk_dir/noctalia-thunar.css"

if [[ -f "$gtk_css" ]] && grep -Fq -- "$gtk_import" "$gtk_css"; then
    if [[ -L "$gtk_css" ]] && [[ ! -w "$gtk_css" ]]; then
        # Read-only managed symlink (e.g. Home Manager); leave untouched
        :
    else
        temporary_file="$(mktemp "$gtk_dir/.gtk.css.tmp.XXXXXX")"
        trap 'rm -f "$temporary_file"' EXIT

        grep -v -F -- "$gtk_import" "$gtk_css" >"$temporary_file" || true

        if [[ -L "$gtk_css" ]]; then
            chmod 644 "$temporary_file"
        else
            chmod --reference="$gtk_css" "$temporary_file" 2>/dev/null || chmod 644 "$temporary_file"
        fi

        mv -f "$temporary_file" "$gtk_css"
        trap - EXIT
    fi
fi

rm -f -- "$target_file"
