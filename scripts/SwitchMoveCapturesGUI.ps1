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

# English-only strings
$L = @{
    Title = 'Switch Move Captures - GUI'
    TabConfig = 'Configuration'
    TabDevices = 'Allowed Devices'
    TabNotify = 'Notifications'
    TabRun = 'Manual Run'
    DestFolder = 'Destination Folder:'
    LogFolder = 'Log Folder:'
    Browse = 'Browse'
    DeleteAfterCopy = 'Delete files from Switch after copy'
    ImportScreenshots = 'Import screenshots (PNG)'
    ImportVideos = 'Import videos (MP4)'
    OrganizeByGame = 'Organize by game title'
    SaveConfig = 'Save configuration'
    ConfigSaved = 'Configuration saved!'
    DevicesRemove = 'Remove selected device'
    NotifyGoogle = 'Enable Google Chat'
    NotifyDiscord = 'Enable Discord'
    NotifySlack = 'Enable Slack'
    NotifyTeams = 'Enable Teams'
    NotifySms = 'Enable SMS'
    NotifyEmail = 'Enable Email'
    SaveNotify = 'Save notifications'
    NotifySaved = 'Notifications saved!'
    RunNow = 'Run now'
    NoLog = 'No log found.'
}

# Helper: Load config variables from main script (simple, robust fallback)
function Get-ScriptConfig {
    $defaults = @{
        baseDestination = ''
        logFolder = ''
        deleteAfterCopy = $false
        importScreenshots = $true
        importVideos = $true
        organizeByGame = $false
        enableGoogleChatNotification = $false
        googleChatWebhookUrl = ''
        enableDiscordNotification = $false
        discordWebhookUrl = ''
        enableSlackNotification = $false
        slackWebhookUrl = ''
        enableTeamsNotification = $false
        teamsWebhookUrl = ''
        enableSmsNotification = $false
        smsTo = ''
        smsFrom = ''
        enableEmailNotification = $false
        emailTo = ''
        emailFrom = ''
        smtpServer = ''
        smtpPort = ''
        smtpUser = ''
        smtpPassword = ''
    }
    if (Test-Path $scriptPath) {
        try {
            $content = Get-Content $scriptPath -ErrorAction Stop
            foreach ($k in $defaults.Keys) {
                $regex = "\b$k\b\s*=\s*'([^']*)'"
                foreach ($line in $content) {
                    if ($line -match $regex) { $defaults[$k] = $matches[1]; break }
                }
            }
        } catch { }
    }
    return $defaults
}

# Helper: Save config variables back into the main script
function Set-ScriptConfig {
    param($config)
    if (-not (Test-Path $scriptPath)) { return }
    # Read as lines to preserve other parts of the script
    $raw = Get-Content -Raw -Encoding UTF8 -Path $scriptPath
    $lines = $raw -split "\r?\n"
    foreach ($k in $config.Keys) {
        # match variable assignments like: $var = "value" or $var = $true
        $pat = "^\s*\$" + [regex]::Escape($k) + "\s*=.*$"
        $found = $false
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match $pat) {
                $v = $config[$k]
                if ($v -is [bool]) {
                    if ($v) { $vstr = '$true' } else { $vstr = '$false' }
                } else {
                    if ($v -eq $null) { $v = '' }
                    $esc = $v -replace '"','\"'
                    $vstr = '"' + $esc + '"'
                }
                $lines[$i] = "`$$k = $vstr"
                $found = $true
                break
            }
        }
        if (-not $found) {
            $v = $config[$k]
            if ($v -is [bool]) {
                if ($v) { $vstr = '$true' } else { $vstr = '$false' }
            } else {
                if ($v -eq $null) { $v = '' }
                $esc = $v -replace '"','\"'
                $vstr = '"' + $esc + '"'
            }
            $lines += "`$$k = $vstr"
        }
    }
    Set-Content -Path $scriptPath -Value ($lines -join "`n") -Encoding UTF8
}

# Helper: Load AllowedSwitchDevices.yaml
function Get-Devices {
    if (!(Test-Path $devicesPath)) { return @() }
    if (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue) {
        try {
            $yaml = Get-Content -Raw -Encoding UTF8 -Path $devicesPath
            $data = ConvertFrom-Yaml $yaml
            return $data.Devices
        } catch { return @() }
    } else {
        return @()
    }
}

