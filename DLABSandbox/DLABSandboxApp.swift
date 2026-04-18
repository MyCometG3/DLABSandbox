//
//  DLABSandboxApp.swift
//  DLABSandbox
//
//  Created by Takashi Mochizuki on 2022/10/10.
//  Copyright © 2022 MyCometG3. All rights reserved.
//

import SwiftUI
import Cocoa

@main
struct DLABSandboxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var controller = DeviceController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
                .onAppear {
                    appDelegate.controller = controller
                }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    weak var controller: DeviceController?
    private var terminationInProgress = false

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard terminationInProgress == false else {
            return .terminateLater
        }
        guard let controller else {
            return .terminateNow
        }
        guard controller.requiresTerminationCleanup else {
            return .terminateNow
        }

        terminationInProgress = true
        Task { @MainActor in
            await controller.prepareForTermination()
            sender.reply(toApplicationShouldTerminate: true)
            terminationInProgress = false
        }
        return .terminateLater
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.windows.first?.isMovableByWindowBackground = true
    }
}
