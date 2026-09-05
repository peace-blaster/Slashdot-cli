# Slashdot CLI

Read Slashdot in your terminal using Newsboat, with Lynx for opening story pages.
The `slashdot` command opens your Newsboat feed list, including other subscriptions.

## Install with curl

Download the shell installer and run it as your normal user. No Git client,
repository clone, or GitHub account is needed. The scripts can be hosted on any
web server that serves their raw contents.

**Replace `https://YOUR-HOST/slashdot-cli` below with the actual script hosting
URL. These placeholders are not live download links.**

```sh
curl -fSL https://YOUR-HOST/slashdot-cli/setup-slashdot.sh -o setup-slashdot.sh &&
sh setup-slashdot.sh
```

Requires Linux, `curl`, and a POSIX shell. If Newsboat and Lynx are already
installed, setup does not use a package manager. Otherwise, it installs them
using `sudo` and `dnf`, `apt-get`, `pacman`, `zypper`, or `apk`; you may be
prompted for your password. This script does not provide a package-manager-free
installation of those dependencies. On other distributions, make both commands
available before running setup.

Setup adds the Slashdot RSS feed and missing defaults for automatic refresh
every 30 minutes and the Lynx browser. Existing feeds, configured options, and
launchers are preserved. Configuration goes in `~/.newsboat` if that directory
exists, otherwise `${XDG_CONFIG_HOME:-$HOME/.config}/newsboat`.

## Use

```sh
~/.local/bin/slashdot
```

To use the shorter `slashdot` command, add this to your shell profile:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

- `Enter`: open a feed or story.
- `r`: refresh the selected feed.
- `o`: open the selected story in your configured browser.
- `q`: go back or quit.
- `?`: show help.

Newsboat shows the content supplied by the feed. Open stories in Lynx to read
their pages and follow links.

## Uninstall with curl

Replace the hosting URL below, then run as the same user who installed it:

```sh
curl -fSL https://YOUR-HOST/slashdot-cli/uninstall-slashdot.sh -o uninstall-slashdot.sh &&
sh uninstall-slashdot.sh
```

The uninstaller removes the unchanged installer-created launcher and marked
feed/settings entries from both Newsboat configuration locations. It preserves
customized launchers and settings, other feeds, cached articles, and the
Newsboat and Lynx packages. It is safe to run again.

Older installations have no ownership markers, so their feed and settings are
left in place. To remove those manually, edit Newsboat's `urls` and `config`
files and remove only the Slashdot feed and defaults you no longer want.
If you added a PATH entry to your shell profile, remove it only if you no longer
use `~/.local/bin` for other commands.

If you already have the scripts locally, run `sh setup-slashdot.sh` or
`sh uninstall-slashdot.sh` directly.
