<#
SwitchMoveCapturesGUI.ps1
A GUI frontend for configuring and running SwitchMoveCaptures.ps1
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Paths
$scriptPath = Join-Path $PSScriptRoot 'SwitchMoveCaptures.ps1'
$configPath = $scriptPath  # Config is embedded in main script
$devicesPath = Join-Path $PSScriptRoot 'AllowedSwitchDevices.yaml'

# Helper: Load config variables from main script
function Get-ScriptConfig {
    $lines = Get-Content $scriptPath
    $config = @{}
    foreach ($line in $lines) {
        if ($line -match '^\$(\w+)\s*=\s*"?([^\"]+)"?') {
            $config[$matches[1]] = $matches[2]
        }
    }
    return $config
}

# Helper: Save config variables to main script
function Set-ScriptConfig {
    param($config)
    $lines = Get-Content $scriptPath
    $newLines = $lines | ForEach-Object {
        if ($_ -match '^\$(\w+)\s*=') {
            $var = $matches[1]
            if ($config.ContainsKey($var)) {
                return "$${var} = \"$($config[$var])\""
            }
        }
        return $_
    }
    Set-Content -Path $scriptPath -Value $newLines
}

# Helper: Load AllowedSwitchDevices.yaml
function Get-Devices {
    if (!(Test-Path $devicesPath)) { return @() }
    if (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue) {
        $yaml = Get-Content $devicesPath -Raw
        $data = ConvertFrom-Yaml $yaml
        return $data.Devices
    } else {
        return @()
    }
}

# Helper: Save AllowedSwitchDevices.yaml
function Set-Devices {
    param($devices)
    if (Get-Command ConvertTo-Yaml -ErrorAction SilentlyContinue) {
        $yaml = @{ Devices = $devices } | ConvertTo-Yaml
        Set-Content -Path $devicesPath -Value $yaml
    }
}

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Switch Move Captures - GUI'
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = 'CenterScreen'

# Tabs
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'

# --- Config Tab ---
$tabConfig = New-Object System.Windows.Forms.TabPage
$tabConfig.Text = 'Configuration'

$config = Get-ScriptConfig

# Destination Folder
$lblDest = New-Object System.Windows.Forms.Label
$lblDest.Text = 'Destination Folder:'
$lblDest.Location = '10,20'
$lblDest.Size = '120,20'
$txtDest = New-Object System.Windows.Forms.TextBox
$txtDest.Text = $config['baseDestination']
$txtDest.Location = '140,20'
$txtDest.Size = '350,20'
$btnDest = New-Object System.Windows.Forms.Button
$btnDest.Text = 'Browse'
$btnDest.Location = '500,20'
$btnDest.Size = '60,20'
$btnDest.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtDest.Text = $fbd.SelectedPath }
})

# Log Folder
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = 'Log Folder:'
$lblLog.Location = '10,50'
$lblLog.Size = '120,20'
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Text = $config['logFolder']
$txtLog.Location = '140,50'
$txtLog.Size = '350,20'
$btnLog = New-Object System.Windows.Forms.Button
$btnLog.Text = 'Browse'
$btnLog.Location = '500,50'
$btnLog.Size = '60,20'
$btnLog.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtLog.Text = $fbd.SelectedPath }
})

# Delete After Copy
$chkDelete = New-Object System.Windows.Forms.CheckBox
$chkDelete.Text = 'Delete files from Switch after copy'
$chkDelete.Location = '140,80'
$chkDelete.Size = '250,20'
$chkDelete.Checked = ($config['deleteAfterCopy'] -eq 'True' -or $config['deleteAfterCopy'] -eq $true)

# Import Screenshots
$chkScreenshots = New-Object System.Windows.Forms.CheckBox
$chkScreenshots.Text = 'Import Screenshots (PNG)'
$chkScreenshots.Location = '140,110'
$chkScreenshots.Size = '200,20'
$chkScreenshots.Checked = ($config['importScreenshots'] -eq 'True' -or $config['importScreenshots'] -eq $true)

# Import Videos
$chkVideos = New-Object System.Windows.Forms.CheckBox
$chkVideos.Text = 'Import Videos (MP4)'
$chkVideos.Location = '140,140'
$chkVideos.Size = '200,20'
$chkVideos.Checked = ($config['importVideos'] -eq 'True' -or $config['importVideos'] -eq $true)

# Organize by Game
$chkGame = New-Object System.Windows.Forms.CheckBox
$chkGame.Text = 'Organize by Game Title'
$chkGame.Location = '140,170'
$chkGame.Size = '200,20'
$chkGame.Checked = ($config['organizeByGame'] -eq 'True' -or $config['organizeByGame'] -eq $true)

