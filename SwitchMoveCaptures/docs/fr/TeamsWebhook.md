[English](../en/TeamsWebhook.md) | [Français](../fr/TeamsWebhook.md) | [Español](../es/TeamsWebhook.md) | [Deutsch](../de/TeamsWebhook.md) | [日本語](../ja/TeamsWebhook.md) | [简体中文](../zh/TeamsWebhook.md)

# Comment créer un webhook Microsoft Teams


> **Astuce :** Vous pouvez maintenant configurer les notifications Microsoft Teams directement depuis l'interface graphique (`SwitchMoveCapturesGUI.ps1`).

Ce guide explique comment créer un webhook Microsoft Teams pour l'utiliser avec le système de notification SwitchMoveCaptures.

**Remarque :** Ces instructions sont à jour au 4 juillet 2025. Consultez la documentation officielle de Microsoft pour les mises à jour.

---

## Instructions étape par étape

1. Ouvrez Microsoft Teams et allez au canal où vous souhaitez recevoir les notifications.
2. Cliquez sur les trois points (...) à côté du nom du canal et sélectionnez **Connecteurs**.
3. Trouvez et ajoutez le connecteur **Webhook entrant**.
4. Nommez votre webhook (par exemple, "SwitchMoveCaptures Bot").
5. Optionnellement, définissez une image.
6. Copiez l'**URL de webhook**.
7. Collez cette URL dans votre configuration `SwitchMoveCaptures.ps1` comme valeur pour `$teamsWebhookUrl`.

---

## Référence
- [Documentation des webhooks Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook)

---

*Ces instructions sont à jour au 4 juillet 2025.*