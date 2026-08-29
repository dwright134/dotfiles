# dotfiles

Personal configs for a CachyOS / niri / DankMaterialShell desktop, managed with
[GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a
stow package mirroring `$HOME`.

## Packages

| Package | Provides |
|---|---|
| `DankMaterialShell` | DMS `settings.json` + the `myIP` plugin. Other plugins live in their own repos (see below). |
| `fish` | `config.fish` (mise activation etc.) |
| `ghostty` | terminal config |
| `matugen` | matugen templates + `config.toml` (user-level templates; DMS drives matugen) |
| `niri` | compositor config, DMS-managed `dms/*.kdl`, `scripts/niri-window-watcher.py`, and its user systemd unit |
| `nvim` | LazyVim config; colourscheme is the DMS-generated `dms` scheme via `AvengeMedia/base46` (see `lua/plugins/dms-theme.lua`) |
| `vicinae` | launcher config |
| `zellij` | multiplexer config |
| `Pictures` | wallpapers |
| `pi` | *present on disk but ignored* — not committed for now |

## Deploy

```sh
git clone git@github.com:dwright134/dotfiles.git ~/dotfiles
cd ~/dotfiles
git config core.hooksPath .githooks      # enable the secret-scan pre-commit hook
stow -t ~ fish ghostty niri nvim zellij matugen vicinae DankMaterialShell Pictures
systemctl --user enable --now niri-window-watcher.service
```

### Packages

`pacman.packages` (explicit native, 342) and `aur.packages` (explicit AUR, 22)
list what was installed on purpose; dependencies are left to pacman.

```sh
scripts/restore-packages -n   # dry run: show what's missing
scripts/restore-packages      # pacman -S --needed ... then paru -S --needed ...
scripts/sync-packages         # regenerate the lists from this machine, then commit
```

The CachyOS repos must already be in `/etc/pacman.conf` (kernel, `cachyos-*`
settings packages, and the v3 repos). `scripts/` is not a stow package.

### DMS plugins

`DankMaterialShell/.config/DankMaterialShell/plugins/` is gitignored (except
`myIP`). Reinstall the rest through **DMS Settings → Plugins** or by cloning
into that directory:

- https://github.com/rochacbruno/DankCalculator
- https://github.com/felri/display-manager-plugin-niri-dank-linux
- https://github.com/AvengeMedia/dms-plugins (DankKDEConnect — use the plugin manager)
- https://github.com/dwright134/dms-dankscale
- https://github.com/dwright134/dms-whisperer
- https://github.com/dwright134/mleko-wizualizator
- https://github.com/dwright134/dms-watson (`timetracker`)

## What is deliberately *not* tracked

`.gitignore` covers three classes of files; keep it that way:

1. **Generated theme output** — anything matugen/DMS rewrites on a wallpaper
   change (`zen.css`, `colors.kdl`, `*/themes/matugen.*`, ghostty `dankcolors`,
   nvim `colors/dms.lua`, GTK/Qt `dank-colors`/`matugen.conf`). The templates
   are the source of truth.
2. **App-managed state** — `fish_variables`, `plugin_settings.json` (holds
   plugin API keys), `clsettings.json`, `derfla/`, `*.bak*`, `*.backup*`.
3. **Secrets** — `gh/hosts.yml`, `sops/age/keys.txt`, kdeconnect keys,
   `pi/.pi/agent/auth.json`, etc. These never belong here even if the package
   is added later.

## Guardrails

`.githooks/pre-commit` runs [gitleaks](https://github.com/gitleaks/gitleaks)
(`.gitleaks.toml` adds email / LAN-IP / JSON-apiKey / age-key rules) over the
staged diff and blocks a short never-commit filename list. Bypass a false
positive with `git commit --no-verify`.

To see what's lying around unadopted: `git status --short | grep '^??'`.
