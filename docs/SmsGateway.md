# How to Send SMS Notifications via Email-to-SMS Gateway


> **Tip:** You can now configure SMS notifications directly from the GUI (`SwitchMoveCapturesGUI.ps1`).

This guide explains how to configure SMS notifications using your carrier's email-to-SMS gateway with the SwitchMoveCaptures notification system.

**Note:** These instructions are current as of July 4, 2025. Check with your carrier for the latest gateway addresses and requirements.

---

## Step-by-Step Instructions

1. Find your carrier's email-to-SMS gateway address. Common examples:
   - AT&T: `number@txt.att.net`
   - Verizon: `number@vtext.com`
   - T-Mobile: `number@tmomail.net`
   - (Check your carrier's website for details)
2. In your `SwitchMoveCaptures.ps1` configuration, set:
   - `$enableSmsNotification = $true`
   - `$smsTo = "1234567890@txt.att.net"` (replace with your number and carrier)
   - `$smsFrom = "your@email.com"`
3. Make sure your SMTP settings are correct and allow sending to external addresses.

---

## Reference
- [Wikipedia: List of SMS Gateways](https://en.wikipedia.org/wiki/SMS_gateway#Email_clients)

---

*These instructions are current as of July 4, 2025.*
