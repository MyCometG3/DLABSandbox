//
//  ConfigSet.swift
//  DLABSandbox
//
//  Created by Takashi Mochizuki on 2022/10/14.
//  Copyright © 2022 MyCometG3. All rights reserved.
//

import Cocoa
import DLABCore
import DLABCapture

struct ConfigSet {
    var displayMode :DLABDisplayMode = .modeHD1080i5994
    var pixelFormat :DLABPixelFormat = .format10BitYUV
    var videoStyle :VideoStyle = .HD_1920_1080_Full
    var videoConnection :DLABVideoConnection = .HDMI
    var audioConnection :DLABAudioConnection = .embedded
    var fieldDetail :CFString? = kCMFormatDescriptionFieldDetail_SpatialFirstLineEarly
    var cvPixelFormat :OSType = kCVPixelFormatType_422YpCbCr10
    var encodeVideoCodecType :CMVideoCodecType = kCMVideoCodecType_H264
    var offset :NSPoint = NSZeroPoint
    
    var encodeProRes422 :Bool = false
    var sampleTimescale :Int32 = 30000
    var encodeAudio :Bool = true
    var encodeAudioBitrate :UInt = 192*1024
    var audioChannels :UInt32 = 2
    
    init(preset newPreset :Preset) {
        switch newPreset {
        case .preset0:
            // 0: HD-1080i, fieldDominance:upper, HDMI
            displayMode = .modeHD1080i5994
            pixelFormat = .format8BitYUV
            videoStyle = .HD_1920_1080_Full
            videoConnection = .HDMI
            audioConnection = .embedded
            fieldDetail = kCMFormatDescriptionFieldDetail_SpatialFirstLineEarly
            cvPixelFormat = kCVPixelFormatType_422YpCbCr8
            encodeVideoCodecType = kCMVideoCodecType_AppleProRes422LT
            encodeAudio = false
        case .preset1:
            // 1: HD-720p, progressive, HDMI+RCA
            displayMode = .modeHD720p5994
            pixelFormat = .format8BitYUV
            videoStyle = .HD_1280_720_Full
            videoConnection = .HDMI
            audioConnection = .analogRCA
            fieldDetail = nil // Progressive, FieldCount == 1
            cvPixelFormat = kCVPixelFormatType_422YpCbCr8
            encodeVideoCodecType = kCMVideoCodecType_AppleProRes422LT
            encodeAudio = false
        case .preset2:
            // 2: SD-NTSC, fieldDominance:lower, HDMI+RCA
            displayMode = .modeNTSC
            pixelFormat = .format8BitYUV
            videoStyle = .SD_720_486_16_9
            videoConnection = .HDMI
            audioConnection = .analogRCA
            fieldDetail = kCMFormatDescriptionFieldDetail_SpatialFirstLineLate
            cvPixelFormat = kCVPixelFormatType_422YpCbCr8
            encodeVideoCodecType = kCMVideoCodecType_AppleProRes422LT
            encodeAudio = false
        case .preset3:
            // 3: SD-NTSC, fieldDominance:lower, SVideo+RCA
            displayMode = .modeNTSC
            pixelFormat = .format8BitYUV
            videoStyle = .SD_720_486_16_9
            videoConnection = .sVideo
            audioConnection = .analogRCA
            fieldDetail = kCMFormatDescriptionFieldDetail_SpatialFirstLineLate
            cvPixelFormat = kCVPixelFormatType_422YpCbCr8
            encodeVideoCodecType = kCMVideoCodecType_AppleProRes422LT
            encodeAudio = false
        case .preset4:
            // 4: SD-NTSC, fieldDominance:lower, Composite+RCA
            displayMode = .modeNTSC
            pixelFormat = .format8BitYUV
            videoStyle = .SD_720_486_16_9
            videoConnection = .composite
            audioConnection = .analogRCA
            fieldDetail = kCMFormatDescriptionFieldDetail_SpatialFirstLineLate
            cvPixelFormat = kCVPixelFormatType_422YpCbCr8
            encodeVideoCodecType = kCMVideoCodecType_AppleProRes422LT
            encodeAudio = false
        case .undefined:
            // Undefined: HD-1080i, fieldDominance:upper, HDMI
            // YpCbCr10 with H264+AAC transcoded
            break
        }
    }
    
    init(preset newPreset :Preset, adjustSD newOffset :NSPoint) {
        self = ConfigSet(preset: newPreset)
        
        if videoConnection == .composite || videoConnection == .sVideo {
            offset = newOffset
        }
    }
}
