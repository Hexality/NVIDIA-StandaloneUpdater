# NVIDIA-StandaloneUpdater
Auto-updates your NVIDIA Drivers to the latest version every 2 weeks (or whenever you want) (if available)

In order to make it work, put the folder `nvidiaUpdater` on the root of your main drive (C:) then create a task on Task Scheduler with the interval you want. with this in the `Actions` tab:

![image](https://user-images.githubusercontent.com/17398632/212580391-e7680d1b-bbf7-451b-9553-0a399f098d79.png) 
- Program: `conhost`
- Add Arguments: `pwsh -windowstyle hidden -executionpolicy bypass -file updater.ps1`
- Start in: `C:\nvidiaUpdater`
