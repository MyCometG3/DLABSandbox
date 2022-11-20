//
//  DeviceController.swift
//  DLABSandbox
//
//  Created by Takashi Mochizuki on 2022/10/14.
//  Copyright © 2022 MyCometG3. All rights reserved.
//

import Cocoa
import DLABCore
import DLABCapture
import Dispatch

let undefinedLabel :String = "Undefined"

enum Preset :String {
    case preset0 = "0:HD_1080i_HDMI"
    case preset1 = "1:HD_720p_HDMI_RCA"
    case preset2 = "2:SD_NTSC_HDMI_RCA"
    case preset3 = "3:SD_NTSC_SVideo_RCA"
    case preset4 = "4:SD_NTSC_Composite_RCA"
    case undefined = "Undefined"
}

enum Layout :String {
    case layout0 = "0:Stereo"
    case layout1 = "1:C"
    case layout2 = "2:L R"
    case layout3 = "3:L R C"
    case layout6 = "6:5.1ch"
    case layout8 = "8:7.1ch"
    case undefined = "Undefined"
}

class DeviceController :ObservableObject {
    
    // Clean Aperture offset
    let applySDOffset :Bool = true
    let sdOffset :NSPoint = NSPoint(x: 4, y: 0)
    
    // HDMI AudioChannelLayout
    var applyLayout :Bool = true
    
    // CaptureManager
    var manager :DLABCapture.CaptureManager? = nil
    var vPreview :CaptureVideoPreview? = nil
    var config :ConfigSet = ConfigSet(preset: .undefined)
    
    // View Binding
    @Published var modeSelectedIndex = 0
    @Published var displayName :String = undefinedLabel
    @Published var running :Bool = false
    @Published var recording : Bool = false
    @Published var presetLabel :Preset = .undefined
    @Published var layoutSelectedIndex = 6
    @Published var layoutLabel :Layout = .undefined
    @Published var reverse34 : Bool = true
    
    // Preset selection
    func selectPreset(newPreset :Int) {
        // Update preset label per selection
        switch newPreset {
        case 0: presetLabel = .preset0
        case 1: presetLabel = .preset1
        case 2: presetLabel = .preset2
        case 3: presetLabel = .preset3
        case 4: presetLabel = .preset4
        default: presetLabel = .undefined
        }
    }
    
    // Layout selection
    func selectLayout(newLayout :Int) {
        // Update layout
        switch newLayout {
        case 0: layoutLabel = .layout0
        case 1: layoutLabel = .layout1
        case 2: layoutLabel = .layout2
        case 3: layoutLabel = .layout3
        case 6: layoutLabel = .layout6
        case 8: layoutLabel = .layout8
        default: layoutLabel = .undefined
        }
    }
    
    // Lazy View state adjustment using Binding
    func updateViewState() {
        DispatchQueue.main.async {
            if let manager = self.manager {
                self.running = manager.running
                self.recording = manager.recording
                if let device = manager.currentDevice {
                    self.displayName = device.displayName
                } else {
                    self.displayName = undefinedLabel
                }
            } else {
                self.running = false
                self.recording = false
                self.displayName = undefinedLabel
            }
            
            self.selectPreset(newPreset: self.modeSelectedIndex)
            self.selectLayout(newLayout: self.layoutSelectedIndex)
        }
    }
    
    // Preview registration
    func registerPreview(parentView :CaptureVideoPreview) {
        if let vPreview = vPreview, vPreview == parentView {
            return
        }
        vPreview = parentView
    }
    
    // Check if device is detected
    func checkDevice() -> Bool {
        if manager == nil {
            manager = DLABCapture.CaptureManager()
        }
        if let manager = manager {
            _ = manager.findFirstDevice()
            if manager.currentDevice != nil {
                return true
            }
        }
        return false
    }
    
    // Configure CaptureManager using ConfigSet
    func applyConfig() {
        guard checkDevice() else { return }
        
        // Update configSet per selection
        config = ConfigSet(preset: presetLabel)
        if applySDOffset {
            config.apply(adjustSD: sdOffset)
        }
        if (config.videoConnection == .HDMI && config.audioConnection == .embedded) {
            config.apply(layout: layoutLabel, swap: reverse34)
        }
        
        //
        if let manager = manager, let vPreview = vPreview {
            // configure capture session
            manager.displayMode          = config.displayMode
            manager.pixelFormat          = config.pixelFormat
            manager.videoStyle           = config.videoStyle
            manager.videoConnection      = config.videoConnection
            manager.audioConnection      = config.audioConnection
            manager.fieldDetail          = config.fieldDetail ?? nil
            manager.cvPixelFormat        = config.cvPixelFormat
            manager.encodeVideoCodecType = config.encodeVideoCodecType
            manager.offset               = config.offset
            manager.encodeProRes422      = config.encodeProRes422
            manager.sampleTimescale      = config.sampleTimescale
            manager.encodeAudio          = config.encodeAudio
            manager.encodeAudioBitrate   = config.encodeAudioBitrate
            manager.audioChannels        = config.audioChannels
            manager.hdmiAudioChannels    = config.hdmiAudioChannels
            manager.reverseCh3Ch4        = config.reverse34
            
            #if true
            manager.videoPreview = vPreview // CaptureVideoPreview based
            #else
            manager.parentView = vPreview // CreateCocoaScreenPreview based
            #endif
            
            #if true
            // place any debug code here to test paramater(s)
            
            #endif
        }
    }
    
    // Handle Capture session
    func toggleRunning() {
        guard checkDevice() else { return }
        
        if let manager = manager {
            if manager.running {
                // stop capture session
                if manager.recording {
                    manager.recordToggle()
                }
                manager.captureStop()
                
                // shutdown capture manager
                self.manager = nil
            } else {
                // start capture session
                applyConfig()
                manager.captureStart()
            }
        }
        
        //
        updateViewState()
    }
    
    // Handle Recording
    func toggleRecording() {
        guard checkDevice() else { return }
        
        if let manager = manager, running == true {
            if manager.recording {
                // stop recording
                manager.recordToggle()
            } else {
                // start recording
                manager.recordToggle()
            }
        }
        
        //
        updateViewState()
    }
}
