[English](../en/SlackWebhook.md) | [Français](../fr/SlackWebhook.md) | [Español](../es/SlackWebhook.md) | [Deutsch](../de/SlackWebhook.md) | [日本語](../ja/SlackWebhook.md) | [简体中文](../zh/SlackWebhook.md)

# Comment créer un webhook Slack


> **Astuce :** Vous pouvez maintenant configurer les notifications Slack directement depuis l'interface graphique (`SwitchMoveCapturesGUI.ps1`).

Ce guide explique comment créer un webhook Slack pour l'utiliser avec le système de notification SwitchMoveCaptures.

**Remarque :** Ces instructions sont à jour au 4 juillet 2025. Consultez la documentation officielle de Slack pour les mises à jour.

---

## Instructions étape par étape

1. Allez sur [Slack API : Webhooks entrants](https://api.slack.com/messaging/webhooks) et connectez-vous.
2. Cliquez sur **Créer une app** et sélectionnez **À partir de zéro**.
3. Nommez votre app et sélectionnez votre espace de travail.
4. Sous **Ajouter des fonctionnalités**, sélectionnez **Webhooks entrants**.
5. Activez **Webhooks entrants**.
6. Cliquez sur **Ajouter un nouveau webhook à l'espace de travail** et sélectionnez le canal.
7. Copiez l'**URL de webhook** générée.
8. Collez cette URL dans votre configuration `SwitchMoveCaptures.ps1` comme valeur pour `$slackWebhookUrl`.

---

## Référence
- [Documentation des webhooks Slack](https://api.slack.com/messaging/webhooks)

---

*Ces instructions sont à jour au 4 juillet 2025.*