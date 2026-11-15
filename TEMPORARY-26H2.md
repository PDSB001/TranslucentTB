# Unofficial temporary TranslucentTB build for Windows 11 26H2

This is a community compatibility build, not an official TranslucentTB release. All credit for TranslucentTB belongs to its original authors. Please support the [upstream project](https://github.com/TranslucentTB/TranslucentTB).

**When the original authors release an update that fixes this issue, we recommend uninstalling this temporary version and returning to the official version.** Do not run both versions at the same time.

## Scope

Packages Charles Milette's existing, unreleased [upstream fix b8716c1](https://github.com/TranslucentTB/TranslucentTB/commit/b8716c1207037013515a289c365918cb4aea109e) on top of the official 2026.2 portable release. The compatibility fix is the original author's work.

Fixes the case where TranslucentTB starts successfully but taskbar effects do not apply because `TaskbarFrame` is itself the `DesktopWindowXamlSource.Content`. The old code assumed the content was the frame's immediate parent. The upstream patch compares the source content to `TaskbarFrame.XamlRoot().Content()`.

This does not claim to fix every 26H2 problem, including all XAML Diagnostics initialization failures, Explorer crashes, or taskbar-position changes.

## Download and use (x64 only)

Download `TranslucentTB-UNOFFICIAL-26H2-portable-x64.zip` from [this fork's releases](https://github.com/PDSB001/TranslucentTB/releases). Verify its SHA-256 against the release's `SHA256SUMS.txt`.

1. Exit the official TranslucentTB from its tray menu. Disable its automatic startup while trying this build. Back up your settings if needed.
2. Restart Windows before switching builds: Explorer keeps the previously loaded helper DLL in memory even after the app exits.
3. Extract the ZIP to a dedicated folder and run `TranslucentTB.exe` normally. No administrator rights or certificate installation is required.
4. Start with the Desktop appearance set to Clear. Dynamic appearance rules can override it.

Only `ExplorerTAP.dll` is rebuilt. The remaining application files come unchanged from the official 2026.2 portable x64 package. The replacement DLL is unsigned; the build does not use or claim the upstream signing identity. Complete corresponding source is available in this fork at the commit recorded in `SOURCE.txt`, including the build workflow. The upstream GPLv3 license is included.

## Uninstall and return to the official version

1. Exit this temporary build from the tray menu and remove any startup shortcut you created for it.
2. Restart Windows so Explorer unloads its helper DLL.
3. Delete this portable build's extracted folder, then install or re-enable the updated official TranslucentTB. This portable build has no separate entry in Installed apps.

## Validation and limits

- Reproduced the changed visual tree on Windows 11 26H2 Insider build 26340.9882, x64, one monitor.
- An instrumented diagnostic build identified `TaskbarFrame` as the source content. Clear, opaque, and acrylic replaced the actual background Fill; blur and border operations succeeded; restoring the default restored the original Fill object.
- The test machine has Windhawk taskbar modifications installed. It is not a clean Windows installation.
- Multiple monitors, ARM64, older Windows builds, taskbar relocation, sleep/resume, and long-running use have not been verified. Please do not treat this as full compatibility certification.
- Temporary diagnostic logging is excluded from the published patch and DLL.

For problems with this temporary build, report them in [this fork](https://github.com/PDSB001/TranslucentTB/issues), with the exact Windows build and reproduction steps. Avoid posting private log contents publicly.

## Reproduce the build

The `.github/workflows/temporary-26h2.yml` workflow restores the pinned upstream NuGet/vcpkg dependencies, builds only ExplorerTAP in Release x64 with the upstream compiler protections, verifies the official base ZIP's SHA-256, and replaces its helper DLL. It uploads the ZIP, its checksum, and matching PDB symbols as a workflow artifact. No signing secrets are used.
