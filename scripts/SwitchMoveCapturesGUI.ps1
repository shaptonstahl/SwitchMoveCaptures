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


# --- Language Support ---
$SupportedLanguages = @{
    'en' = 'English'
    'fr' = 'Français'
    'es' = 'Español'
    'de' = 'Deutsch'
    'ja' = '日本語'
    'zh' = '简体中文'
}

# UI Strings for each language
$LangStrings = @{
    'en' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = 'Configuration'
        TabDevices = 'Allowed Devices'
        TabNotify = 'Notifications'
        TabRun = 'Manual Import'
        DestFolder = 'Destination Folder:'
        LogFolder = 'Log Folder:'
        Browse = 'Browse'
        DeleteAfterCopy = 'Delete files from Switch after copy'
        ImportScreenshots = 'Import Screenshots (PNG)'
        ImportVideos = 'Import Videos (MP4)'
        OrganizeByGame = 'Organize by Game Title'
        SaveConfig = 'Save Configuration'
        ConfigSaved = 'Configuration saved!'
        DevicesRemove = 'Remove Selected Device'
        NotifyGoogle = 'Enable Google Chat'
        NotifyDiscord = 'Enable Discord'
        NotifySlack = 'Enable Slack'
        NotifyTeams = 'Enable Teams'
        NotifySms = 'Enable SMS'
        NotifyEmail = 'Enable Email'
        SaveNotify = 'Save Notification Settings'
        NotifySaved = 'Notification settings saved!'
        RunNow = 'Run Import Now'
        NoLog = 'No log output found.'
    }
    'fr' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = 'Configuration'
        TabDevices = 'Appareils autorisés'
        TabNotify = 'Notifications'
        TabRun = 'Importation manuelle'
        DestFolder = 'Dossier de destination :'
        LogFolder = 'Dossier de logs :'
        Browse = 'Parcourir'
        DeleteAfterCopy = 'Supprimer les fichiers du Switch après copie'
        ImportScreenshots = 'Importer les captures d’écran (PNG)'
        ImportVideos = 'Importer les vidéos (MP4)'
        OrganizeByGame = 'Organiser par titre du jeu'
        SaveConfig = 'Enregistrer la configuration'
        ConfigSaved = 'Configuration enregistrée !'
        DevicesRemove = 'Supprimer l’appareil sélectionné'
        NotifyGoogle = 'Activer Google Chat'
        NotifyDiscord = 'Activer Discord'
        NotifySlack = 'Activer Slack'
        NotifyTeams = 'Activer Teams'
        NotifySms = 'Activer SMS'
        NotifyEmail = 'Activer Email'
        SaveNotify = 'Enregistrer les notifications'
        NotifySaved = 'Notifications enregistrées !'
        RunNow = 'Importer maintenant'
        NoLog = 'Aucun journal trouvé.'
    }
    'es' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = 'Configuración'
        TabDevices = 'Dispositivos permitidos'
        TabNotify = 'Notificaciones'
        TabRun = 'Importación manual'
        DestFolder = 'Carpeta de destino:'
        LogFolder = 'Carpeta de registros:'
        Browse = 'Examinar'
        DeleteAfterCopy = 'Eliminar archivos del Switch después de copiar'
        ImportScreenshots = 'Importar capturas de pantalla (PNG)'
        ImportVideos = 'Importar videos (MP4)'
        OrganizeByGame = 'Organizar por título del juego'
        SaveConfig = 'Guardar configuración'
        ConfigSaved = '¡Configuración guardada!'
        DevicesRemove = 'Eliminar dispositivo seleccionado'
        NotifyGoogle = 'Habilitar Google Chat'
        NotifyDiscord = 'Habilitar Discord'
        NotifySlack = 'Habilitar Slack'
        NotifyTeams = 'Habilitar Teams'
        NotifySms = 'Habilitar SMS'
        NotifyEmail = 'Habilitar Email'
        SaveNotify = 'Guardar notificaciones'
        NotifySaved = '¡Notificaciones guardadas!'
        RunNow = 'Importar ahora'
        NoLog = 'No se encontró registro.'
    }
    'de' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = 'Konfiguration'
        TabDevices = 'Erlaubte Geräte'
        TabNotify = 'Benachrichtigungen'
        TabRun = 'Manueller Import'
        DestFolder = 'Zielordner:'
        LogFolder = 'Protokollordner:'
        Browse = 'Durchsuchen'
        DeleteAfterCopy = 'Dateien nach dem Kopieren vom Switch löschen'
        ImportScreenshots = 'Screenshots importieren (PNG)'
        ImportVideos = 'Videos importieren (MP4)'
        OrganizeByGame = 'Nach Spieltitel organisieren'
        SaveConfig = 'Konfiguration speichern'
        ConfigSaved = 'Konfiguration gespeichert!'
        DevicesRemove = 'Ausgewähltes Gerät entfernen'
        NotifyGoogle = 'Google Chat aktivieren'
        NotifyDiscord = 'Discord aktivieren'
        NotifySlack = 'Slack aktivieren'
        NotifyTeams = 'Teams aktivieren'
        NotifySms = 'SMS aktivieren'
        NotifyEmail = 'E-Mail aktivieren'
        SaveNotify = 'Benachrichtigungen speichern'
        NotifySaved = 'Benachrichtigungen gespeichert!'
        RunNow = 'Jetzt importieren'
        NoLog = 'Kein Protokoll gefunden.'
    }
    'ja' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = '設定'
        TabDevices = '許可デバイス'
        TabNotify = '通知'
        TabRun = '手動インポート'
        DestFolder = '保存先フォルダ:'
        LogFolder = 'ログフォルダ:'
        Browse = '参照'
        DeleteAfterCopy = 'コピー後にSwitchからファイルを削除'
        ImportScreenshots = 'スクリーンショットをインポート (PNG)'
        ImportVideos = 'ビデオをインポート (MP4)'
        OrganizeByGame = 'ゲームタイトルで整理'
        SaveConfig = '設定を保存'
        ConfigSaved = '設定を保存しました！'
        DevicesRemove = '選択したデバイスを削除'
        NotifyGoogle = 'Google Chatを有効化'
        NotifyDiscord = 'Discordを有効化'
        NotifySlack = 'Slackを有効化'
        NotifyTeams = 'Teamsを有効化'
        NotifySms = 'SMSを有効化'
        NotifyEmail = 'メールを有効化'
        SaveNotify = '通知を保存'
        NotifySaved = '通知を保存しました！'
        RunNow = '今すぐインポート'
        NoLog = 'ログが見つかりません。'
    }
    'zh' = @{
        Title = 'Switch Move Captures - GUI'
        TabConfig = '配置'
        TabDevices = '允许的设备'
        TabNotify = '通知'
        TabRun = '手动导入'
        DestFolder = '目标文件夹：'
        LogFolder = '日志文件夹：'
        Browse = '浏览'
        DeleteAfterCopy = '复制后从Switch中删除文件'
        ImportScreenshots = '导入截图 (PNG)'
        ImportVideos = '导入视频 (MP4)'
        OrganizeByGame = '按游戏标题组织'
        SaveConfig = '保存配置'
        ConfigSaved = '配置已保存！'
        DevicesRemove = '移除所选设备'
        NotifyGoogle = '启用 Google Chat'
        NotifyDiscord = '启用 Discord'
        NotifySlack = '启用 Slack'
        NotifyTeams = '启用 Teams'
        NotifySms = '启用短信'
        NotifyEmail = '启用邮件'
        SaveNotify = '保存通知设置'
        NotifySaved = '通知设置已保存！'
        RunNow = '立即导入'
        NoLog = '未找到日志输出。'
    }
}

