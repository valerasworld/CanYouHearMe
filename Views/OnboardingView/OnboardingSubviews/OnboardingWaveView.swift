//
//  OnboardingWaveView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 21/05/25.
//


import SwiftUI

struct OnboardingWaveView: View {
    
    @State var startTime = Date.now
    @Binding var showModal: Bool
    
    var body: some View {
        TimelineView(.animation) { tl in
            let time = tl.date.distance(to: startTime)
            
            Rectangle()
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [
                        .indigo,
                        .indigo.opacity(0.7),
                        .indigo.opacity(0.5),
                        .indigo.opacity(0.7),
                        .indigo]),
                    startPoint: .top,
                    endPoint: .bottom))
            
            
                .frame(maxHeight: 140)
                .modifier(OnboardingWaveShaderViewModifier(showModal: showModal, time: time))
        }
    }
}