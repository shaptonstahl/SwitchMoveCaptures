# ================================
# CONFIGURATION
# ================================
$baseDestination = "C:\Users\YourName\Pictures\SwitchCaptures"
$logFolder   = "C:\Users\YourName\Pictures\SwitchImportLogs"
$deleteAfterCopy = $true
$maxLogFiles = 30

# Advanced Filtering: Choose which file types to import
# Set to $true to import screenshots (PNG), $false to skip
$importScreenshots = $true
# Set to $true to import video clips (MP4), $false to skip
$importVideos = $true

# Organize by game title (if true, files will be placed in subfolders by game)
$organizeByGame = $true

# Device selection
# Devices are managed via config.yaml and user-set labels. No allow-all option.

# Google Chat Webhook
$enableGoogleChatNotification = $false
$googleChatWebhookUrl = "YOUR_GOOGLE_CHAT_WEBHOOK_URL"

# Discord Webhook
$enableDiscordNotification = $false
$discordWebhookUrl = "YOUR_DISCORD_WEBHOOK_URL"

# Slack Webhook
$enableSlackNotification = $false
$slackWebhookUrl = "YOUR_SLACK_WEBHOOK_URL"

# Microsoft Teams Webhook
$enableTeamsNotification = $false
$teamsWebhookUrl = "YOUR_TEAMS_WEBHOOK_URL"

# SMS via Email-to-SMS Gateway
$enableSmsNotification = $false
$smsTo = "1234567890@txt.att.net"  # Replace with your carrier's gateway
$smsFrom = "your@email.com"

# Email Notification Settings
$enableEmailNotification = $false
$smtpServer   = "smtp.example.com"
$smtpPort     = 587
$smtpUser     = "your@email.com"
$smtpPassword = "your_password"
$emailFrom    = "your@email.com"
$emailTo      = "recipient@email.com"
$emailSubject = "Nintendo Switch Import Notification"

