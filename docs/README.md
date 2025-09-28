# Documentation — SwitchMoveCaptures

This folder contains the user-facing documentation for SwitchMoveCaptures (usage, automation, webhooks, and configuration). The repository root `README.md` contains the project overview, license, and release artifacts; this `docs/` folder is the user manual.

## Quick start
- Preview a page in VS Code: open the file and press Ctrl+Shift+V (or right-click → Open Preview).
- To run the GUI locally for testing:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\SwitchMoveCapturesGUI.ps1
```

## Important pages
- [Script configuration](ScriptConfiguration.md)
- [Automatically run on USB connect](AutoRunOnUSB.md)
- [Connect Switch via USB](ConnectSwitchViaUSB.md)
- Webhook examples: [Discord](DiscordWebhook.md), [Slack](SlackWebhook.md), [Google Chat](GoogleChatWebhook.md), [Teams](TeamsWebhook.md), [SMS gateway](SmsGateway.md)

## Notes
- These files are the canonical English documentation for the project. Localized copies were archived to `docs/_locales_backup/`.
- If you need to reference general project metadata (license, installer, changelog), see the repository root: [Project README](../README.md)

## Contributing
- Edit the Markdown files in this folder. Keep links relative (e.g., `ScriptConfiguration.md`) so they render correctly on GitHub.
- Place images and assets under `docs/images/` and reference them as `images/diagram.png`.

## Want this to be a website?
- If you plan to publish the docs (GitHub Pages, Docsify, MkDocs), I can add a small `mkdocs.yml` or Docsify index and a build script.

*Last updated: September 28, 2025.*
