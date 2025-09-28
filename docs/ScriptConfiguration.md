# SwitchMoveCaptures PowerShell Script Configuration Guide

This guide explains how to configure the settings in the `SwitchMoveCaptures.ps1` script. Each configuration option is documented below with a description and example.

---

## GUI Configuration (Recommended)

Most users should use the GUI (`SwitchMoveCapturesGUI.ps1`) to configure all options, manage devices, and set up notifications. The GUI writes settings directly to the script and device config file, and is the easiest way to keep your setup up-to-date.

---

## Configuration Outline
- [Discord Webhook](DiscordWebhook.md)
- [Slack Webhook](SlackWebhook.md)
- [Microsoft Teams Webhook](TeamsWebhook.md)
- [SMS via Email-to-SMS Gateway](SmsGateway.md)
---



- [Base Destination Folder (`$baseDestination`)](#base-destination-folder-basedestination)
- [Log Folder (`$logFolder`)](#log-folder-logfolder)
- [Delete After Copy (`$deleteAfterCopy`)](#delete-after-copy-deleteaftercopy)
- [Max Log Files (`$maxLogFiles`)](#max-log-files-maxlogfiles)
- [Organize by Game (`$organizeByGame`)](#organize-by-game-organizebygame)
- [Device Selection (`$allowAllSwitchDevices`, `$allowedSwitchDevices`)](#device-management-allowedswitchdevices)
- [Google Chat Webhook (`$enableGoogleChatNotification`, `$googleChatWebhookUrl`)](#google-chat-webhook-enablegooglechatnotification-googlechatwebhookurl)
- [Email Notification Settings (`$enableEmailNotification`, `$smtpServer`, `$smtpPort`, `$smtpUser`, `$smtpPassword`, `$emailFrom`, `$emailTo`, `$emailSubject`)](#email-notification-settings-enableemailnotification-smtpserver-smtpport-smtpuser-smtppassword-emailfrom-emailto-emailsubject)

---

## Base Destination Folder (`$baseDestination`)
**Description:**
The root folder where captures from your Switch will be saved. Each device will have its own subfolder.

**Example:**
```powershell
$baseDestination = "C:\Users\YourName\Pictures\SwitchCaptures"
```

---

## Log Folder (`$logFolder`)
**Description:**
The folder where log files will be stored.

**Example:**
```powershell
$logFolder = "C:\Users\YourName\Pictures\SwitchImportLogs"
```

---

## Delete After Copy (`$deleteAfterCopy`)
**Description:**
If set to `$true`, files will be deleted from the Switch after being copied to your PC. If `$false`, files will remain on the Switch.

**Example:**
```powershell
$deleteAfterCopy = $true
```

---

## Max Log Files (`$maxLogFiles`)
**Description:**
The maximum number of log files to keep in the log folder. Older logs will be deleted automatically.

**Example:**
```powershell
$maxLogFiles = 30
```

---

## Organize by Game (`$organizeByGame`)
**Description:**
If set to `$true`, files will be organized into subfolders by game title (based on the folder structure on the Switch). If `$false`, all files will be saved in the device folder only.

**Example:**
```powershell
$organizeByGame = $true
```

---

---


<div id="device-management-allowedswitchdevices"></div>
## Device Management (AllowedSwitchDevices.yaml)
**Description:**
Device management is handled via the `AllowedSwitchDevices.yaml` file. The recommended way to manage devices is through the GUI, which allows you to add, label, and remove devices visually. When a Nintendo device is detected, the script attempts to identify it by its SD card serial number. If the device is new, the user is prompted to provide a label (required, can include spaces and special characters) and to confirm whether to import files from the device. The label and serial are then stored in `AllowedSwitchDevices.yaml` for future use.

**How it works:**
- When a new device is detected, you must enter a non-empty label if you choose to import files.
- The label is used as the folder name for storing captures from that device.
- All managed devices are listed under the `Devices` section in `AllowedSwitchDevices.yaml`.
- The GUI provides a tab for device management.

**Example AllowedSwitchDevices.yaml:**
```yaml
# SwitchMoveCaptures External Configuration
# This file is used to store device-specific settings, including SD card serial numbers and user-set labels.
Devices:
  - Serial: "1234567890ABCDEF"
    Label: "Steve's Main Switch"
  - Serial: "0987654321FEDCBA"
    Label: "Kids' Switch"
```

**Note:**
- There is no longer an option to allow all Switch devices or to specify allowed device names in the script. All device management is handled interactively and stored in the `AllowedSwitchDevices.yaml` file, and is best managed via the GUI.


## Google Chat Webhook (`$enableGoogleChatNotification`, `$googleChatWebhookUrl`)
**Description:**
- `$enableGoogleChatNotification`: If `$true`, notifications will be sent to Google Chat using the webhook URL.
- `$googleChatWebhookUrl`: The webhook URL for your Google Chat space.

**Example:**
```powershell
$enableGoogleChatNotification = $true
$googleChatWebhookUrl = "https://chat.googleapis.com/v1/spaces/AAA.../messages?key=..."
```

**Tip:** You can now configure Google Chat notifications directly from the GUI.

---

## Email Notification Settings (`$enableEmailNotification`, `$smtpServer`, `$smtpPort`, `$smtpUser`, `$smtpPassword`, `$emailFrom`, `$emailTo`, `$emailSubject`)
**Description:**
- `$enableEmailNotification`: If `$true`, notifications will be sent by email.
- `$smtpServer`: The SMTP server address.
- `$smtpPort`: The SMTP server port (usually 587 for TLS).
- `$smtpUser`: The username for SMTP authentication.
- `$smtpPassword`: The password for SMTP authentication.
- `$emailFrom`: The sender's email address.
- `$emailTo`: The recipient's email address.
- `$emailSubject`: The subject line for notification emails.

**Example:**
```powershell
$enableEmailNotification = $true
$smtpServer   = "smtp.example.com"
$smtpPort     = 587
$smtpUser     = "your@email.com"
$smtpPassword = "your_password"
$emailFrom    = "your@email.com"
$emailTo      = "recipient@email.com"
$emailSubject = "Nintendo Switch Import Notification"
```

**Tip:** You can now configure all email and SMS notification settings directly from the GUI.

---


---

*These instructions are current as of July 4, 2025. The GUI is the recommended way to configure all options for most users.*

---

## Additional Feature: Deduplication by File Hash

**Description:**
The script automatically checks for duplicate files using SHA256 hashes. If a file with the same content already exists in the destination (even if the filename is different), it will be skipped and not copied again. This helps prevent duplicate screenshots and videos from being imported.

**How it works:**
- Before copying, the script computes a hash for each file in the destination and compares it to the hash of each new file.
- If a match is found, the file is skipped and a log entry is made.

No configuration is needed for this feature; it is always enabled.
