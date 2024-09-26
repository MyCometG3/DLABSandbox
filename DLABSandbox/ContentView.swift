//
//  ContentView.swift
//  DLABSandbox
//
//  Created by Takashi Mochizuki on 2022/10/10.
//  Copyright © 2022 MyCometG3. All rights reserved.
//

import SwiftUI

import Cocoa
import DLABCapture

struct ContentView: View {
    @EnvironmentObject var controller :DeviceController
        
    var body: some View {
        VStack {
            ParentView()
                .frame(minWidth: 640, idealWidth: 853.33, maxWidth: 1920,
                       minHeight: 360, idealHeight: 480, maxHeight: 1080)
                .padding()
                .environmentObject(controller)
            HStack {
                VStack {
                    HStack {
                        let pickerMode = Picker("", selection: $controller.modeSelectedIndex) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                            Text("3").tag(3)
                            Text("4").tag(4)
                        }
                        .controlSize(.small)
                        .pickerStyle(SegmentedPickerStyle())
                        .disabled(controller.running)
                        if #available(macOS 14.0, *) {
                            pickerMode.onChange(of: controller.modeSelectedIndex) { _, newValue in
                                controller.selectPreset(newPreset: newValue)
                            }
                        } else {
                            pickerMode.onChange(of: controller.modeSelectedIndex) { newValue in
                                controller.selectPreset(newPreset: newValue)
                            }
                        }

                        let pickerLayout = Picker("", selection: $controller.layoutSelectedIndex) {
                            Text("N/A").tag(0)
                            Text("C").tag(1)
                            Text("L R").tag(2)
                            Text("L R C").tag(3)
                            Text("5.1ch").tag(6)
                            Text("7.1ch").tag(8)
                        }
                        .controlSize(.small)
                        .pickerStyle(SegmentedPickerStyle())
                        .disabled(controller.running)
                        if #available(macOS 14.0, *) {
                            pickerLayout.onChange(of: controller.layoutSelectedIndex) { _, newValue in
                                controller.selectLayout(newLayout: newValue)
                            }
                        } else {
                            pickerLayout.onChange(of: controller.layoutSelectedIndex) { newValue in
                                controller.selectLayout(newLayout: newValue)
                            }
                        }
                    }
                    
                    HStack {
                        Text("preset:").font(.footnote)
                        Text(controller.presetLabel.rawValue).font(.footnote)
                        Text("layout:").font(.footnote)
                        Text(controller.layoutLabel.rawValue).font(.footnote)
                    }
                }
                
                VStack {
                    HStack {
                        let toggleRunning = Toggle(isOn: $controller.running) {
                            Label("Capture", systemImage: "power.circle").font(.headline)
                        }
                        .toggleStyle(.button)
                        if #available(macOS 14.0, *) {
                            toggleRunning.onChange(of: controller.running) {
                                controller.toggleRunning()
                            }
                        } else {
                            toggleRunning.onChange(of: controller.running) { _ in
                                controller.toggleRunning()
                            }
                        }
                        
                        let toggleRecording = Toggle(isOn: $controller.recording) {
                            Label("Record", systemImage: "record.circle").font(.headline)
                        }
                        .toggleStyle(.button)
                        .disabled(controller.running == false)
                        if #available(macOS 14.0, *) {
                            toggleRecording.onChange(of: controller.recording) {
                                controller.toggleRecording()
                            }
                        } else {
                            toggleRecording.onChange(of: controller.recording) { _ in
                                controller.toggleRecording()
                            }
                        }
                    }
                    HStack {
                        Text("model:").font(.footnote)
                        Text(controller.displayName).font(.footnote)
                    }
                }
            }
            .frame(width:580)
        }
        .padding()
    }
}

struct ParentView: NSViewRepresentable {
    @EnvironmentObject var controller :DeviceController

    typealias NSViewType = CaptureVideoPreview

    func makeNSView(context: Context) -> DLABCapture.CaptureVideoPreview {
        let vPreview = CaptureVideoPreview()
        
        controller.registerPreview(parentView: vPreview)
        controller.updateViewState()
        
        return vPreview
    }
    
    func updateNSView(_ nsView: CaptureVideoPreview, context: Context) {
        nsView.needsLayout = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DeviceController())
    }
}

