# Thunar

This template themes Thunar's GTK 3 interface with the active Noctalia palette. It colors the
window, sidebar, file view, selection states, location buttons, scrollbars, and menus. The CSS
only targets Thunar widgets; it does not change GTK layout, spacing, or other applications.

Thunar loads per-user GTK 3 overrides from `$XDG_CONFIG_HOME/gtk-3.0/gtk.css`. The template writes
its colors to `$XDG_CONFIG_HOME/gtk-3.0/noctalia-thunar.css`, then `apply.sh` adds an import for
that file to `gtk.css`. Restart Thunar after applying the template to see the colors.

## Hook behavior

The hook creates the GTK 3 config directory and `gtk.css` if they do not exist. It adds the import
only once and preserves existing stylesheet contents. If `gtk.css` is a symlink, such as a
Home Manager managed file, the hook replaces the symlink with a writable local copy containing
the same contents and the new import; the linked source is left untouched. To keep a managed
stylesheet, add `@import url("noctalia-thunar.css");` to its source instead. The hook recognizes
that import and then leaves `gtk.css` unchanged.

Disabling or removing the template does not remove the import or generated stylesheet. To undo it,
remove the import from `gtk.css` and delete `noctalia-thunar.css`.

## Menus and context menus

In GTK 3, menus follow two distinct paths:
- **In-window menus** (such as `Ctrl+M` menubar dropdowns, toolbar action menus, and submenus) are direct descendants of Thunar's window hierarchy and are explicitly themed by this template.
- **Right-click context menus** are spawned by GTK as separate toplevel popup surfaces (`window.popup`) that sit outside Thunar's widget tree. Targeting un-scoped `menu` or `window.popup menu` selectors would leak styling into every other GTK 3 application on the desktop, violating template isolation. Context menus therefore naturally follow the active GTK 3 theme (or Noctalia's global GTK 3 palette if enabled).

## Requirements and status

- Thunar must use GTK 3. The selectors are based on and visually verified against
  Thunar 4.20.9 (Xfce 4.20).
- No additional Thunar setup is needed. Enable the template in Noctalia's Settings → Templates.