# Helper: Save AllowedSwitchDevices.yaml
function Set-Devices {
    param($devices)
    if (Get-Command ConvertTo-Yaml -ErrorAction SilentlyContinue) {
        try {
            $doc = @{ Devices = $devices }
            $yaml = $doc | ConvertTo-Yaml
            Set-Content -Path $devicesPath -Value $yaml -Encoding UTF8
        } catch { }
    } else {
        # Fallback: write JSON-ish representation for visibility
        try {
            $json = $devices | ConvertTo-Json -Depth 5
            Set-Content -Path $devicesPath -Value $json -Encoding UTF8
        } catch { }
    }
}
# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = $L.Title
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = 'CenterScreen'

# Tabs
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.Location = '0,35'
$tabControl.Size = '600,530'


# --- Config Tab ---
$tabConfig = New-Object System.Windows.Forms.TabPage
$tabConfig.Text = $L.TabConfig

$config = Get-ScriptConfig

# Destination Folder
$lblDest = New-Object System.Windows.Forms.Label
$lblDest.Text = $L.DestFolder
$lblDest.Location = '10,20'
$lblDest.Size = '120,20'
$txtDest = New-Object System.Windows.Forms.TextBox
$txtDest.Text = $config['baseDestination']
$txtDest.Location = '140,20'
$txtDest.Size = '350,20'
$btnDest = New-Object System.Windows.Forms.Button
$btnDest.Text = $L.Browse
$btnDest.Location = '500,20'
$btnDest.Size = '60,20'
$btnDest.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtDest.Text = $fbd.SelectedPath }
})

# Log Folder
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = $L.LogFolder
$lblLog.Location = '10,50'
$lblLog.Size = '120,20'
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Text = $config['logFolder']
$txtLog.Location = '140,50'
$txtLog.Size = '350,20'
$btnLog = New-Object System.Windows.Forms.Button
$btnLog.Text = $L.Browse
$btnLog.Location = '500,50'
$btnLog.Size = '60,20'
$btnLog.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtLog.Text = $fbd.SelectedPath }
})

# Delete after copy checkbox
$chkDelete = New-Object System.Windows.Forms.CheckBox
$chkDelete.Text = $L.DeleteAfterCopy
$chkDelete.Location = '140,80'
$chkDelete.Size = '300,20'
$chkDelete.Checked = ($config['deleteAfterCopy'] -eq 'True' -or $config['deleteAfterCopy'] -eq $true)

# Import Screenshots
$chkScreenshots = New-Object System.Windows.Forms.CheckBox
$chkScreenshots.Text = $L.ImportScreenshots
$chkScreenshots.Location = '140,110'
$chkScreenshots.Size = '200,20'
$chkScreenshots.Checked = ($config['importScreenshots'] -eq 'True' -or $config['importScreenshots'] -eq $true)

# Import Videos
$chkVideos = New-Object System.Windows.Forms.CheckBox
$chkVideos.Text = $L.ImportVideos
$chkVideos.Location = '140,140'
$chkVideos.Size = '200,20'
$chkVideos.Checked = ($config['importVideos'] -eq 'True' -or $config['importVideos'] -eq $true)

# Organize by Game
$chkGame = New-Object System.Windows.Forms.CheckBox
$chkGame.Text = $L.OrganizeByGame
$chkGame.Location = '140,170'
$chkGame.Size = '200,20'
$chkGame.Checked = ($config['organizeByGame'] -eq 'True' -or $config['organizeByGame'] -eq $true)

# Save Config Button
$btnSaveConfig = New-Object System.Windows.Forms.Button
$btnSaveConfig.Text = $L.SaveConfig
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
    [System.Windows.Forms.MessageBox]::Show($L.ConfigSaved)
})

$tabConfig.Controls.AddRange(@($lblDest,$txtDest,$btnDest,$lblLog,$txtLog,$btnLog,$chkDelete,$chkScreenshots,$chkVideos,$chkGame,$btnSaveConfig))


