[English](../en/DiscordWebhook.md) | [Français](../fr/DiscordWebhook.md) | [Español](../es/DiscordWebhook.md) | [Deutsch](../de/DiscordWebhook.md) | [日本語](../ja/DiscordWebhook.md) | [简体中文](../zh/DiscordWebhook.md)

# Comment créer un webhook Discord


> **Astuce :** Vous pouvez maintenant configurer les notifications Discord directement depuis l'interface graphique (`SwitchMoveCapturesGUI.ps1`).

Ce guide explique comment créer un webhook Discord pour l'utiliser avec le système de notification SwitchMoveCaptures.

**Remarque :** Ces instructions sont à jour au 4 juillet 2025. Consultez la documentation officielle de Discord pour les mises à jour.

---

## Instructions étape par étape

1. Ouvrez Discord et allez sur votre serveur.
2. Cliquez sur l'icône d'engrenage à côté du canal où vous souhaitez recevoir les notifications.
3. Sélectionnez **Intégrations** > **Webhooks** > **Nouveau webhook**.
4. Nommez votre webhook (par exemple, "SwitchMoveCaptures Bot").
5. Optionnellement, définissez un avatar.
6. Copiez l'**URL du webhook**.
7. Collez cette URL dans votre configuration `SwitchMoveCaptures.ps1` comme valeur pour `$discordWebhookUrl`.

---

## Référence
- [Documentation des webhooks Discord](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)

---

*Ces instructions sont à jour au 4 juillet 2025.*