
[English](../en/AutoRunOnUSB.md) | [Français](../fr/AutoRunOnUSB.md) | [Español](../es/AutoRunOnUSB.md) | [Deutsch](../de/AutoRunOnUSB.md) | [日本語](../ja/AutoRunOnUSB.md) | [简体中文](../zh/AutoRunOnUSB.md)

# Automatically Run PowerShell Script When a USB Drive Connects on Windows

This guide explains how to configure Windows to automatically run the SwitchMoveCaptures PowerShell script when your Nintendo Switch (or any USB drive) is connected.

**Note:** These instructions are current as of July 4, 2025. Windows features and settings may change, so refer to official Microsoft documentation for the latest information.

---

## Method 1: Using Task Scheduler

### 1. Open Task Scheduler
- Press `Win + S` and search for **Task Scheduler**. Open it.

### 2. Create a New Task
- In the right pane, click **Create Task**.

### 3. General Tab
- Name your task (e.g., "Run SwitchMoveCaptures on USB Connect").
- Set it to run with highest privileges.

### 4. Triggers Tab
- Click **New...**
- Set **Begin the task** to **On an event**.
- Set **Log** to `Microsoft-Windows-DriverFrameworks-UserMode/Operational`.
- Set **Source** to `UserModeDriverFrameworks-UserMode`.
- Set **Event ID** to `2003` (this event is triggered when a device is connected).
- Click **OK**.

### 5. Actions Tab
- Click **New...**
- Set **Action** to **Start a program**.
- In **Program/script**, enter:
  ```
  powershell.exe
  ```
- In **Add arguments (optional)**, enter:
  ```
  -ExecutionPolicy Bypass -File "C:\Path\To\SwitchMoveCaptures\scripts\SwitchMoveCaptures.ps1"
  ```
- Click **OK**.

### 6. Conditions and Settings
- Adjust as needed (e.g., only run if user is logged in).

### 7. Save the Task
- Click **OK** to save.

---

## Notes
- You may need to adjust permissions or execution policy to allow the script to run.
- This method will trigger on any USB device. The SwitchMoveCaptures script supports filtering by device serial and label, so you can configure it to only import from specific Switch devices (see device management in the GUI or [docs/ScriptConfiguration.md](ScriptConfiguration.md)).
- The script also supports advanced filtering by file type (screenshots or videos), game-based organization, and deduplication by file hash. See [docs/ScriptConfiguration.md](ScriptConfiguration.md) for details on these features and how to configure them.
- **Tip:** Use the GUI (`SwitchMoveCapturesGUI.ps1`) to configure all options and manage devices before automating the import process.

## References
- [Microsoft Docs: Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page)
- [Event ID 2003 Reference](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-triggers)

---

*These instructions are current as of July 4, 2025.*
