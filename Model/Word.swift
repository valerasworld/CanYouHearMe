//
//  Word.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 05.02.25.
//
import Foundation

struct Word: Identifiable, Hashable {
    var id = UUID()
    var text: String
    var phonemes: [String]
    var timestamp: Double
    var duration: Double
    
    func getSoundTypeAndAprroximateTimestamp(phonemes: [String], timestamp: Double, duration: Double) -> [(SpeechSounds, Double, String)] {
        var speechSounds : [(SpeechSounds, Double, String)] = []
        var revisedPhonemes: [String] = []
        
        for phoneme in phonemes {
            revisedPhonemes.append(contentsOf: phoneme.components(separatedBy: " "))
        }
        
        let halfs = revisedPhonemes.splitInHalfs()
        if halfs[0] == halfs[1] {
            revisedPhonemes = revisedPhonemes.splitInHalfs()[0]
        }
        
        let ratioAndQualityMap = getSoundDurationRatio(phonemes: revisedPhonemes)
        
        let realTimeStamps = getRealTimestamps(wordTimestamp: timestamp, wordDuration: duration, ratioAndQualityMap: ratioAndQualityMap)
        
        for (index, phoneme) in revisedPhonemes.enumerated() {
            let speechSoundQuality: SpeechSounds = ratioAndQualityMap[index].1
            let timestamp = realTimeStamps[index]
            
            speechSounds.append((speechSoundQuality, timestamp, phoneme))
        }
        
        return speechSounds
    }
    
    func getSoundDurationRatio(phonemes: [String]) -> [(Double, SpeechSounds)] {
        var durationRatioAndQuality: [(Double, SpeechSounds)] = []
        
        for phoneme in phonemes {
            if phonemes.count == 1 {
                durationRatioAndQuality.append((1, .stressed))
                continue
            }
            
            else if phoneme.contains("ˈ") {
                durationRatioAndQuality.append((2, .stressed))
                continue
            }
            // aɪ, aʊ, ɔɪ, oʊ, eɪ
            else if !phoneme.contains("ˈ") &&
                        (phoneme.contains("a͡ɪ") ||
                         phoneme.contains("a͡ʊ") ||
                         phoneme.contains("ɔ͡ɪ") ||
                         phoneme.contains("o͡ʊ") ||
                         phoneme.contains("e͡ɪ")) {
                durationRatioAndQuality.append((2.6, .unstressed))
                continue
                
            }
            // i, ɪ, e, ɛ, æ, ɑ, ɔ, o, ʊ, u, ʌ, ə
            else if !phoneme.contains("ˈ") &&
                        (phoneme.contains("i") ||
                         phoneme.contains("ɪ") ||
                         phoneme.contains("e") ||
                         phoneme.contains("ɛ") ||
                         phoneme.contains("æ") ||
                         phoneme.contains("ɑ") ||
                         phoneme.contains("ɔ") ||
                         phoneme.contains("o") ||
                         phoneme.contains("ʊ") ||
                         phoneme.contains("u") ||
                         phoneme.contains("ʌ") ||
                         phoneme.contains("ə")) {
                durationRatioAndQuality.append((1, .unstressed))
                continue
            }
            
            // b, d, g, v, ð, z, ʒ, dʒ, m, n, ŋ, l, r, ɻ, w
            else if phoneme.contains("b") ||
                        phoneme.contains("d") ||
                        phoneme.contains("g") ||
                        phoneme.contains("v") ||
                        phoneme.contains("ð") ||
                        phoneme.contains("z") ||
                        phoneme.contains("dʒ") ||
                        phoneme.contains("ʒ") ||
                        phoneme.contains("m") ||
                        phoneme.contains("n") ||
                        phoneme.contains("ŋ") ||
                        phoneme.contains("l") ||
                        phoneme.contains("ɻ") ||
                        phoneme.contains("r") ||
                        phoneme.contains("w") {
                durationRatioAndQuality.append((1.5, .consonant))
                continue
            }
            // j
            else if phoneme.contains("j") {
                durationRatioAndQuality.append((0.7, .consonant))
                continue
            }
            
            // p, t, k, f, θ, s, ʃ, tʃ, h
            else if phoneme.contains("p") ||
                        phoneme.contains("t͡ʃ") ||
                        phoneme.contains("t") ||
                        phoneme.contains("k") ||
                        phoneme.contains("f") ||
                        phoneme.contains("θ") ||
                        phoneme.contains("s") ||
                        phoneme.contains("ʃ") ||
                        phoneme.contains("h") {
                durationRatioAndQuality.append((1, .consonant))
                continue
            } else {
                durationRatioAndQuality.append((1, .consonant))
                continue
            }
        }
        
        return durationRatioAndQuality
    }
    
    func getRealTimestamps(wordTimestamp: Double, wordDuration: Double, ratioAndQualityMap: [(Double, SpeechSounds)]) -> [Double] {
        var realTimestamps: [Double] = []
        
        let ratioSum: Double = ratioAndQualityMap.reduce(0.0) { $0 + $1.0 }
        let bitLength: Double = wordDuration / ratioSum
        
        for (index, _) in ratioAndQualityMap.enumerated() {
            if index == 0 {
                realTimestamps.append(wordTimestamp)
            } else {
                realTimestamps.append(realTimestamps[index - 1] + bitLength * ratioAndQualityMap[index - 1].0)
            }
        }
        
        return realTimestamps
    }
}

enum SpeechSounds {
    case stressed
    case unstressed
    case consonant
}

