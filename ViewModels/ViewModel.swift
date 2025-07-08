//
//  ViewModel.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 31.01.25.
//

import SwiftUI
import Speech

@Observable
class ViewModel {
    
    private let audioService: AudioServiceProtocol
    
    init(
        audioService: AudioServiceProtocol = AudioService()
    ) {
        self.audioService = audioService
    }
    
    var recognizedText: String = ""

    var syllables: [(SpeechSounds, Double, String)] = []
    
    var duration: Double = 0.0
    
    var isRecording = false
    var isRecordingAnimation: Bool = false
    
    var timer: Timer? = nil
        
    var syllableIndex = 0
    
    var lastVolumeValue: CGFloat = 0.0
    
    
    // UI - changing properties
    var audioFileURL: URL? = nil
    
    var words: [Word] = []
    var lines: [[Word]] = []
    
    var availableWidth: CGFloat = 300
    
    var hasPermission = false
    var alertIsPresented: Bool = false
    var showModal = true
    var isPresented: Bool = false
    
    var hapticBlurValue: CGFloat = 0
    
    var isPlaying = false
    var isPlayingAnimation: Bool = false
    var isPlayButtonEnabled: Bool = false
    
    var scaledIndices: Set<Int> = []
    var isPhraseDone: Bool = true
    
    var count: Double = 0.0
    
    var volumeChangeValue: CGFloat = 50.0
    var isPlayingWaveShaderTransition: Bool = false
    
    var strengthValue: Float = 1.0
    var waveStateValue: Float = 0.0
    
    var power: Float = 0.0
    
    @MainActor
    func requestSpeechPermission() async {
        let status = await SFSpeechRecognizer.requestAuthorization()

         if status == .authorized {
                hasPermission = true
                showModal = false
            } else {
                hasPermission = false
                showModal = false
            }
    }
    
    @MainActor
    func requestMicrophonePermission() async {
        Task {
            let granted = await audioService.requestMicrophonePermission()
            
            DispatchQueue.main.async {
                if !granted {
                    self.alertIsPresented = true
                }
            }
        }
    }
    
    func startRecording() {
        do {
            try audioService.startRecording()
            preparePropertiesForRecording()
            withAnimation(.spring(duration: 0.25)) {
                isRecordingAnimation = isRecording
            }
            audioFileURL = audioService.audioFileURL
        } catch {
            print(error.localizedDescription)
            alertIsPresented = true
        }
    }
    
    private func preparePropertiesForRecording() {
        words = []
        syllables = []
        lines = []
        isRecording = true
    }
    
    func playRecording() {
        guard audioFileURL != nil else { return }
        
        do {
            try audioService.playRecording()
        } catch {
            print(error.localizedDescription)
        }
        self.duration = audioService.currentDuration
    }
    
    @MainActor
    func stopRecording() {
        audioService.stopRecording()
        isRecording = false
        withAnimation(.spring(duration: 0.25)) {
            isRecordingAnimation = isRecording
        }
        Task {
            try await transcribeAudio()
        }
    }
    
