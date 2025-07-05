[English](../en/GoogleChatWebhook.md) | [Français](../fr/GoogleChatWebhook.md) | [Español](../es/GoogleChatWebhook.md) | [Deutsch](../de/GoogleChatWebhook.md) | [日本語](../ja/GoogleChatWebhook.md) | [简体中文](../zh/GoogleChatWebhook.md)

# Comment créer un webhook Google Chat


> **Astuce :** Vous pouvez maintenant configurer les notifications Google Chat directement depuis l'interface graphique (`SwitchMoveCapturesGUI.ps1`).

Ce guide explique comment créer un webhook Google Chat pour l'utiliser avec le système de notification SwitchMoveCaptures.

**Remarque :** Ces instructions sont à jour selon la [documentation de Google sur les webhooks entrants](https://developers.google.com/chat/how-tos/webhooks) (consultée le 4 juillet 2025). Veuillez vous référer à la documentation officielle pour les dernières mises à jour.

---

## Instructions étape par étape

### 1. Ouvrir Google Chat

- Allez sur [Google Chat](https://chat.google.com/) et connectez-vous avec votre compte Google.

### 2. Sélectionner ou créer un espace

- Dans la barre latérale gauche, sélectionnez l'espace (salon) où vous souhaitez recevoir les notifications.
- Si vous n'avez pas d'espace, cliquez sur le bouton "+" à côté de "Espaces" et créez-en un nouveau.

### 3. Gérer les webhooks

- Dans l'espace, cliquez sur le nom de l'espace en haut.
- Sélectionnez **Gérer les webhooks** dans le menu déroulant.

### 4. Ajouter un webhook entrant

- Cliquez sur **Ajouter un webhook**.
- Entrez un nom pour votre webhook (par exemple, "Notifications SwitchMoveCaptures").
- Optionnellement, ajoutez une URL d'avatar pour le bot.
- Cliquez sur **Enregistrer**.

### 5. Copier l'URL du webhook

- Après l'enregistrement, une URL de webhook sera générée.
- Copiez cette URL. Vous devrez la coller dans votre configuration `SwitchMoveCaptures.ps1` comme valeur pour `$googleChatWebhookUrl`.

---

## Référence

- [Documentation des webhooks Google Chat](https://developers.google.com/chat/how-tos/webhooks)

---

*Ces instructions sont à jour au 4 juillet 2025, basées sur la documentation officielle de Google liée ci-dessus.*