# Default language
$CurrentLang = 'en'

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = $LangStrings[$CurrentLang].Title
$form.Size = New-Object System.Drawing.Size(600, 600)
$form.StartPosition = 'CenterScreen'

# Language Selector
$lblLang = New-Object System.Windows.Forms.Label
$lblLang.Text = 'Language:'
$lblLang.Location = '10,5'
$lblLang.Size = '70,20'
$cmbLang = New-Object System.Windows.Forms.ComboBox
$cmbLang.Location = '80,5'
$cmbLang.Size = '120,20'
$cmbLang.DropDownStyle = 'DropDownList'
$cmbLang.Items.AddRange($SupportedLanguages.Values)
$cmbLang.SelectedIndex = 0
$form.Controls.AddRange(@($lblLang, $cmbLang))

# Tabs
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'
$tabControl.Location = '0,35'
$tabControl.Size = '600,530'


# --- Config Tab ---
$tabConfig = New-Object System.Windows.Forms.TabPage
$tabConfig.Text = $LangStrings[$CurrentLang].TabConfig

$config = Get-ScriptConfig

# Destination Folder
$lblDest = New-Object System.Windows.Forms.Label
$lblDest.Text = $LangStrings[$CurrentLang].DestFolder
$lblDest.Location = '10,20'
$lblDest.Size = '120,20'
$txtDest = New-Object System.Windows.Forms.TextBox
$txtDest.Text = $config['baseDestination']
$txtDest.Location = '140,20'
$txtDest.Size = '350,20'
$btnDest = New-Object System.Windows.Forms.Button
$btnDest.Text = $LangStrings[$CurrentLang].Browse
$btnDest.Location = '500,20'
$btnDest.Size = '60,20'
$btnDest.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtDest.Text = $fbd.SelectedPath }
})

