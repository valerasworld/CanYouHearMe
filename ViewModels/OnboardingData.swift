//
//  OnboardingData.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 21/05/25.
//

import SwiftUI

@Observable
class OnboardingData {
    let title: String = "Welcome to CanYouHearMe"
    let onboardingTextRows: [OnboardingTextRow] = [
        OnboardingTextRow(
            symbolName: "waveform",
            text: "Record messages that are felt, not just heard."
        ),
        OnboardingTextRow(
            symbolName: "sparkles",
            text: "Your words come to life with text, haptics, and visuals."
        ),
        OnboardingTextRow(
            symbolName: "hearingdevice.ear.fill",
            text: "Make communication more inclusive for those with hearing impairments."
        )
    ]
}
