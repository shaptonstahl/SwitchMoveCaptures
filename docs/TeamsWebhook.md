# English Documentation

# How to Create a Microsoft Teams Webhook


> **Tip:** You can now configure Microsoft Teams notifications directly from the GUI (`SwitchMoveCapturesGUI.ps1`).

This guide explains how to create a Microsoft Teams webhook for use with the SwitchMoveCaptures notification system.

**Note:** These instructions are current as of July 4, 2025. Refer to the official Microsoft documentation for updates.

---

## Step-by-Step Instructions

1. Open Microsoft Teams and go to the channel where you want notifications.
2. Click the three dots (...) next to the channel name and select **Connectors**.
3. Find and add the **Incoming Webhook** connector.
4. Name your webhook (e.g., "SwitchMoveCaptures Bot").
5. Optionally, set an image.
6. Copy the **Webhook URL**.
7. Paste this URL into your `SwitchMoveCaptures.ps1` configuration as the value for `$teamsWebhookUrl`.

---

## Reference
- [Microsoft Teams Webhooks Documentation](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook)

---

*These instructions are current as of July 4, 2025.*