# --- Devices Tab ---
$tabDevices = New-Object System.Windows.Forms.TabPage
$tabDevices.Text = $L.TabDevices

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
$btnRemoveDevice.Text = $L.DevicesRemove
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
$tabNotify.Text = $L.TabNotify

# Google Chat
$chkGoogle = New-Object System.Windows.Forms.CheckBox
$chkGoogle.Text = $L.NotifyGoogle
$chkGoogle.Location = '20,20'
$chkGoogle.Size = '200,20'
$chkGoogle.Checked = ($config['enableGoogleChatNotification'] -eq 'True' -or $config['enableGoogleChatNotification'] -eq $true)
$txtGoogle = New-Object System.Windows.Forms.TextBox
$txtGoogle.Text = $config['googleChatWebhookUrl']
$txtGoogle.Location = '240,20'
$txtGoogle.Size = '300,20'

# Discord
$chkDiscord = New-Object System.Windows.Forms.CheckBox
$chkDiscord.Text = $L.NotifyDiscord
$chkDiscord.Location = '20,50'
$chkDiscord.Size = '200,20'
$chkDiscord.Checked = ($config['enableDiscordNotification'] -eq 'True' -or $config['enableDiscordNotification'] -eq $true)
$txtDiscord = New-Object System.Windows.Forms.TextBox
$txtDiscord.Text = $config['discordWebhookUrl']
$txtDiscord.Location = '240,50'
$txtDiscord.Size = '300,20'

# Slack
$chkSlack = New-Object System.Windows.Forms.CheckBox
$chkSlack.Text = $L.NotifySlack
$chkSlack.Location = '20,80'
$chkSlack.Size = '200,20'
$chkSlack.Checked = ($config['enableSlackNotification'] -eq 'True' -or $config['enableSlackNotification'] -eq $true)
$txtSlack = New-Object System.Windows.Forms.TextBox
$txtSlack.Text = $config['slackWebhookUrl']
$txtSlack.Location = '240,80'
$txtSlack.Size = '300,20'

# Teams
$chkTeams = New-Object System.Windows.Forms.CheckBox
$chkTeams.Text = $L.NotifyTeams
$chkTeams.Location = '20,110'
$chkTeams.Size = '200,20'
$chkTeams.Checked = ($config['enableTeamsNotification'] -eq 'True' -or $config['enableTeamsNotification'] -eq $true)
$txtTeams = New-Object System.Windows.Forms.TextBox
$txtTeams.Text = $config['teamsWebhookUrl']
$txtTeams.Location = '240,110'
$txtTeams.Size = '300,20'

# SMS
$chkSms = New-Object System.Windows.Forms.CheckBox
$chkSms.Text = $L.NotifySms
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
$chkEmail.Text = $L.NotifyEmail
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
$btnSaveNotify.Text = $L.SaveNotify
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
    [System.Windows.Forms.MessageBox]::Show($L.NotifySaved)
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
$tabRun.Text = $L.TabRun

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = $L.RunNow
$btnRun.Location = '20,20'
$btnRun.Size = '150,40'
$txtRunLog = New-Object System.Windows.Forms.TextBox
$txtRunLog.Multiline = $true
$txtRunLog.ScrollBars = 'Vertical'
$txtRunLog.Location = '20,80'
$txtRunLog.Size = '540,400'
$txtRunLog.ReadOnly = $true

$btnRun.Add_Click({
    $args = @('-NoProfile','-ExecutionPolicy','Bypass','-File',$scriptPath)
    $proc = Start-Process -FilePath 'powershell' -ArgumentList $args -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\switchmove_log.txt"
    Start-Sleep -Seconds 2
    if (Test-Path "$env:TEMP\switchmove_log.txt") {
        $txtRunLog.Text = Get-Content "$env:TEMP\switchmove_log.txt" -Raw
        $txtRunLog.Tag = $null
    } else {
        $txtRunLog.Text = $L.NoLog
        $txtRunLog.Tag = 'AUTO'
    }
})

$tabRun.Controls.AddRange(@($btnRun,$txtRunLog))


# Add tabs
$tabControl.TabPages.AddRange(@($tabConfig,$tabDevices,$tabNotify,$tabRun))
$form.Controls.Add($tabControl)

# No language selector — English only

# Show
[void]$form.ShowDialog()
