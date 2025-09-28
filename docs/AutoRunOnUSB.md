# Automatically Run PowerShell Script When a USB Drive Connects on Windows

This guide explains how to configure Windows to automatically run the SwitchMoveCaptures PowerShell script when your Nintendo Switch (or any USB drive) is connected.

**Note:** These instructions are current as of July 4, 2025. Windows features and settings may change, so refer to official Microsoft documentation for the latest information.

---

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
- Adjust conditions as needed (for example, only run if the user is logged on).

### 7. Save the Task
- Click **OK** to save the task.

---

## Notes

- You may need to adjust execution policy or script permissions to allow the script to run. Running the task as a user with appropriate permissions and using `-ExecutionPolicy Bypass` in the action usually resolves this.
- This trigger will fire for any USB device. The `SwitchMoveCaptures` script supports filtering by device serial and label; configure the device list in the GUI or the device YAML before enabling automation.
- For configuration details (organizing by game, filtering screenshots/videos, deduplication), see [ScriptConfiguration.md](ScriptConfiguration.md).
- Tip: Run and test the script manually (or with the GUI `SwitchMoveCapturesGUI.ps1`) to confirm behavior before attaching it to an automated task.

## References

- [Microsoft Docs: Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page)
- [Event ID 2003 Reference](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-triggers)

---

*These instructions are current as of July 4, 2025.*
