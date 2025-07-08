//
//  AudioService.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 04.07.25.
//

import SwiftUI
import AVFoundation

protocol AudioServiceProtocol {
    var audioFileURL: URL? { get }
    var currentPlayer: AVAudioPlayer? { get }
    var currentDuration: Double { get }
    
    func requestMicrophonePermission() async -> Bool
    func startRecording() throws
    func stopRecording()
    func configureAudioSession() throws
    func playRecording() throws
}

class AudioService: AudioServiceProtocol {
    var recorder: AVAudioRecorder?
    var audioFileURL: URL? = nil
    var session: AVAudioSession!
    var player: AVAudioPlayer?
    var duration: Double = 0.0
    
    var currentPlayer: AVAudioPlayer? {
        return player
    }
    
    var currentDuration: Double {
        return duration
    }
    
    func requestMicrophonePermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }
    
    func startRecording() throws {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = url.appendingPathComponent("only_record.wav")
        
        if FileManager.default.fileExists(atPath: filePath.path) {
            try FileManager.default.removeItem(at: filePath)
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        recorder = try AVAudioRecorder(url: filePath, settings: settings)
        recorder?.record()
        audioFileURL = filePath
        
    }
    
    func stopRecording() {
        recorder?.stop()
    }
    
    func configureAudioSession() throws {
        session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
        try session.setActive(true)
    }
    
    func playRecording() throws {
        guard let audioFileURL = audioFileURL else {
            throw NSError(domain: "AudioService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No audio file found"])
        }
        player = try AVAudioPlayer(contentsOf: audioFileURL)
        player?.isMeteringEnabled = true
        player?.prepareToPlay()
        player?.play()
        duration = player?.duration ?? 0.0
    }
    
    
}
