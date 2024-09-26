# DLABSandbox

An example SwiftUI application using DLAB Swift Package.

### For DLAB package functionality verification

DLABSandbox runs on macOS Sandbox environment with TWO exception entitlements

    <key>com.apple.security.temporary-exception.mach-lookup.global-name</key>
    <string>com.blackmagic-design.desktopvideo.DeckLinkHardwareXPCService</string>
    <key>com.apple.security.temporary-exception.shared-preference.read-only</key>
    <string>com.blackmagic-design.desktopvideo.prefspanel</string>

- See: Blackmagic DeckLink SDK pdf Section 2.2.
- Ref: "Entitlement Key Reference/App Sandbox Temporary Exception Entitlements" from Apple Developer Documentation Archive

### Development environment

- macOS 15.0 Sequoia
- Xcode 16.0
- Swift 6.0

### License

- The MIT License
Copyright © 2022-2024年 MyCometG3. All rights reserved.
