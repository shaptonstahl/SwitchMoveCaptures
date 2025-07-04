
[English](../en/AutoRunOnUSB.md) | [Français](../fr/AutoRunOnUSB.md) | [Español](../es/AutoRunOnUSB.md) | [Deutsch](../de/AutoRunOnUSB.md) | [日本語](../ja/AutoRunOnUSB.md) | [简体中文](../zh/AutoRunOnUSB.md)

# Exécuter automatiquement un script PowerShell lors de la connexion d'une clé USB sur Windows

Ce guide explique comment configurer Windows pour exécuter automatiquement le script PowerShell SwitchMoveCaptures lorsque votre Nintendo Switch (ou toute clé USB) est connectée.

**Remarque :** Ces instructions sont à jour au 4 juillet 2025. Les fonctionnalités et paramètres de Windows peuvent changer, alors consultez la documentation officielle de Microsoft pour les informations les plus récentes.

---

## Méthode 1 : Utilisation du Planificateur de tâches

### 1. Ouvrir le Planificateur de tâches
- Appuyez sur `Win + S` et recherchez **Planificateur de tâches**. Ouvrez-le.

### 2. Créer une nouvelle tâche
- Dans le volet de droite, cliquez sur **Créer une tâche**.

### 3. Onglet Général
- Nommez votre tâche (par exemple, "Exécuter SwitchMoveCaptures lors de la connexion USB").
- Configurez-la pour s'exécuter avec les privilèges les plus élevés.

### 4. Onglet Déclencheurs
- Cliquez sur **Nouveau...**
- Définissez **Commencer la tâche** sur **Lors d'un événement**.
- Définissez **Journal** sur `Microsoft-Windows-DriverFrameworks-UserMode/Operational`.
- Définissez **Source** sur `UserModeDriverFrameworks-UserMode`.
- Définissez **ID d'événement** sur `2003` (cet événement est déclenché lorsqu'un périphérique est connecté).
- Cliquez sur **OK**.

### 5. Onglet Actions
- Cliquez sur **Nouveau...**
- Définissez **Action** sur **Démarrer un programme**.
- Dans **Programme/script**, entrez :
  ```
  powershell.exe
  ```
- Dans **Ajouter des arguments (facultatif)**, entrez :
  ```
  -ExecutionPolicy Bypass -File "C:\Path\To\SwitchMoveCaptures\scripts\SwitchMoveCaptures.ps1"
  ```
- Cliquez sur **OK**.

### 6. Conditions et Paramètres
- Ajustez selon vos besoins (par exemple, s'exécuter uniquement si l'utilisateur est connecté).

### 7. Enregistrer la tâche
- Cliquez sur **OK** pour enregistrer.

---

## Remarques
- Vous pourriez avoir besoin d'ajuster les permissions ou la politique d'exécution pour permettre au script de s'exécuter.
- Cette méthode se déclenchera sur n'importe quel périphérique USB. Le script SwitchMoveCaptures prend en charge le filtrage par numéro de série et étiquette de périphérique, vous pouvez donc le configurer pour importer uniquement depuis des périphériques Switch spécifiques (voir la gestion des périphériques dans l'interface graphique ou [docs/ScriptConfiguration.md](ScriptConfiguration.md)).
- Le script prend également en charge le filtrage avancé par type de fichier (captures d'écran ou vidéos), l'organisation basée sur les jeux, et la déduplication par hachage de fichier. Consultez [docs/ScriptConfiguration.md](ScriptConfiguration.md) pour plus de détails sur ces fonctionnalités et comment les configurer.
- **Astuce :** Utilisez l'interface graphique (`SwitchMoveCapturesGUI.ps1`) pour configurer toutes les options et gérer les périphériques avant d'automatiser le processus d'importation.

## Références
- [Microsoft Docs : Planificateur de tâches](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page)
- [Référence ID d'événement 2003](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-triggers)

---

*Ces instructions sont à jour au 4 juillet 2025.*