# ================================
# Ensure Log Folder Exists
# ================================
if (!(Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# ================================
# Prepare Log
# ================================
$log = @()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$log += "==============================="
$log += "Nintendo Switch Import Log"
$log += "Started: $timestamp"
$log += "==============================="

try {

# ================================
# Detect Switch Mount(s)
# ================================

# Path to external config file
$externalConfigPath = Join-Path $PSScriptRoot "AllowedSwitchDevices.yaml"

# Helper: Load YAML config (requires PowerShell 7+ or Import-Yaml module)
function Import-ExternalConfig {
    param($path)
    if (!(Test-Path $path)) { return @{ Devices = @() } }
    try {
        $yaml = Get-Content $path -Raw
        if (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue) {
            return ConvertFrom-Yaml $yaml
        } else {
            Write-Warning "YAML parsing requires PowerShell 7+ or Import-Yaml module. Returning empty config."
            return @{ Devices = @() }
        }
    } catch { return @{ Devices = @() } }
}

# Helper: Save YAML config
function Export-ExternalConfig {
    param($config, $path)
    if (Get-Command ConvertTo-Yaml -ErrorAction SilentlyContinue) {
        $yaml = $config | ConvertTo-Yaml
        Set-Content -Path $path -Value $yaml
    } else {
        Write-Warning "YAML export requires PowerShell 7+ or Import-Yaml module. Config not saved."
    }
}

$externalConfig = Import-ExternalConfig $externalConfigPath

$switchDrives = Get-PSDrive | Where-Object { $_.DisplayRoot -like "*Nintendo*" }

if (-not $switchDrives -or $switchDrives.Count -eq 0) {
    $log += "No Switch device detected. Exiting."
    throw "Switch not mounted."
}

# For each detected device, check if serial is known, else prompt for label and ask to import
$filteredDrives = @()
$deviceLabels = @{}
foreach ($drive in $switchDrives) {
    # Try to get serial number (use VolumeSerialNumber as a proxy)
    $serial = $null
    try {
        $vol = Get-Volume -FileSystemLabel $drive.Name -ErrorAction SilentlyContinue
        if ($vol) { $serial = $vol.SerialNumber }
    } catch {}
    if (-not $serial) {
        # Try WMI as fallback
        try {
            $volWmi = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $drive.Root.TrimEnd('\') }
            if ($volWmi) { $serial = $volWmi.VolumeSerialNumber }
        } catch {}
    }
    if (-not $serial) { $serial = $drive.Name }

    $deviceEntry = $externalConfig.Devices | Where-Object { $_.Serial -eq $serial }
    if (-not $deviceEntry) {
        # New device: prompt user for label and ask if they want to import
        Add-Type -AssemblyName Microsoft.VisualBasic
        $msg = "A new Nintendo device was detected (serial: $serial, root: $($drive.Root)).`nDo you want to import images from this device?"
        $response = [Microsoft.VisualBasic.Interaction]::MsgBox($msg, "YesNo,Question,DefaultButton2", "Switch Import")
        if ($response -eq "Yes") {
            $label = ""
            while ([string]::IsNullOrWhiteSpace($label)) {
                $label = [Microsoft.VisualBasic.Interaction]::InputBox("Enter a label for this device (label is required, can include spaces and special characters):", "Label Device", "My Switch")
                if ([string]::IsNullOrWhiteSpace($label)) {
                    [Microsoft.VisualBasic.Interaction]::MsgBox("A label is required. Please enter a label to continue.", "OKOnly,Exclamation", "Label Required")
                }
            }
            $externalConfig.Devices += @{ Serial = $serial; Label = $label }
            Export-ExternalConfig $externalConfig $externalConfigPath
            Write-Host "Device label saved: $label ($serial)"
            $deviceLabels[$serial] = $label
            $filteredDrives += $drive
        } else {
            Write-Host "User declined import for new device $serial. Skipping."
        }
    } else {
        $deviceLabels[$serial] = $deviceEntry.Label
        $filteredDrives += $drive
    }
}

# Use only drives the user approved
$switchDrives = $filteredDrives

# If multiple, let user pick
if ($switchDrives.Count -gt 1) {
    $log += "Multiple Switch devices detected. Prompting user to select."
    $choices = $switchDrives | ForEach-Object { "Name: $($_.Name) - Root: $($_.Root)" }
    Add-Type -AssemblyName Microsoft.VisualBasic
    $choiceIndex = [Microsoft.VisualBasic.Interaction]::InputBox("Multiple Switch devices detected. Enter the number for the device to import from:`n" + ($choices | ForEach-Object {"[$($_)]"} | Out-String), "Select Switch Device", "1")
    $choiceIndex = [int]$choiceIndex - 1
    if ($choiceIndex -lt 0 -or $choiceIndex -ge $switchDrives.Count) {
        $log += "Invalid device selection. Exiting."
        throw "User canceled or invalid device selection."
    }
    $drive = $switchDrives[$choiceIndex]
} else {
    $drive = $switchDrives[0]
}

# Use label from config for destination
# Try to get serial again for selected drive
$serial = $null
try {
    $vol = Get-Volume -FileSystemLabel $drive.Name -ErrorAction SilentlyContinue
    if ($vol) { $serial = $vol.SerialNumber }
} catch {}
if (-not $serial) {
    try {
        $volWmi = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $drive.Root.TrimEnd('\') }
        if ($volWmi) { $serial = $volWmi.VolumeSerialNumber }
    } catch {}
}
if (-not $serial) { $serial = $drive.Name }
$deviceLabel = $deviceLabels[$serial]

$log += "Detected Switch at: $($drive.Root) (Label: $deviceLabel, Serial: $serial)"
$source = Join-Path $drive.Root "Nintendo\Album"
$destination = Join-Path $baseDestination $deviceLabel

    # ================================
    # Ask User for Confirmation
    # ================================
    Add-Type -AssemblyName Microsoft.VisualBasic
    $response = [Microsoft.VisualBasic.Interaction]::MsgBox(
        "Nintendo Switch detected at $($drive.Root). Do you want to transfer captures now?",
        "YesNo,Question,DefaultButton2",
        "Switch Import"
    )
    $log += "User response: $response"

    if ($response -ne "Yes") {
        $log += "User chose not to proceed. Exiting."
        throw "User canceled."
    }

    # ================================
    # Make Sure Destination Exists
    # ================================
    if (!(Test-Path $destination)) {
        New-Item -Path $destination -ItemType Directory | Out-Null
        $log += "Created destination folder: $destination"
    } else {
        $log += "Destination folder exists: $destination"
    }

    # ================================
    # Copy New Files
    # ================================
    $copiedCount = 0
    $copiedPaths = @()
    $log += "Starting copy operation..."


    # Helper: Compute file hash
    function Get-FileHashString {
        param($filePath)
        try {
            return (Get-FileHash -Path $filePath -Algorithm SHA256).Hash
        } catch {
            return $null
        }
    }

    # Build hash set of destination files for deduplication
    $existingHashes = @{}
    if (Test-Path $destination) {
        Get-ChildItem -Path $destination -Recurse -File | ForEach-Object {
            $hash = Get-FileHashString $_.FullName
            if ($hash) { $existingHashes[$hash] = $true }
        }
    }

    Get-ChildItem -Path $source -Recurse -File | ForEach-Object {
        # Advanced filtering by extension
        $ext = $_.Extension.ToLower()
        if ((-not $importScreenshots -and $ext -eq ".png") -or (-not $importVideos -and $ext -eq ".mp4")) {
            $log += "Skipped (filtered by type): $($_.Name)"
            return
        }

        $gameFolder = $null
        if ($organizeByGame) {
            # Try to extract game name from parent folder (Switch stores as .../Album/<Game Title>/file)
            $parent = Split-Path $_.DirectoryName -Leaf
            if ($parent -and $parent -ne "Album") {
                $gameFolder = $parent
            } else {
                $gameFolder = "UnknownGame"
            }
        }
        $finalDest = $destination
        if ($organizeByGame -and $gameFolder) {
            $finalDest = Join-Path $destination $gameFolder
            if (!(Test-Path $finalDest)) { New-Item -Path $finalDest -ItemType Directory | Out-Null }
        }
        $destFile = Join-Path $finalDest $_.Name

        # Deduplication: check hash
        $srcHash = Get-FileHashString $_.FullName
        if ($srcHash -and $existingHashes.ContainsKey($srcHash)) {
            $log += "Skipped (duplicate by hash): $($_.Name)"
            return
        }

        if (!(Test-Path $destFile)) {
            try {
                Copy-Item $_.FullName -Destination $finalDest -ErrorAction Stop
                $copiedCount++
                $copiedPaths += $_.FullName
                $log += "Copied: $($_.Name) to $finalDest"
                if ($srcHash) { $existingHashes[$srcHash] = $true }
            }
            catch {
                $log += "ERROR copying $($_.Name): $_"
            }
        } else {
            $log += "Skipped (already exists): $($_.Name)"
        }
    }

    # ================================
    # Delete originals if requested
    # ================================
    if ($deleteAfterCopy -and $copiedPaths.Count -gt 0) {
        $log += "Deleting originals for $($copiedPaths.Count) copied file(s)..."
        foreach ($path in $copiedPaths) {
            try {
                Remove-Item $path -ErrorAction Stop
                $log += "Deleted from Switch: $path"
            }
            catch {
                $log += "ERROR deleting ${path}: $_"
            }
        }
    } elseif ($deleteAfterCopy) {
        $log += "No files copied. Nothing to delete."
    }

    # ================================
    # Summary Result
    # ================================
    if ($copiedCount -gt 0) {
        $resultMessage = "Transfer complete: $copiedCount new file(s) copied."
    } else {
        $resultMessage = "No new captures found."
    }
    $log += $resultMessage

    # ================================
    # Windows Toast Notification
    # ================================
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    $template = @"
<toast>
    <visual>
        <binding template='ToastGeneric'>
            <text>Switch Import</text>
            <text>$resultMessage</text>
        </binding>
    </visual>
</toast>
"@
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Switch Importer")
    $notifier.Show($toast)
    $log += "Windows toast notification sent."


    # ================================
    # Google Chat Notification
    # ================================
    if ($enableGoogleChatNotification -and $googleChatWebhookUrl) {
        try {
            $payload = @{ text = "*Nintendo Switch Import Result*`n$resultMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $googleChatWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Google Chat notification sent."
        } catch { $log += "ERROR sending Google Chat message: $_" }
    }

    # ================================
    # Discord Notification
    # ================================
    if ($enableDiscordNotification -and $discordWebhookUrl) {
        try {
            $payload = @{ content = "Nintendo Switch Import Result: $resultMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $discordWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Discord notification sent."
        } catch { $log += "ERROR sending Discord message: $_" }
    }

    # ================================
    # Slack Notification
    # ================================
    if ($enableSlackNotification -and $slackWebhookUrl) {
        try {
            $payload = @{ text = "Nintendo Switch Import Result: $resultMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $slackWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Slack notification sent."
        } catch { $log += "ERROR sending Slack message: $_" }
    }

    # ================================
    # Microsoft Teams Notification
    # ================================
    if ($enableTeamsNotification -and $teamsWebhookUrl) {
        try {
            $payload = @{ text = "Nintendo Switch Import Result: $resultMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $teamsWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Teams notification sent."
        } catch { $log += "ERROR sending Teams message: $_" }
    }

    # ================================
    # SMS via Email-to-SMS Gateway
    # ================================
    if ($enableSmsNotification -and $smsTo) {
        try {
            Send-MailMessage -From $smsFrom -To $smsTo -Subject "Switch Import" -Body $resultMessage -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) -UseSsl
            $log += "SMS notification sent."
        } catch { $log += "ERROR sending SMS notification: $_" }
    }

    # ================================
    # Email Notification
    # ================================
    if ($enableEmailNotification) {
        try {
            $body = $resultMessage + "`r`n`r`nLog:`r`n" + ($log -join "`r`n")
            Send-MailMessage -From $emailFrom -To $emailTo -Subject $emailSubject -Body $body -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) -UseSsl
            $log += "Email notification sent."
        }
        catch {
            $log += "ERROR sending email notification: $_"
        }
    }
}
catch {
    $errorMessage = "ERROR: $_"
    $log += $errorMessage


    # Optional: Google Chat notification for error
    if ($enableGoogleChatNotification -and $googleChatWebhookUrl) {
        try {
            $payload = @{ text = "*Nintendo Switch Import ERROR*`n$errorMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $googleChatWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Google Chat error notification sent."
        } catch { $log += "ERROR sending Google Chat error message: $_" }
    }

    # Optional: Discord error notification
    if ($enableDiscordNotification -and $discordWebhookUrl) {
        try {
            $payload = @{ content = "Nintendo Switch Import ERROR: $errorMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $discordWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Discord error notification sent."
        } catch { $log += "ERROR sending Discord error message: $_" }
    }

    # Optional: Slack error notification
    if ($enableSlackNotification -and $slackWebhookUrl) {
        try {
            $payload = @{ text = "Nintendo Switch Import ERROR: $errorMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $slackWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Slack error notification sent."
        } catch { $log += "ERROR sending Slack error message: $_" }
    }

    # Optional: Teams error notification
    if ($enableTeamsNotification -and $teamsWebhookUrl) {
        try {
            $payload = @{ text = "Nintendo Switch Import ERROR: $errorMessage" } | ConvertTo-Json
            Invoke-RestMethod -Uri $teamsWebhookUrl -Method POST -ContentType "application/json" -Body $payload
            $log += "Teams error notification sent."
        } catch { $log += "ERROR sending Teams error message: $_" }
    }

    # Optional: SMS error notification
    if ($enableSmsNotification -and $smsTo) {
        try {
            Send-MailMessage -From $smsFrom -To $smsTo -Subject "Switch Import (ERROR)" -Body $errorMessage -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) -UseSsl
            $log += "SMS error notification sent."
        } catch { $log += "ERROR sending SMS error notification: $_" }
    }

    # Optional: Email notification for error
    if ($enableEmailNotification) {
        try {
            $body = $errorMessage + "`r`n`r`nLog:`r`n" + ($log -join "`r`n")
            Send-MailMessage -From $emailFrom -To $emailTo -Subject "$emailSubject (ERROR)" -Body $body -SmtpServer $smtpServer -Port $smtpPort -Credential (New-Object System.Management.Automation.PSCredential($smtpUser, (ConvertTo-SecureString $smtpPassword -AsPlainText -Force))) -UseSsl
            $log += "Email error notification sent."
        }
        catch {
            $log += "ERROR sending email error notification: $_"
        }
    }
}
finally {
    $endTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $log += "Finished: $endTimestamp"

    # Save log to file
    $safeTimestamp = (Get-Date).ToString("yyyy-MM-dd-HHmmss")
    $logFile = Join-Path $logFolder "ImportLog-$safeTimestamp.txt"
    $log -join "`r`n" | Out-File -Encoding UTF8 -FilePath $logFile
    Write-Output "Log saved to: $logFile"

    # Rotate logs
    $logFiles = Get-ChildItem -Path $logFolder -Filter *.txt | Sort-Object LastWriteTime
    if ($logFiles.Count -gt $maxLogFiles) {
        $removeCount = $logFiles.Count - $maxLogFiles
        $log += "Log rotation: Removing $removeCount old log(s)."
        $logFiles | Select-Object -First $removeCount | Remove-Item
    }
}
# End of script