# Log Folder
$lblLog = New-Object System.Windows.Forms.Label
$lblLog.Text = $LangStrings[$CurrentLang].LogFolder
$lblLog.Location = '10,50'
$lblLog.Size = '120,20'
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Text = $config['logFolder']
$txtLog.Location = '140,50'
$txtLog.Size = '350,20'
$btnLog = New-Object System.Windows.Forms.Button
$btnLog.Text = $LangStrings[$CurrentLang].Browse
$btnLog.Location = '500,50'
$btnLog.Size = '60,20'
$btnLog.Add_Click({
    $fbd = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($fbd.ShowDialog() -eq 'OK') { $txtLog.Text = $fbd.SelectedPath }
})

# Delete After Copy
$chkDelete = New-Object System.Windows.Forms.CheckBox
$chkDelete.Text = $LangStrings[$CurrentLang].DeleteAfterCopy
$chkDelete.Location = '140,80'
$chkDelete.Size = '250,20'
$chkDelete.Checked = ($config['deleteAfterCopy'] -eq 'True' -or $config['deleteAfterCopy'] -eq $true)

# Import Screenshots
$chkScreenshots = New-Object System.Windows.Forms.CheckBox
$chkScreenshots.Text = $LangStrings[$CurrentLang].ImportScreenshots
$chkScreenshots.Location = '140,110'
$chkScreenshots.Size = '200,20'
$chkScreenshots.Checked = ($config['importScreenshots'] -eq 'True' -or $config['importScreenshots'] -eq $true)

# Import Videos
$chkVideos = New-Object System.Windows.Forms.CheckBox
$chkVideos.Text = $LangStrings[$CurrentLang].ImportVideos
$chkVideos.Location = '140,140'
$chkVideos.Size = '200,20'
$chkVideos.Checked = ($config['importVideos'] -eq 'True' -or $config['importVideos'] -eq $true)

# Organize by Game
$chkGame = New-Object System.Windows.Forms.CheckBox
$chkGame.Text = $LangStrings[$CurrentLang].OrganizeByGame
$chkGame.Location = '140,170'
$chkGame.Size = '200,20'
$chkGame.Checked = ($config['organizeByGame'] -eq 'True' -or $config['organizeByGame'] -eq $true)

# Save Config Button
$btnSaveConfig = New-Object System.Windows.Forms.Button
$btnSaveConfig.Text = $LangStrings[$CurrentLang].SaveConfig
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
    [System.Windows.Forms.MessageBox]::Show($LangStrings[$CurrentLang].ConfigSaved)
})

$tabConfig.Controls.AddRange(@($lblDest,$txtDest,$btnDest,$lblLog,$txtLog,$btnLog,$chkDelete,$chkScreenshots,$chkVideos,$chkGame,$btnSaveConfig))


# --- Devices Tab ---
$tabDevices = New-Object System.Windows.Forms.TabPage
$tabDevices.Text = $LangStrings[$CurrentLang].TabDevices

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
$btnRemoveDevice.Text = $LangStrings[$CurrentLang].DevicesRemove
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
$tabNotify.Text = $LangStrings[$CurrentLang].TabNotify

# Google Chat
$chkGoogle = New-Object System.Windows.Forms.CheckBox
$chkGoogle.Text = $LangStrings[$CurrentLang].NotifyGoogle
$chkGoogle.Location = '20,20'
$chkGoogle.Size = '200,20'
$chkGoogle.Checked = ($config['enableGoogleChatNotification'] -eq 'True' -or $config['enableGoogleChatNotification'] -eq $true)
$txtGoogle = New-Object System.Windows.Forms.TextBox
$txtGoogle.Text = $config['googleChatWebhookUrl']
$txtGoogle.Location = '240,20'
$txtGoogle.Size = '300,20'

# Discord
$chkDiscord = New-Object System.Windows.Forms.CheckBox
$chkDiscord.Text = $LangStrings[$CurrentLang].NotifyDiscord
$chkDiscord.Location = '20,50'
$chkDiscord.Size = '200,20'
$chkDiscord.Checked = ($config['enableDiscordNotification'] -eq 'True' -or $config['enableDiscordNotification'] -eq $true)
$txtDiscord = New-Object System.Windows.Forms.TextBox
$txtDiscord.Text = $config['discordWebhookUrl']
$txtDiscord.Location = '240,50'
$txtDiscord.Size = '300,20'

# Slack
$chkSlack = New-Object System.Windows.Forms.CheckBox
$chkSlack.Text = $LangStrings[$CurrentLang].NotifySlack
$chkSlack.Location = '20,80'
$chkSlack.Size = '200,20'
$chkSlack.Checked = ($config['enableSlackNotification'] -eq 'True' -or $config['enableSlackNotification'] -eq $true)
$txtSlack = New-Object System.Windows.Forms.TextBox
$txtSlack.Text = $config['slackWebhookUrl']
$txtSlack.Location = '240,80'
$txtSlack.Size = '300,20'

