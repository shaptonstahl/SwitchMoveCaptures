# How to Create a Slack Webhook


> **Tip:** You can now configure Slack notifications directly from the GUI (`SwitchMoveCapturesGUI.ps1`).

This guide explains how to create a Slack webhook for use with the SwitchMoveCaptures notification system.

**Note:** These instructions are current as of July 4, 2025. Refer to the official Slack documentation for updates.

---

## Step-by-Step Instructions

1. Go to [Slack API: Incoming Webhooks](https://api.slack.com/messaging/webhooks) and sign in.
2. Click **Create an app** and select **From scratch**.
3. Name your app and select your workspace.
4. Under **Add features and functionality**, select **Incoming Webhooks**.
5. Activate **Incoming Webhooks**.
6. Click **Add New Webhook to Workspace** and select the channel.
7. Copy the generated **Webhook URL**.
8. Paste this URL into your `SwitchMoveCaptures.ps1` configuration as the value for `$slackWebhookUrl`.

---

## Reference
- [Slack Webhooks Documentation](https://api.slack.com/messaging/webhooks)

---

*These instructions are current as of July 4, 2025.*
