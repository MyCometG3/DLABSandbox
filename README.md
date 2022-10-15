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

- macOS 12.6 Monterey
- Xcode 14.0.1
- Swift 5.7.0

### License

- The MIT License
Copyright © 2022年 MyCometG3. All rights reserved.

