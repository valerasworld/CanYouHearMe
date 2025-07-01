//
//  OnboardingHighlightView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 21/05/25.
//


import SwiftUI

struct OnboardingTextRowView: View {
    let onboardingTextRow: OnboardingTextRow
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: onboardingTextRow.symbolName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.pink)
                .frame(width: 48, height: 48)
            Text(onboardingTextRow.text)
                .foregroundStyle(.white)
        }
    }
}
