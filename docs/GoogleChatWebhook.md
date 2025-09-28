# How to Create a Google Chat Webhook

> **Tip:** You can now configure Google Chat notifications directly from the GUI (`SwitchMoveCapturesGUI.ps1`).

This guide explains how to create a Google Chat webhook for use with the SwitchMoveCaptures notification system.

**Note:** These instructions are current as of [Google's documentation on incoming webhooks](https://developers.google.com/chat/how-tos/webhooks) (accessed July 4, 2025). Please refer to the official documentation for the latest updates.

---

## Step-by-Step Instructions

### 1. Open Google Chat

- Go to [Google Chat](https://chat.google.com/) and sign in with your Google account.

### 2. Select or Create a Space

- In the left sidebar, select the space (room) where you want to receive notifications.
- If you don’t have a space, click the "+" button next to "Spaces" and create a new one.

### 3. Manage Webhooks

- In the space, click the space name at the top.
- Select **Manage webhooks** from the dropdown menu.

### 4. Add an Incoming Webhook

- Click **Add webhook**.
- Enter a name for your webhook (e.g., "SwitchMoveCaptures Notifications").
- Optionally, add an avatar URL for the bot.
- Click **Save**.

### 5. Copy the Webhook URL

- After saving, a webhook URL will be generated.
- Copy this URL. You will need to paste it into your `SwitchMoveCaptures.ps1` configuration as the value for `$googleChatWebhookUrl`.

---

## Reference

- [Google Chat Webhooks Documentation](https://developers.google.com/chat/how-tos/webhooks)

---

*These instructions are current as of July 4, 2025, based on the official Google documentation linked above.*
