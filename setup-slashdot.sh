#!/bin/sh
# Install a terminal Slashdot reader. Run as your normal user.
set -eu

if [ "$(id -u)" -eq 0 ]; then
    echo 'Run this script as your normal user; it uses sudo for packages.' >&2
    exit 1
fi

install_packages() {
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y newsboat lynx
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y newsboat lynx
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed newsboat lynx
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper install -y newsboat lynx
    elif command -v apk >/dev/null 2>&1; then
        sudo apk add newsboat lynx
    else
        echo 'Install newsboat and lynx with your package manager, then rerun.' >&2
        exit 1
    fi
}

if ! command -v newsboat >/dev/null 2>&1 || ! command -v lynx >/dev/null 2>&1; then
    install_packages
fi

# Respect Newsboat's legacy-directory precedence and XDG configuration.
if [ -d "$HOME/.newsboat" ]; then
    config_dir="$HOME/.newsboat"
else
    config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/newsboat"
fi
mkdir -p "$config_dir" "$HOME/.local/bin"
touch "$config_dir/urls" "$config_dir/config"

feed='https://rss.slashdot.org/Slashdot/slashdotMain'
if ! grep -Eq '^[[:space:]]*https?://rss\.slashdot\.org/Slashdot/slashdotMain([[:space:]]|$)' "$config_dir/urls"; then
    printf '\n%s "~Slashdot"\n' "$feed" >> "$config_dir/urls"
fi

# Add defaults only where the user has not already configured an option.
for setting in 'auto-reload yes' 'reload-time 30' 'browser "lynx %u"'; do
    key=${setting%% *}
    if ! grep -Eq "^[[:space:]]*$key[[:space:]]" "$config_dir/config"; then
        printf '\n%s\n' "$setting" >> "$config_dir/config"
    fi
done

launcher="$HOME/.local/bin/slashdot"
if [ ! -e "$launcher" ] && [ ! -L "$launcher" ]; then
    cat > "$launcher" <<'LAUNCHER'
#!/bin/sh
if ! command -v newsboat >/dev/null 2>&1; then
    printf '%s\n' 'Install newsboat and lynx with your package manager first.' >&2
    exit 1
fi
exec newsboat -r "$@"
LAUNCHER
    chmod +x "$launcher"
else
    printf 'Preserved existing launcher: %s\n' "$launcher"
fi

printf '\nConfigured Slashdot in %s\n' "$config_dir"
printf 'Start reading with: %s\n' "$launcher"
case ":$PATH:" in
    *":$HOME/.local/bin:"*) echo 'You can also run: slashdot' ;;
    *) echo 'To enable the short command, add this to your shell profile:'
       echo 'export PATH="$HOME/.local/bin:$PATH"' ;;
esac
echo 'Keys: Enter = open, r = refresh, o = open in browser, q = back/quit.'