    @MainActor
    func transcribeAudio() async throws {
        guard let audioFileURL = audioFileURL else { return }
        
        guard isValidAudioFile(at: audioFileURL) else { return }
        
        guard let recognizer = makeRecognizer() else { return }
        
        let request = makeRecognitionRequest(for: audioFileURL)
        
        recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.handleTranscriptionResult(result)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.handleTranscriptionError(error, audioFileURL: audioFileURL)
                }
            }
        }
    }
    
    @MainActor
    private func handleTranscriptionResult(_ result: SFSpeechRecognitionResult) {
        self.recognizedText = result.bestTranscription.formattedString
        let wordsWithPunctuation: [String] = self.recognizedText.components(separatedBy: " ")
        
        if result.isFinal {
            let segments = result.bestTranscription.segments
            let phonemes = self.getPhonemes(input: segments.description)
            
            processTranscriptionSegments(segments, wordsWithPunctuation: wordsWithPunctuation, phonemes: phonemes)
        }
        self.splitWordsIntoLines()
    }
    
    @MainActor
    private func handleTranscriptionError(_ error: Error, audioFileURL: URL) {
        print(error.localizedDescription)
        alertIsPresented = true
        
        if FileManager.default.fileExists(atPath: audioFileURL.path) {
            deleteFile(atPath: audioFileURL.path)
            self.audioFileURL = nil
        }
    }
    
    private func processTranscriptionSegments(_ segments: [SFTranscriptionSegment], wordsWithPunctuation: [String], phonemes: [String]) {
        for i in 0..<segments.count {
            let word = Word(
                text: wordsWithPunctuation[i],
                phonemes: phonemes[i].components(separatedBy: "."),
                timestamp: segments[i].timestamp,
                duration: segments[i].duration
            )
            
            let wordSyllables = word.getSoundTypeAndAprroximateTimestamp(
                phonemes: word.phonemes,
                timestamp: word.timestamp,
                duration: word.duration
            )
            
            self.syllables += wordSyllables
            
            let wordAndTime: (String, Double) = (segments[i].substring, word.timestamp - 0.1)
            self.words.append(Word(text: wordAndTime.0, phonemes: word.phonemes, timestamp: wordAndTime.1, duration: word.duration))
        }
    }
    
    func splitWordsIntoLines() {
        var currentLine: [Word] = []
        var currentLineWidth: CGFloat = 0
        lines = []
        
        for word in words {
            let wordWidth = widthOfText(word.text)
            
            if currentLineWidth + wordWidth <= availableWidth {
                currentLine.append(word)
                currentLineWidth += wordWidth
            } else {
                lines.append(currentLine)
                currentLine = [word]
                currentLineWidth = wordWidth
            }
        }
        
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
    }
    
    private func isValidAudioFile(at audioFileURL: URL) -> Bool {
        guard FileManager.default.fileExists(atPath: audioFileURL.path) else { return false }
        
        do {
            let player = try AVAudioPlayer(contentsOf: audioFileURL)
            return player.prepareToPlay()
        } catch {
            print("Invalid audio file: \(error.localizedDescription)")
            return false
        }
    }
    
    private func makeRecognizer() -> SFSpeechRecognizer? {
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US")),
              recognizer.supportsOnDeviceRecognition else {
            print("Speech recognizer not supported or unavailable.")
            return nil
        }
        return recognizer
    }
    
    private func makeRecognitionRequest(for audioFileURL: URL) -> SFSpeechURLRecognitionRequest {
        let request = SFSpeechURLRecognitionRequest(url: audioFileURL)
        request.addsPunctuation = true
        request.requiresOnDeviceRecognition = true
        return request
    }
    
    
    
    // // // // // // // // // // // // // // // //
    
    func getPhonemes(input: String) -> [String] {
        let text = input

        var results: [String] = []
        let key = "ipaPhoneSequence="

        var searchRange = text.startIndex..<text.endIndex

        while let rangeStart = text.range(of: key, range: searchRange) {
            let substringStart = rangeStart.upperBound
            
            if let rangeEnd = text[substringStart...].range(of: ",") {
                let extracted = text[substringStart..<rangeEnd.lowerBound]
                results.append(String(extracted))
                
                searchRange = rangeEnd.upperBound..<text.endIndex
            } else {
                break
            }
        }
        return results
    }
    
    func deleteFile(atPath path: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            print(error.localizedDescription)
        }
    }

    @MainActor
    func startOrStopRecordingAnimations() {
        if isRecording {
            withAnimation(.easeInOut(duration: 1.0)) {
                waveStateValue = 0.0
            }
            stopRecording()
            withAnimation(.spring(duration: 0.25)) {
                isPlayButtonEnabled = true
            }
        } else {
            startRecording()
            withAnimation(.easeInOut(duration: 1.0)) {
                waveStateValue = -1.0
            }
            withAnimation(.spring(duration: 0.25)) {
                isPlayButtonEnabled = false
            }
        }
    }
    
    func playAnimations() {
        if !isRecording || recognizedText != "" {
            withAnimation(.easeInOut(duration: 0.2)) {
                isPlaying = true
            }
            
            withAnimation(.spring(duration: 0.25)) {
                isPlayButtonEnabled = false
                isPlayingAnimation = true
            }
            
            withAnimation(.easeInOut(duration: 1.5)) {
                waveStateValue = 1.0
                isPlayingWaveShaderTransition = isPlaying
            }
            
            withAnimation(.easeInOut(duration: 2.0)) {
                strengthValue = isPlaying ? 25.0 : 1.0
                if !isPlaying {
                    volumeChangeValue = 1.0
                }
            }
        }
    }
    
    func waveVolumeChangeAnimation() {
        guard let player = audioService.currentPlayer else { return }
        
        var power: Float = 0
        for i in 0..<player.numberOfChannels {
            power += player.averagePower(forChannel: i)
        }
        let volumeChangeValue = max(40, CGFloat(power + 80))
        withAnimation(Animation.smooth(duration: 0.4)) {
            if volumeChangeValue < 180 {
                self.volumeChangeValue = volumeChangeValue
            }
            self.lastVolumeValue = volumeChangeValue
        }
    }
    
    func smoothAnimationWhenAudioIsDone() {
        volumeChangeValue = lastVolumeValue
        
        withAnimation(.easeInOut(duration: 2.0)) {
            strengthValue = 1.0
            volumeChangeValue = 1.0
        }
    }
    
    @MainActor
    func endPlayingAnimation() async {
        try? await Task.sleep(for: .seconds(1.5))
        withAnimation(.easeInOut(duration: 2.0)) {
            isPhraseDone = true
            waveStateValue = 0.0
            lastVolumeValue = 0.0
            
        }
        try? await Task.sleep(for: .seconds(1.5))
        withAnimation(.spring(duration: 0.25)) {
            isPlaying = false
            isPlayButtonEnabled = true
            isPlayingAnimation = false
        }
    }
    
    @MainActor
    func configureAudioSession() {
        Task {
            do {
                try audioService.configureAudioSession()
            } catch {
                print(error.localizedDescription)
                alertIsPresented = true
            }
        }
    }
    
    func widthOfText(_ text: String) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }
    
    func startTimer() {
        count = 0.0
        syllableIndex = 0
        scaledIndices = []
        isPhraseDone = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            Task { @MainActor in
                self.count += 0.01
                await self.checkSyllable()
                self.checkForWordHighlight()
                guard let player = self.audioService.currentPlayer else {
                    return
                }
                player.updateMeters()
                self.waveVolumeChangeAnimation()
            }
        }
    }
    
    func checkForWordHighlight() {
        if let index = words.firstIndex(where: { abs($0.timestamp - count) < 0.01 }) {
            scaledIndices.insert(index)
        }
        withAnimation(.easeInOut(duration: 1.5)) {
            isPlayingWaveShaderTransition = isPlaying
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        count = 0.0
    }
    
    @MainActor
    private func checkSyllable() async {
        guard syllableIndex < syllables.count else {
            if count >= duration {
                stopTimer()
                smoothAnimationWhenAudioIsDone()
                await endPlayingAnimation()
            }
            return
        }
        let syllable = syllables[syllableIndex]
        
        if abs(count - syllable.1) < 0.005 {
            HapticManager.instance.vowellHaptic(syllableType: syllable.0)
            syllableIndex += 1
        }
    }
}

extension SFSpeechRecognizer {
    static func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        
        await withCheckedContinuation { cont in
            self.requestAuthorization { authStatus in
                cont.resume(returning: authStatus)
            }
        }
    }
}
