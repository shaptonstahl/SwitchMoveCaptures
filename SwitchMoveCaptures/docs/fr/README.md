
[English](../en/README.md) | [Français](../fr/README.md) | [Español](../es/README.md) | [Deutsch](../de/README.md) | [日本語](../ja/README.md) | [简体中文](../zh/README.md)

# SwitchMoveCaptures

Déplacez automatiquement les captures d'écran et vidéos de votre Nintendo Switch vers votre PC Windows.

## Vue d'ensemble

**SwitchMoveCaptures** est un outil open-source conçu pour aider les utilisateurs de Nintendo Switch à transférer facilement leurs captures d'écran et clips vidéo vers un PC Windows. Créé par Stephen Haptonstahl pour ses fils—de grands fans de Switch—ce projet vise à simplifier le processus d'organisation et de sauvegarde de vos moments de jeu favoris.

## Fonctionnalités

- Détecte et déplace automatiquement les nouvelles captures de votre Switch
- Prend en charge les captures d'écran et les clips vidéo
- Organise les fichiers par date ou par jeu (personnalisable)
- Script PowerShell facile à utiliser pour Windows

## Démarrage

1. Clonez ce dépôt :
    ```powershell
    git clone https://github.com/yourusername/SwitchMoveCaptures.git
    ```
2. Connectez la carte microSD de votre Nintendo Switch à votre PC.
   
   Vous pouvez le faire soit :
   - En retirant la carte microSD de votre Switch et en l'insérant dans votre PC, **ou**
   - En connectant votre Nintendo Switch directement à votre PC à l'aide d'un câble USB et en activant le mode de transfert de données sur la Switch. Consultez [docs/ConnectSwitchViaUSB.md](docs/ConnectSwitchViaUSB.md) pour des instructions étape par étape.


3. **Recommandé :** Exécutez l'interface graphique pour la configuration et l'importation manuelle :
    ```powershell
    cd SwitchMoveCaptures\scripts
    .\SwitchMoveCapturesGUI.ps1
    ```
   L'interface graphique vous permet de :
   - Configurer toutes les options du script (destination, dossier de journaux, types de fichiers, notifications, etc.)
   - Gérer les périphériques Switch autorisés et leurs étiquettes
   - Configurer et tester les notifications pour Google Chat, Discord, Slack, Teams, Email et SMS
   - Exécuter des importations manuellement et consulter les journaux

4. (Optionnel) Pour automatiser les importations, configurez le Planificateur de tâches Windows pour exécuter `SwitchMoveCaptures.ps1` lors de la connexion USB. Consultez [docs/AutoRunOnUSB.md](docs/AutoRunOnUSB.md).

5. (Optionnel) Pour activer les notifications, vous pouvez également suivre les instructions dans le dossier docs pour votre canal préféré, mais l'interface graphique est la méthode recommandée pour configurer les notifications :
   - [Google Chat](docs/GoogleChatWebhook.md)
   - [Discord](docs/DiscordWebhook.md)
   - [Slack](docs/SlackWebhook.md)
   - [Microsoft Teams](docs/TeamsWebhook.md)
   - [SMS via passerelle Email-vers-SMS](docs/SmsGateway.md)

   Après avoir configuré votre webhook ou passerelle SMS, vous pouvez utiliser l'interface graphique pour mettre à jour votre configuration, ou modifier le script directement comme décrit dans [docs/ScriptConfiguration.md](docs/ScriptConfiguration.md).


## Exigences

- Windows 10 (Version 1809 ou ultérieure) ou Windows 11
  - La plupart des fonctionnalités nécessitent Windows 10 October 2018 Update (1809) ou plus récent. Windows 11 est entièrement pris en charge.
  - Si vous utilisez une version plus ancienne, mettez à jour Windows via **Paramètres > Mise à jour et sécurité > Windows Update**.
- PowerShell 5.1 ou ultérieur
  - PowerShell 5.1 est inclus avec Windows 10 et 11 par défaut.
  - Pour une meilleure compatibilité et le support YAML, installez **PowerShell 7+** (aussi appelé "PowerShell Core").
    - Téléchargez depuis : https://github.com/PowerShell/PowerShell/releases
    - Ou installez via Microsoft Store (recherchez "PowerShell 7").
- Pour la gestion des périphériques YAML (édition avancée de la configuration des périphériques) :
  - PowerShell 7+ inclut le support YAML intégré (`ConvertFrom-Yaml` et `ConvertTo-Yaml`).
  - Si vous utilisez PowerShell 5.1, installez le module **Import-Yaml** :
    ```powershell
    Install-Module -Name powershell-yaml -Scope CurrentUser
    ```
  - La plupart des utilisateurs n'ont pas besoin d'éditer le YAML manuellement ; l'interface graphique gère la gestion des périphériques automatiquement.

## Langues de documentation

- [English](docs/en/README.md)
- [Español](docs/es/README.md)
- [Français](docs/fr/README.md)
- [Deutsch](docs/de/README.md)
- [日本語](docs/ja/README.md)
- [简体中文](docs/zh/README.md)

## Contribution

Les contributions sont les bienvenues ! Veuillez ouvrir une issue ou soumettre une pull request.

## Licence

Ce projet est sous licence MIT. Consultez le fichier [LICENSE](LICENSE) pour plus de détails.

---

Créé par Stephen Haptonstahl pour ses fils.

---

## Note de fiabilité

Ce projet a été écrit avec une approche de "programmation à l'instinct". Chaque version a été légèrement testée avec une configuration réelle Nintendo Switch et PC Windows, mais n'a pas été soumise à des tests rigoureux ou automatisés. Toute personne utilisant ce script devrait effectuer ses propres tests de base avant de s'y fier pour des fichiers importants. Vous pourriez également souhaiter qu'une autre IA ou développeur examine le code pour la sécurité et la fiabilité.

---

## Interface graphique vs. Script

**L'interface graphique (`SwitchMoveCapturesGUI.ps1`) est la méthode recommandée pour configurer et utiliser ce projet pour la plupart des utilisateurs.**
Toute la configuration, la gestion des périphériques et la configuration des notifications peuvent être effectuées visuellement. Les utilisateurs avancés peuvent encore modifier `SwitchMoveCaptures.ps1` et `AllowedSwitchDevices.yaml` directement si nécessaire.