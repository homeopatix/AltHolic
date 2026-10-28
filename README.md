# AltHolic

<sub>LOTRO alt tracking plugin for The Lord of the Rings Online</sub>

![Lua](https://img.shields.io/badge/Lua-Plugin-blue)
![LOTRO](https://img.shields.io/badge/Game-LOTRO-darkgreen)
![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-MIT-green)

AltHolic is a Lua plugin for The Lord of the Rings Online (LOTRO) designed to keep a centralized, fast overview of your alts across characters, servers, and shared account data.

It focuses on tracking:
- inventories and backpacks
- vault storage and shared storage
- equipment and stat summaries
- currencies and wallet data
- reputations
- epic quest progress
- character search and filtering
- account-wide information in one place

## Features

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
| Open options | `SHIFT + click on the icon` |

## Installation

1. Download the ZIP from GitHub or from LOTROInterface.
2. Extract the plugin folder.
3. Copy the `AltHolic` folder into your LOTRO plugin directory:

   `Documents\The Lord of the Rings Online\Plugins\Homeopatix`

4. In-game, load the plugin:

   `/plugins load AltHolic`

## Data and synchronization

AltHolic stores data locally in the LOTRO PluginData folder. The plugin automatically saves and reloads data when characters log in or out, and persists character/account state for later viewing.

Typical save location:

`Documents\The Lord of the Rings Online\PluginData\<Account>\<Server>\<Character>`

## Project structure

The repository is organized around the `AltHolic/` Lua source directory, with modules for:
- core utility functions
- UI and window creation
- data loading and persistence
- character and account tracking
- inventory/vault/equipment views
- search and display helpers

## Requirements

You need the Turbine package installed.

- Official LOTROInterface download: https://www.lotrointerface.com/downloads/info1064-TurbineUtilities.html

## Compatibility

This plugin is intended for recent LOTRO client builds and is designed around the standard LOTRO plugin APIs and Turbine UI controls.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Author

Homeopatix

## Notes

This project is a gameplay utility plugin for LOTRO and is intended to improve the organization and overview of alts and account data while playing.
