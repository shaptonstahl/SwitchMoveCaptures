# SwitchMoveCaptures

Automatically move screen captures and videos from your Nintendo Switch to your Windows PC.

## Overview

**SwitchMoveCaptures** is an open-source tool designed to help Nintendo Switch users easily transfer their screenshots and video clips to a Windows PC. Created by Stephen Haptonstahl for his sons—huge Switch fans—this project aims to simplify the process of organizing and backing up your favorite gaming moments.

## Features

- Automatically detects and moves new captures from your Switch
- Supports both screenshots and video clips
- Organizes files by date or game (customizable)
- Easy to use PowerShell script for Windows

## Getting Started

1. Clone this repository:
    ```powershell
    git clone https://github.com/yourusername/SwitchMoveCaptures.git
    ```
2. Connect your Nintendo Switch microSD card to your PC.
   
   You can do this by either:
   - Removing the microSD card from your Switch and inserting it into your PC, **or**
   - Connecting your Nintendo Switch directly to your PC using a USB cable and enabling data transfer mode on the Switch. See [docs/ConnectSwitchViaUSB.md](docs/ConnectSwitchViaUSB.md) for step-by-step instructions.


3. **Recommended:** Run the GUI frontend for configuration and manual import:
    ```powershell
    cd SwitchMoveCaptures\scripts
    .\SwitchMoveCapturesGUI.ps1
    ```
   The GUI allows you to:
   - Configure all script options (destination, log folder, file types, notifications, etc.)
   - Manage allowed Switch devices and their labels
   - Set up and test notifications for Google Chat, Discord, Slack, Teams, Email, and SMS
   - Run imports manually and view logs

4. (Optional) To automate imports, set up Windows Task Scheduler to run `SwitchMoveCaptures.ps1` on USB connect. See [docs/AutoRunOnUSB.md](docs/AutoRunOnUSB.md).

5. (Optional) To enable notifications, you can also follow the instructions in the docs folder for your preferred channel, but the GUI is the recommended way to configure notifications:
   - [Google Chat](docs/GoogleChatWebhook.md)
   - [Discord](docs/DiscordWebhook.md)
   - [Slack](docs/SlackWebhook.md)
   - [Microsoft Teams](docs/TeamsWebhook.md)
   - [SMS via Email-to-SMS Gateway](docs/SmsGateway.md)

   After setting up your webhook or SMS gateway, you can use the GUI to update your configuration, or edit the script directly as described in [docs/ScriptConfiguration.md](docs/ScriptConfiguration.md).


## Requirements

- Windows 10 (Version 1809 or later) or Windows 11
  - Most features require Windows 10 October 2018 Update (1809) or newer. Windows 11 is fully supported.
  - If you are running an older version, update Windows via **Settings > Update & Security > Windows Update**.
- PowerShell 5.1 or later
  - PowerShell 5.1 is included with Windows 10 and 11 by default.
  - For best compatibility and YAML support, install **PowerShell 7+** (also called "PowerShell Core").
    - Download from: https://github.com/PowerShell/PowerShell/releases
    - Or install via Microsoft Store (search for "PowerShell 7").
- For YAML device management (advanced device config editing):
  - PowerShell 7+ includes built-in YAML support (`ConvertFrom-Yaml` and `ConvertTo-Yaml`).
  - If you use PowerShell 5.1, install the **Import-Yaml** module:
    ```powershell
    Install-Module -Name powershell-yaml -Scope CurrentUser
    ```
  - Most users do not need to edit YAML manually; the GUI handles device management automatically.


## Documentation Languages

[English](docs/en/README.md) | [Español](docs/es/README.md) | [Français](docs/fr/README.md) | [Deutsch](docs/de/README.md) | [日本語](docs/ja/README.md) | [简体中文](docs/zh/README.md)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Created by Stephen Haptonstahl for his sons.

---

## Reliability Note

This project was written with a "vibe coding" approach. Each release has been lightly tested with a real Nintendo Switch and Windows PC setup, but not subjected to rigorous or automated testing. Anyone using this script should perform their own basic testing before relying on it for important files. You may also wish to have a different AI or developer review the code for safety and reliability.

---

## GUI vs. Script

**The GUI (`SwitchMoveCapturesGUI.ps1`) is the recommended way to configure and use this project for most users.**
All configuration, device management, and notification setup can be done visually. Advanced users can still edit `SwitchMoveCaptures.ps1` and `AllowedSwitchDevices.yaml` directly if needed.