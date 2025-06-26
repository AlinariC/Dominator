# DominatorAgent

DominatorAgent is a lightweight Windows background service built with .NET 9.
It exposes a small HTTP API on port `5000` that returns basic system
information. Agents are meant to be reached directly over TailScale so no
central relay server is required.

## Building

1. Install the .NET 9 SDK.
2. Navigate to the `DominatorAgent` folder.
3. Run `dotnet publish -c Release -o publish`.

## Installation

An example `installer.nsi` script is provided for NSIS. After publishing the project, compile the installer script to create `DominatorAgentInstaller.exe`.

The installer copies the service files to `Program Files` and registers the service to start automatically on boot.

---

## DominatorRelay (removed)

The old Python relay component has been removed. Agents now expose their own
HTTP endpoint that the manager queries directly via TailScale.

---

## DominatorManager

DominatorManager is a macOS SwiftUI app that lists devices by directly
requesting each agent over TailScale. Set the environment variable
`AGENT_HOSTS` to a comma separated list of agent URLs (for example
`http://100.x.x.x:5000`). Open `DominatorManager/DominatorManager.xcodeproj`
in Xcode and run the app. Use the **Refresh** button or pull to reload the
device list.
