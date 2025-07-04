[English](../en/SmsGateway.md) | [Français](../fr/SmsGateway.md) | [Español](../es/SmsGateway.md) | [Deutsch](../de/SmsGateway.md) | [日本語](../ja/SmsGateway.md) | [简体中文](../zh/SmsGateway.md)

# Comment envoyer des notifications SMS via une passerelle Email-vers-SMS


> **Astuce :** Vous pouvez maintenant configurer les notifications SMS directement depuis l'interface graphique (`SwitchMoveCapturesGUI.ps1`).

Ce guide explique comment configurer les notifications SMS en utilisant la passerelle email-vers-SMS de votre opérateur avec le système de notification SwitchMoveCaptures.

**Remarque :** Ces instructions sont à jour au 4 juillet 2025. Vérifiez auprès de votre opérateur pour les dernières adresses de passerelle et exigences.

---

## Instructions étape par étape

1. Trouvez l'adresse de la passerelle email-vers-SMS de votre opérateur. Exemples courants :
   - AT&T : `number@txt.att.net`
   - Verizon : `number@vtext.com`
   - T-Mobile : `number@tmomail.net`
   - (Consultez le site web de votre opérateur pour les détails)
2. Dans votre configuration `SwitchMoveCaptures.ps1`, définissez :
   - `$enableSmsNotification = $true`
   - `$smsTo = "1234567890@txt.att.net"` (remplacez par votre numéro et opérateur)
   - `$smsFrom = "your@email.com"`
3. Assurez-vous que vos paramètres SMTP sont corrects et permettent l'envoi vers des adresses externes.

---

## Référence
- [Wikipedia : Liste des passerelles SMS](https://en.wikipedia.org/wiki/SMS_gateway#Email_clients)

---

*Ces instructions sont à jour au 4 juillet 2025.*