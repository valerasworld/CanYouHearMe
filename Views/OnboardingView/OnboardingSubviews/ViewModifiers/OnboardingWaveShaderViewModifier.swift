//
//  OnboardingWaveShaderViewModifier.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 21/05/25.
//


import SwiftUI

struct OnboardingWaveShaderViewModifier: ViewModifier {
    let showModal: Bool
    let time: Double
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 100)
            .background(.white.opacity(0.001))
            .drawingGroup()
            .visualEffect { content, proxy in
                content
                    .distortionEffect(
                        ShaderLibrary.slowSine(
                            .float(time),
                            .float(0.6),
                            .float(134.4),
                            .float(24.0),
                            .float2(proxy.size)
                            
                        ), maxSampleOffset: .zero)
            }
            .opacity(0.8)
            .visualEffect { content, proxy in
                content
                    .distortionEffect(
                        ShaderLibrary.waveHoriz(
                            .float(showModal ? time / 4.0 : 0.0),
                            .float2(proxy.size),
                            .float(2.0),
                            .float(80.0),
                            .float(49.0)
                        ), maxSampleOffset: .zero)
            }
    }
}
