//
//  DLABSandboxApp.swift
//  DLABSandbox
//
//  Created by Takashi Mochizuki on 2022/10/10.
//  Copyright © 2022 MyCometG3. All rights reserved.
//

import SwiftUI

@main
struct DLABSandboxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var controller = DeviceController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
        }
    }
}

import Cocoa
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.first?.isMovableByWindowBackground = true
    }
}
