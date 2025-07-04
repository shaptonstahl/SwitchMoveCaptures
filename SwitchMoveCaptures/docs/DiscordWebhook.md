# How to Create a Discord Webhook


> **Tip:** You can now configure Discord notifications directly from the GUI (`SwitchMoveCapturesGUI.ps1`).

This guide explains how to create a Discord webhook for use with the SwitchMoveCaptures notification system.

**Note:** These instructions are current as of July 4, 2025. Refer to the official Discord documentation for updates.

---

## Step-by-Step Instructions

1. Open Discord and go to your server.
2. Click the gear icon next to the channel where you want notifications.
3. Select **Integrations** > **Webhooks** > **New Webhook**.
4. Name your webhook (e.g., "SwitchMoveCaptures Bot").
5. Optionally, set an avatar.
6. Copy the **Webhook URL**.
7. Paste this URL into your `SwitchMoveCaptures.ps1` configuration as the value for `$discordWebhookUrl`.

---

## Reference
- [Discord Webhooks Documentation](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)

---

*These instructions are current as of July 4, 2025.*
