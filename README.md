# DLABSandbox

An example SwiftUI application for verifying the DLAB Swift Package.

### DLABSandbox is the sample app for DLAB package functionality verification.

### Developer Notice
##### 1) AppEntitlements for Sandboxing

- DLABSandbox runs in the macOS sandbox environment with two exception entitlements.

    <key>com.apple.security.temporary-exception.mach-lookup.global-name</key>
    <string>com.blackmagic-design.desktopvideo.DeckLinkHardwareXPCService</string>
    <key>com.apple.security.temporary-exception.shared-preference.read-only</key>
    <string>com.blackmagic-design.desktopvideo.prefspanel</string>

- See: Blackmagic DeckLink SDK pdf Section 2.2.
- Ref: "Entitlement Key Reference/App Sandbox Temporary Exception Entitlements" from Apple Developer Documentation Archive

##### 2) AppEntitlements for Hardened Runtime

- Set com.apple.security.cs.disable-library-validation to YES.
- Ref: "Documentation/Bundle Resources/Entitlements/Hardened Runtime/Disable Library Validation Entitlement" from Apple Developer Documentation.

##### 3) SDK verification

- Verified with Blackmagic DeckLink SDK **16.0**.

#### Development environment
- macOS 26.4.1 Tahoe
- Xcode 26.4.1
- Swift 6.3.1

#### License
- The MIT License

Copyright © 2022-2026年 MyCometG3. All rights reserved.