# Save Config Button
$btnSaveConfig = New-Object System.Windows.Forms.Button
$btnSaveConfig.Text = 'Save Configuration'
$btnSaveConfig.Location = '140,210'
$btnSaveConfig.Size = '150,30'
$btnSaveConfig.Add_Click({
    $config['baseDestination'] = $txtDest.Text
    $config['logFolder'] = $txtLog.Text
    $config['deleteAfterCopy'] = $chkDelete.Checked
    $config['importScreenshots'] = $chkScreenshots.Checked
    $config['importVideos'] = $chkVideos.Checked
    $config['organizeByGame'] = $chkGame.Checked
    Set-ScriptConfig $config
    [System.Windows.Forms.MessageBox]::Show('Configuration saved!')
})

$tabConfig.Controls.AddRange(@($lblDest,$txtDest,$btnDest,$lblLog,$txtLog,$btnLog,$chkDelete,$chkScreenshots,$chkVideos,$chkGame,$btnSaveConfig))

# --- Devices Tab ---
$tabDevices = New-Object System.Windows.Forms.TabPage
$tabDevices.Text = 'Allowed Devices'

$lstDevices = New-Object System.Windows.Forms.ListBox
$lstDevices.Location = '10,20'
$lstDevices.Size = '400,300'
$lstDevices.SelectionMode = 'One'

function Update-DeviceList {
    $lstDevices.Items.Clear()
    $devices = Get-Devices
    foreach ($dev in $devices) {
        $lstDevices.Items.Add("$($dev.Label) [$($dev.Serial)]")
    }
}
Update-DeviceList

# Remove Device Button
$btnRemoveDevice = New-Object System.Windows.Forms.Button
$btnRemoveDevice.Text = 'Remove Selected Device'
$btnRemoveDevice.Location = '420,20'
$btnRemoveDevice.Size = '150,30'
$btnRemoveDevice.Add_Click({
    $idx = $lstDevices.SelectedIndex
    if ($idx -ge 0) {
        $devices = Get-Devices
        $devices = $devices | Where-Object { $_.Serial -ne $devices[$idx].Serial }
        Set-Devices $devices
        Update-DeviceList
    }
})

$tabDevices.Controls.AddRange(@($lstDevices,$btnRemoveDevice))

# --- Notifications Tab ---
$tabNotify = New-Object System.Windows.Forms.TabPage
$tabNotify.Text = 'Notifications'

# Google Chat
$chkGoogle = New-Object System.Windows.Forms.CheckBox
$chkGoogle.Text = 'Enable Google Chat'
$chkGoogle.Location = '20,20'
$chkGoogle.Size = '200,20'
$chkGoogle.Checked = ($config['enableGoogleChatNotification'] -eq 'True' -or $config['enableGoogleChatNotification'] -eq $true)
$txtGoogle = New-Object System.Windows.Forms.TextBox
$txtGoogle.Text = $config['googleChatWebhookUrl']
$txtGoogle.Location = '240,20'
$txtGoogle.Size = '300,20'

# Discord
$chkDiscord = New-Object System.Windows.Forms.CheckBox
$chkDiscord.Text = 'Enable Discord'
$chkDiscord.Location = '20,50'
$chkDiscord.Size = '200,20'
$chkDiscord.Checked = ($config['enableDiscordNotification'] -eq 'True' -or $config['enableDiscordNotification'] -eq $true)
$txtDiscord = New-Object System.Windows.Forms.TextBox
$txtDiscord.Text = $config['discordWebhookUrl']
$txtDiscord.Location = '240,50'
$txtDiscord.Size = '300,20'

# Slack
$chkSlack = New-Object System.Windows.Forms.CheckBox
$chkSlack.Text = 'Enable Slack'
$chkSlack.Location = '20,80'
$chkSlack.Size = '200,20'
$chkSlack.Checked = ($config['enableSlackNotification'] -eq 'True' -or $config['enableSlackNotification'] -eq $true)
$txtSlack = New-Object System.Windows.Forms.TextBox
$txtSlack.Text = $config['slackWebhookUrl']
$txtSlack.Location = '240,80'
$txtSlack.Size = '300,20'

# Teams
$chkTeams = New-Object System.Windows.Forms.CheckBox
$chkTeams.Text = 'Enable Teams'
$chkTeams.Location = '20,110'
$chkTeams.Size = '200,20'
$chkTeams.Checked = ($config['enableTeamsNotification'] -eq 'True' -or $config['enableTeamsNotification'] -eq $true)
$txtTeams = New-Object System.Windows.Forms.TextBox
$txtTeams.Text = $config['teamsWebhookUrl']
$txtTeams.Location = '240,110'
$txtTeams.Size = '300,20'

# SMS
$chkSms = New-Object System.Windows.Forms.CheckBox
$chkSms.Text = 'Enable SMS'
$chkSms.Location = '20,140'
$chkSms.Size = '200,20'
$chkSms.Checked = ($config['enableSmsNotification'] -eq 'True' -or $config['enableSmsNotification'] -eq $true)
$txtSmsTo = New-Object System.Windows.Forms.TextBox
$txtSmsTo.Text = $config['smsTo']
$txtSmsTo.Location = '240,140'
$txtSmsTo.Size = '300,20'
$txtSmsFrom = New-Object System.Windows.Forms.TextBox
$txtSmsFrom.Text = $config['smsFrom']
$txtSmsFrom.Location = '240,170'
$txtSmsFrom.Size = '300,20'

