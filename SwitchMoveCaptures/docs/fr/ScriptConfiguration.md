
[English](../en/ScriptConfiguration.md) | [Français](../fr/ScriptConfiguration.md) | [Español](../es/ScriptConfiguration.md) | [Deutsch](../de/ScriptConfiguration.md) | [日本語](../ja/ScriptConfiguration.md) | [简体中文](../zh/ScriptConfiguration.md)

# Guide de configuration du script PowerShell SwitchMoveCaptures

Ce guide explique comment configurer les paramètres dans le script `SwitchMoveCaptures.ps1`. Chaque option de configuration est documentée ci-dessous avec une description et un exemple.

---

## Configuration via l'interface graphique (Recommandée)

La plupart des utilisateurs devraient utiliser l'interface graphique (`SwitchMoveCapturesGUI.ps1`) pour configurer toutes les options, gérer les périphériques et configurer les notifications. L'interface graphique écrit les paramètres directement dans le script et le fichier de configuration des périphériques, et constitue le moyen le plus simple de maintenir votre configuration à jour.

---

## Plan de configuration
- [Webhook Discord](DiscordWebhook.md)
- [Webhook Slack](SlackWebhook.md)
- [Webhook Microsoft Teams](TeamsWebhook.md)
- [SMS via passerelle Email-vers-SMS](SmsGateway.md)
---



