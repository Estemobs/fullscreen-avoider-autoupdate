# Fullscreen Avoider

GNOME Shell Extension that moves the top panel to the secondary monitor when the primary monitor is in fullscreen mode.

![Icon](icon.png)

## Features

- **Automatic panel relocation**: When you fullscreen an app on your primary monitor, the top panel moves to your secondary monitor
- **Configurable**: Choose whether to move hot corners and/or notifications
- **Multi-monitor support**: Works with any number of monitors
- **Auto-updated compatibility**: CI automatically adds new GNOME Shell versions to metadata

## Installation

### Option 1: From GNOME Extensions Website (Recommended)

1. Visit the [extensions.gnome.org page](https://extensions.gnome.org/extension/4362/fullscreen-avoider/)
2. Click the **Install** button
3. The extension will be installed and updated automatically via the GNOME Extensions app

### Option 2: Manual Installation from Git

```bash
# Clone the repository
git clone https://github.com/Estemobs/fullscreen-avoider-autoupdate.git
cd fullscreen-avoider

# Build and install
make install

# Restart GNOME Shell
# X11: Press Alt+F2, type 'r', press Enter
# Wayland: Log out and log back in

# Enable the extension
gnome-extensions enable fullscreen-avoider@noobsai.github.com
```

### Option 3: Development Installation (Symlink)

```bash
git clone https://github.com/Estemobs/fullscreen-avoider-autoupdate.git
cd fullscreen-avoider
make debug_install

# Restart GNOME Shell and enable via gnome-extensions-app
```

### Option 4: Manual Zip Installation

1. Download the latest release zip from [GitHub Releases](https://github.com/Estemobs/fullscreen-avoider-autoupdate/releases)
2. Extract to `~/.local/share/gnome-shell/extensions/fullscreen-avoider@noobsai.github.com/`
3. Restart GNOME Shell
4. Enable via `gnome-extensions-app` or Extensions manager

## Configuration

Open the extension preferences via:
- **Extensions app** → Fullscreen Avoider → Settings
- Or run: `gnome-extensions prefs fullscreen-avoider@noobsai.github.com`

### Settings

| Setting | Description | Default |
|---------|-------------|---------|
| **Move Hot Corners** | Move hot corners to the monitor with the panel | Enabled |
| **Move Notifications** | Move notifications to the monitor with the panel | Enabled |

## Auto-Update System

This repository includes a GitHub Actions workflow (`.github/workflows/update-shell-version.yml`) that:

1. **Runs daily** at 03:17 UTC
2. **Fetches** the latest GNOME Shell releases from GitLab API
3. **Detects** new major versions (e.g., 51, 52, etc.)
4. **Updates** `src/metadata.json` with the new version(s)
5. **Commits** and pushes changes to `master`

### How it works

The script `.github/scripts/update-shell-version.sh`:
- Queries `https://gitlab.gnome.org/api/v4/projects/GNOME%2Fgnome-shell/releases`
- Parses release tags (e.g., `51.0`, `51.rc`, `51.beta`, `51.alpha`)
- Extracts major version numbers
- Adds any missing versions to the `shell-version` array in `metadata.json`

### Manual Trigger

You can manually trigger the update check:
1. Go to the **Actions** tab on GitHub
2. Select **Update GNOME shell-version**
3. Click **Run workflow**

### Force Update Locally

```bash
# Run the update script locally
bash .github/scripts/update-shell-version.sh

# Check the updated metadata
cat src/metadata.json
```

## Compatibility

| GNOME Shell | Status |
|-------------|--------|
| 45 | ✅ Supported |
| 46 | ✅ Supported |
| 47 | ✅ Supported |
| 48 | ✅ Supported |
| 49 | ✅ Supported |
| 50 | ✅ Supported |
| 51 | ✅ Supported |
| 52+ | Auto-added by CI |

## Troubleshooting

### Extension not appearing after install
```bash
# Verify installation
ls ~/.local/share/gnome-shell/extensions/fullscreen-avoider@noobsai.github.com/

# Check for errors
journalctl -f -o cat /usr/bin/gnome-shell | grep -i fullscreen-avoider
```

### Panel doesn't move
- Ensure you have **at least 2 monitors** connected
- Check that the primary monitor is actually in fullscreen (not just maximized)
- Verify settings in `gnome-extensions prefs fullscreen-avoider@noobsai.github.com`

### Version not detected
If a new GNOME version isn't in `metadata.json`:
1. Wait for the daily CI run (03:17 UTC)
2. Or manually trigger the workflow
3. Or run the script locally: `bash .github/scripts/update-shell-version.sh`

## Development

### Building

```bash
make build    # Creates build/fullscreen-avoider@noobsai.github.com/
make zip      # Creates build/fullscreen-avoider@noobsai.github.com.zip
```

### Project Structure

```
├── src/
│   ├── extension.js          # Main extension logic
│   ├── prefs.js              # Preferences UI
│   ├── metadata.json         # Extension metadata (auto-updated)
│   └── schemas/
│       └── org.gnome.shell.extensions.fullscreen-avoider.gschema.xml
├── .github/
│   ├── workflows/
│   │   └── update-shell-version.yml    # Auto-update CI
│   └── scripts/
│       └── update-shell-version.sh     # Version detection script
├── Makefile
└── README.md
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `make debug_install`
5. Submit a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details.

## Links

- [GNOME Extensions Page](https://extensions.gnome.org/extension/4362/fullscreen-avoider/)
- [GitHub Repository](https://github.com/Estemobs/fullscreen-avoider-autoupdate)
- [Report Issues](https://github.com/Estemobs/fullscreen-avoider-autoupdate/issues)