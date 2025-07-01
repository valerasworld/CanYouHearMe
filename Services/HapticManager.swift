//
//  HapticManager.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 03.02.25.
//
import SwiftUI

final class HapticManager: Sendable {
    
    static let instance = HapticManager()
    
    @MainActor
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    @MainActor
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle, view: UIView, intensity: CGFloat) {
        let generator = UIImpactFeedbackGenerator(style: style, view: view)
        generator.impactOccurred(intensity: intensity)
    }
    
    @MainActor
    func vowellHaptic(syllableType: SpeechSounds) {
        switch syllableType {
        case .stressed:
            impact(style: .heavy, view: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)), intensity: 1.0)
        case .unstressed:
            impact(style: .rigid, view: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)), intensity: 1.0)
        case .consonant:
            impact(style: .soft, view: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)), intensity: 0.2)
        
        }
    }
}