# Teams
$chkTeams = New-Object System.Windows.Forms.CheckBox
$chkTeams.Text = $LangStrings[$CurrentLang].NotifyTeams
$chkTeams.Location = '20,110'
$chkTeams.Size = '200,20'
$chkTeams.Checked = ($config['enableTeamsNotification'] -eq 'True' -or $config['enableTeamsNotification'] -eq $true)
$txtTeams = New-Object System.Windows.Forms.TextBox
$txtTeams.Text = $config['teamsWebhookUrl']
$txtTeams.Location = '240,110'
$txtTeams.Size = '300,20'

# SMS
$chkSms = New-Object System.Windows.Forms.CheckBox
$chkSms.Text = $LangStrings[$CurrentLang].NotifySms
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
$chkEmail.Text = $LangStrings[$CurrentLang].NotifyEmail
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
$btnSaveNotify.Text = $LangStrings[$CurrentLang].SaveNotify
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
    [System.Windows.Forms.MessageBox]::Show($LangStrings[$CurrentLang].NotifySaved)
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
$tabRun.Text = $LangStrings[$CurrentLang].TabRun

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = $LangStrings[$CurrentLang].RunNow
$btnRun.Location = '20,20'
$btnRun.Size = '150,40'
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = 'Vertical'
$txtLog.Location = '20,80'
$txtLog.Size = '540,400'
$txtLog.ReadOnly = $true

$btnRun.Add_Click({
    $proc = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `\"$scriptPath`\"" -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\switchmove_log.txt"
    Start-Sleep -Seconds 2
    if (Test-Path "$env:TEMP\switchmove_log.txt") {
        $txtLog.Text = Get-Content "$env:TEMP\switchmove_log.txt" -Raw
    } else {
        $txtLog.Text = $LangStrings[$CurrentLang].NoLog
    }
})

$tabRun.Controls.AddRange(@($btnRun,$txtLog))


# Add tabs
$tabControl.TabPages.AddRange(@($tabConfig,$tabDevices,$tabNotify,$tabRun))
$form.Controls.Add($tabControl)

# --- Language Change Handler ---
$cmbLang.Add_SelectedIndexChanged({
    $selectedLang = ($SupportedLanguages.Keys)[$cmbLang.SelectedIndex]
    $Global:CurrentLang = $selectedLang
    # Update all UI text
    $form.Text = $LangStrings[$CurrentLang].Title
    $tabConfig.Text = $LangStrings[$CurrentLang].TabConfig
    $lblDest.Text = $LangStrings[$CurrentLang].DestFolder
    $btnDest.Text = $LangStrings[$CurrentLang].Browse
    $lblLog.Text = $LangStrings[$CurrentLang].LogFolder
    $btnLog.Text = $LangStrings[$CurrentLang].Browse
    $chkDelete.Text = $LangStrings[$CurrentLang].DeleteAfterCopy
    $chkScreenshots.Text = $LangStrings[$CurrentLang].ImportScreenshots
    $chkVideos.Text = $LangStrings[$CurrentLang].ImportVideos
    $chkGame.Text = $LangStrings[$CurrentLang].OrganizeByGame
    $btnSaveConfig.Text = $LangStrings[$CurrentLang].SaveConfig
    $tabDevices.Text = $LangStrings[$CurrentLang].TabDevices
    $btnRemoveDevice.Text = $LangStrings[$CurrentLang].DevicesRemove
    $tabNotify.Text = $LangStrings[$CurrentLang].TabNotify
    $chkGoogle.Text = $LangStrings[$CurrentLang].NotifyGoogle
    $chkDiscord.Text = $LangStrings[$CurrentLang].NotifyDiscord
    $chkSlack.Text = $LangStrings[$CurrentLang].NotifySlack
    $chkTeams.Text = $LangStrings[$CurrentLang].NotifyTeams
    $chkSms.Text = $LangStrings[$CurrentLang].NotifySms
    $chkEmail.Text = $LangStrings[$CurrentLang].NotifyEmail
    $btnSaveNotify.Text = $LangStrings[$CurrentLang].SaveNotify
    $tabRun.Text = $LangStrings[$CurrentLang].TabRun
    $btnRun.Text = $LangStrings[$CurrentLang].RunNow
    # Optionally update log text if it's the default
    if ($txtLog.Text -eq $LangStrings['en'].NoLog -or $txtLog.Text -eq $LangStrings['fr'].NoLog -or $txtLog.Text -eq $LangStrings['es'].NoLog -or $txtLog.Text -eq $LangStrings['de'].NoLog -or $txtLog.Text -eq $LangStrings['ja'].NoLog -or $txtLog.Text -eq $LangStrings['zh'].NoLog) {
        $txtLog.Text = $LangStrings[$CurrentLang].NoLog
    }
})

# Show
[void]$form.ShowDialog()