# Email
$chkEmail = New-Object System.Windows.Forms.CheckBox
$chkEmail.Text = 'Enable Email'
$chkEmail.Location = '20,200'
$chkEmail.Size = '200,20'
$chkEmail.Checked = ($config['enableEmailNotification'] -eq 'True' -or $config['enableEmailNotification'] -eq $true)
$txtEmailTo = New-Object System.Windows.Forms.TextBox
$txtEmailTo.Text = $config['emailTo']
$txtEmailTo.Location = '240,200'
$txtEmailTo.Size = '300,20'
$txtEmailFrom = New-Object System.Windows.Forms.TextBox
$txtEmailFrom.Text = $config['emailFrom']
$txtEmailFrom.Location = '240,230'
$txtEmailFrom.Size = '300,20'
$txtSmtpServer = New-Object System.Windows.Forms.TextBox
$txtSmtpServer.Text = $config['smtpServer']
$txtSmtpServer.Location = '240,260'
$txtSmtpServer.Size = '300,20'
$txtSmtpPort = New-Object System.Windows.Forms.TextBox
$txtSmtpPort.Text = $config['smtpPort']
$txtSmtpPort.Location = '240,290'
$txtSmtpPort.Size = '300,20'
$txtSmtpUser = New-Object System.Windows.Forms.TextBox
$txtSmtpUser.Text = $config['smtpUser']
$txtSmtpUser.Location = '240,320'
$txtSmtpUser.Size = '300,20'
$txtSmtpPassword = New-Object System.Windows.Forms.TextBox
$txtSmtpPassword.Text = $config['smtpPassword']
$txtSmtpPassword.Location = '240,350'
$txtSmtpPassword.Size = '300,20'
$txtSmtpPassword.UseSystemPasswordChar = $true

# Save Notification Config
$btnSaveNotify = New-Object System.Windows.Forms.Button
$btnSaveNotify.Text = 'Save Notification Settings'
$btnSaveNotify.Location = '240,380'
$btnSaveNotify.Size = '200,30'
$btnSaveNotify.Add_Click({
    $config['enableGoogleChatNotification'] = $chkGoogle.Checked
    $config['googleChatWebhookUrl'] = $txtGoogle.Text
    $config['enableDiscordNotification'] = $chkDiscord.Checked
    $config['discordWebhookUrl'] = $txtDiscord.Text
    $config['enableSlackNotification'] = $chkSlack.Checked
    $config['slackWebhookUrl'] = $txtSlack.Text
    $config['enableTeamsNotification'] = $chkTeams.Checked
    $config['teamsWebhookUrl'] = $txtTeams.Text
    $config['enableSmsNotification'] = $chkSms.Checked
    $config['smsTo'] = $txtSmsTo.Text
    $config['smsFrom'] = $txtSmsFrom.Text
    $config['enableEmailNotification'] = $chkEmail.Checked
    $config['emailTo'] = $txtEmailTo.Text
    $config['emailFrom'] = $txtEmailFrom.Text
    $config['smtpServer'] = $txtSmtpServer.Text
    $config['smtpPort'] = $txtSmtpPort.Text
    $config['smtpUser'] = $txtSmtpUser.Text
    $config['smtpPassword'] = $txtSmtpPassword.Text
    Set-ScriptConfig $config
    [System.Windows.Forms.MessageBox]::Show('Notification settings saved!')
})

$tabNotify.Controls.AddRange(@(
    $chkGoogle,$txtGoogle,
    $chkDiscord,$txtDiscord,
    $chkSlack,$txtSlack,
    $chkTeams,$txtTeams,
    $chkSms,$txtSmsTo,$txtSmsFrom,
    $chkEmail,$txtEmailTo,$txtEmailFrom,$txtSmtpServer,$txtSmtpPort,$txtSmtpUser,$txtSmtpPassword,
    $btnSaveNotify
))

# --- Run Script Tab ---
$tabRun = New-Object System.Windows.Forms.TabPage
$tabRun.Text = 'Manual Import'

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = 'Run Import Now'
$btnRun.Location = '20,20'
$btnRun.Size = '150,40'
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = 'Vertical'
$txtLog.Location = '20,80'
$txtLog.Size = '540,400'
$txtLog.ReadOnly = $true

$btnRun.Add_Click({
    $proc = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\switchmove_log.txt"
    Start-Sleep -Seconds 2
    if (Test-Path "$env:TEMP\switchmove_log.txt") {
        $txtLog.Text = Get-Content "$env:TEMP\switchmove_log.txt" -Raw
    } else {
        $txtLog.Text = 'No log output found.'
    }
})

$tabRun.Controls.AddRange(@($btnRun,$txtLog))

# Add tabs
$tabControl.TabPages.AddRange(@($tabConfig,$tabDevices,$tabNotify,$tabRun))
$form.Controls.Add($tabControl)

# Show
[void]$form.ShowDialog()
