//
//  OnboardingButtonStyle.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 21/05/25.
//


import SwiftUI

struct OnboardingButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
            .tint(.pink)
            .padding(.horizontal, 28)
            .padding(.bottom, 100)
    }
}