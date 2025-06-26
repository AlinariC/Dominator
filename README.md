# DominatorAgent

DominatorAgent is a lightweight Windows background service built with .NET 9. It
periodically reports basic system information to `https://example.com/checkin`.

## Building

1. Install the .NET 9 SDK.
2. Navigate to the `DominatorAgent` folder.
3. Run `dotnet publish -c Release -o publish`.

## Installation

An example `installer.nsi` script is provided for NSIS. After publishing the project, compile the installer script to create `DominatorAgentInstaller.exe`.

The installer copies the service files to `Program Files` and registers the service to start automatically on boot.

---

## DominatorRelay

DominatorRelay is a small Python Flask API that receives check-ins from Dominator agents.
See the [DominatorRelay](./DominatorRelay/README.md) directory for details on running it.

---

## DominatorManager

DominatorManager is a macOS SwiftUI app that lists all devices returned from `https://example.com/devices`.
Open `DominatorManager/DominatorManager.xcodeproj` in Xcode and run the app.
Use the **Refresh** button or pull to reload the device list.
