https://github.com/user-attachments/assets/1b3f50fe-a4c1-4d38-9215-a1f839d7a76b

# AltHolic

<p align="center">
  <sub>LOTRO alt tracking plugin for The Lord of the Rings Online</sub>
</p>

<p align="center">
  <img alt="Lua" src="https://img.shields.io/badge/Lua-Plugin-blue" />
  <img alt="LOTRO" src="https://img.shields.io/badge/Game-LOTRO-darkgreen" />
  <img alt="Status" src="https://img.shields.io/badge/status-active-success" />
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green" />
</p>

AltHolic is a Lua plugin for The Lord of the Rings Online (LOTRO) designed to keep a centralized, fast overview of your alts across characters, servers, and shared account data.

## Overview

The plugin helps you track your account in one place, with a direct view of your alts, shared resources, progression, and personal data without constantly switching between characters.

### Highlights

- Multi-character overview
- Multi-server support
- Wallet and currency tracking
- Backpack and vault tracking
- Shared storage tracking
- Equipment monitoring
- Character statistics dashboard
- Reputation tracking
- Epic quest tracking
- Global search and filtering
- Automatic persistence of saved data

## Features

- Centralized account overview
- Inventory and backpack tracking
- Vault and shared storage tracking
- Equipment and stat summaries
- Currencies and wallet data
- Reputation tracking
- Epic quest progress tracking
- Character search and filtering
- Persistent account state across sessions

## Chat commands

| Command | Description |
| --- | --- |
| `/Alt show` | Shows the main window |
| `/Alt hide` | Hides the main window |
| `/Alt toggle` | Toggles the main window |
| `/Alt esc` | Enables or disables the Esc key |
| `/Alt options` | Opens the options window |
| `/Alt optionsbar` | Opens the options bar window |
| `/Alt icon` | Shows or hides the icon |
| `/Alt alt` | Enables or disables ALT movement for the icon |
| `/Alt delete all` | Deletes all saved entries |
| `/Alt delete NameOfCharacter` | Deletes the specified character record |

## Shortcuts

| Action | Shortcut |
| --- | --- |
| Move icon | `ALT` (when enabled) |
| Open options | `SHIFT + click` on the icon |

## Installation

1. Download the ZIP from GitHub or from LOTROInterface.
2. Extract the plugin folder.
3. Copy the `AltHolic` folder into your LOTRO plugin directory:

```text
Documents\The Lord of the Rings Online\Plugins\Homeopatix
```

4. In-game, load the plugin:

```text
/plugins load AltHolic
```

## Data and synchronization

AltHolic stores data locally in the LOTRO `PluginData` folder. The plugin automatically saves and reloads data when characters log in or out, and persists character/account state for later viewing.

Typical save location:

```text
Documents\The Lord of the Rings Online\PluginData\<Account>\<Server>\<Character>
```

## Project structure

The repository is organized around the `AltHolic/` Lua source directory, with modules for:

- core utilities
- UI and window creation
- data loading and persistence
- character and account tracking
- inventory, vault, and equipment views
- search and display helpers

## Requirements

You need the Turbine package installed.

- Official LOTROInterface download: https://www.lotrointerface.com/downloads/info1064-TurbineUtilities.html

## Compatibility

This plugin is intended for recent LOTRO client builds and is designed around the standard LOTRO plugin APIs and Turbine UI controls.

## Support

If you encounter a bug, missing data, or a usability problem, please open an issue with a clear description and, when possible, a screenshot.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Author

Homeopatix

---

<p align="center">
  <sub>AltHolic • LOTRO • Lua • Account overview plugin</sub>
</p>