- [Dossier de destination principal (`$baseDestination`)](#dossier-de-destination-principal-basedestination)
- [Dossier de journaux (`$logFolder`)](#dossier-de-journaux-logfolder)
- [Supprimer après copie (`$deleteAfterCopy`)](#supprimer-après-copie-deleteaftercopy)
- [Nombre maximum de fichiers de journal (`$maxLogFiles`)](#nombre-maximum-de-fichiers-de-journal-maxlogfiles)
- [Organiser par jeu (`$organizeByGame`)](#organiser-par-jeu-organizebygame)
- [Sélection de périphérique (`$allowAllSwitchDevices`, `$allowedSwitchDevices`)](#sélection-de-périphérique-allowallswitchdevices-allowedswitchdevices)
- [Webhook Google Chat (`$enableGoogleChatNotification`, `$googleChatWebhookUrl`)](#webhook-google-chat-enablegooglechatnotification-googlechatwebhookurl)
- [Paramètres de notification par email (`$enableEmailNotification`, `$smtpServer`, `$smtpPort`, `$smtpUser`, `$smtpPassword`, `$emailFrom`, `$emailTo`, `$emailSubject`)](#paramètres-de-notification-par-email-enableemailnotification-smtpserver-smtpport-smtpuser-smtppassword-emailfrom-emailto-emailsubject)

---

## Dossier de destination principal (`$baseDestination`)
**Description :**
Le dossier racine où les captures de votre Switch seront sauvegardées. Chaque périphérique aura son propre sous-dossier.

**Exemple :**
```powershell
$baseDestination = "C:\Users\YourName\Pictures\SwitchCaptures"
```

---

## Dossier de journaux (`$logFolder`)
**Description :**
Le dossier où les fichiers de journal seront stockés.

**Exemple :**
```powershell
$logFolder = "C:\Users\YourName\Pictures\SwitchImportLogs"
```

---

## Supprimer après copie (`$deleteAfterCopy`)
**Description :**
Si défini sur `$true`, les fichiers seront supprimés de la Switch après avoir été copiés sur votre PC. Si `$false`, les fichiers resteront sur la Switch.

**Exemple :**
```powershell
$deleteAfterCopy = $true
```

---

## Nombre maximum de fichiers de journal (`$maxLogFiles`)
**Description :**
Le nombre maximum de fichiers de journal à conserver dans le dossier de journaux. Les journaux plus anciens seront supprimés automatiquement.

**Exemple :**
```powershell
$maxLogFiles = 30
```

---

## Organiser par jeu (`$organizeByGame`)
**Description :**
Si défini sur `$true`, les fichiers seront organisés dans des sous-dossiers par titre de jeu (basé sur la structure de dossiers sur la Switch). Si `$false`, tous les fichiers seront sauvegardés uniquement dans le dossier du périphérique.

**Exemple :**
```powershell
$organizeByGame = $true
```

---

---


## Gestion des périphériques (AllowedSwitchDevices.yaml)
**Description :**
La gestion des périphériques est gérée via le fichier `AllowedSwitchDevices.yaml`. La méthode recommandée pour gérer les périphériques est via l'interface graphique, qui permet d'ajouter, d'étiqueter et de supprimer des périphériques visuellement. Lorsqu'un périphérique Nintendo est détecté, le script tente de l'identifier par le numéro de série de sa carte SD. Si le périphérique est nouveau, l'utilisateur est invité à fournir une étiquette (obligatoire, peut inclure des espaces et des caractères spéciaux) et à confirmer s'il faut importer des fichiers depuis le périphérique. L'étiquette et le numéro de série sont ensuite stockés dans `AllowedSwitchDevices.yaml` pour une utilisation future.

**Comment cela fonctionne :**
- Lorsqu'un nouveau périphérique est détecté, vous devez entrer une étiquette non vide si vous choisissez d'importer des fichiers.
- L'étiquette est utilisée comme nom de dossier pour stocker les captures de ce périphérique.
- Tous les périphériques gérés sont listés sous la section `Devices` dans `AllowedSwitchDevices.yaml`.
- L'interface graphique fournit un onglet pour la gestion des périphériques.

**Exemple AllowedSwitchDevices.yaml :**
```yaml
# SwitchMoveCaptures External Configuration
# This file is used to store device-specific settings, including SD card serial numbers and user-set labels.
Devices:
  - Serial: "1234567890ABCDEF"
    Label: "Steve's Main Switch"
  - Serial: "0987654321FEDCBA"
    Label: "Kids' Switch"
```

**Remarque :**
- Il n'y a plus d'option pour autoriser tous les périphériques Switch ou pour spécifier les noms de périphériques autorisés dans le script. Toute la gestion des périphériques est gérée de manière interactive et stockée dans le fichier `AllowedSwitchDevices.yaml`, et est mieux gérée via l'interface graphique.


## Webhook Google Chat (`$enableGoogleChatNotification`, `$googleChatWebhookUrl`)
**Description :**
- `$enableGoogleChatNotification` : Si `$true`, les notifications seront envoyées à Google Chat en utilisant l'URL de webhook.
- `$googleChatWebhookUrl` : L'URL de webhook pour votre espace Google Chat.

**Exemple :**
```powershell
$enableGoogleChatNotification = $true
$googleChatWebhookUrl = "https://chat.googleapis.com/v1/spaces/AAA.../messages?key=..."
```

**Astuce :** Vous pouvez maintenant configurer les notifications Google Chat directement depuis l'interface graphique.

---

## Paramètres de notification par email (`$enableEmailNotification`, `$smtpServer`, `$smtpPort`, `$smtpUser`, `$smtpPassword`, `$emailFrom`, `$emailTo`, `$emailSubject`)
**Description :**
- `$enableEmailNotification` : Si `$true`, les notifications seront envoyées par email.
- `$smtpServer` : L'adresse du serveur SMTP.
- `$smtpPort` : Le port du serveur SMTP (généralement 587 pour TLS).
- `$smtpUser` : Le nom d'utilisateur pour l'authentification SMTP.
- `$smtpPassword` : Le mot de passe pour l'authentification SMTP.
- `$emailFrom` : L'adresse email de l'expéditeur.
- `$emailTo` : L'adresse email du destinataire.
- `$emailSubject` : La ligne d'objet pour les emails de notification.

**Exemple :**
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

**Astuce :** Vous pouvez maintenant configurer tous les paramètres de notification par email et SMS directement depuis l'interface graphique.

---


---

*Ces instructions sont à jour au 4 juillet 2025. L'interface graphique est la méthode recommandée pour configurer toutes les options pour la plupart des utilisateurs.*

---

## Fonctionnalité supplémentaire : Déduplication par hachage de fichier

**Description :**
Le script vérifie automatiquement les fichiers en double en utilisant les hachages SHA256. Si un fichier avec le même contenu existe déjà dans la destination (même si le nom de fichier est différent), il sera ignoré et ne sera pas copié à nouveau. Cela aide à prévenir l'importation de captures d'écran et de vidéos en double.

**Comment cela fonctionne :**
- Avant la copie, le script calcule un hachage pour chaque fichier dans la destination et le compare au hachage de chaque nouveau fichier.
- Si une correspondance est trouvée, le fichier est ignoré et une entrée de journal est faite.

Aucune configuration n'est nécessaire pour cette fonctionnalité ; elle est toujours activée.