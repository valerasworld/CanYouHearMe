//
//  SinWaveViewModifier.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 02/07/25.
//

import SwiftUI

extension View {
    func sinWaveModifier(sinWave: SinWave, time: Double, speed: Double, smoothing: Double, strength: Double, isPresented: Bool) -> some View {
        modifier(SinWaveViewModifier(sinWave: sinWave, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented))
    }
}

struct SinWaveViewModifier: ViewModifier {
    var sinWave: SinWave
    var time: Double
    var speed: Double
    var smoothing: Double
    var strength: Double
    
    var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .background(.white.opacity(0.001))
            .drawingGroup()
            .visualEffect { content, proxy in
                content
                    .distortionEffect(
                        ShaderLibrary.slowSine(
                            .float(isPresented ? time * sinWave.positionMultiplierAndAddition.0 + sinWave.positionMultiplierAndAddition.1 : 0.0),
                            .float(speed * sinWave.speedMultiplier),
                            .float(smoothing * sinWave.smoothingMultiplierAndAddition.0 + sinWave.smoothingMultiplierAndAddition.1),
                            .float(strength + sinWave.strengthAddition),
                            .float2(proxy.size)
                            
                        ), maxSampleOffset: .zero
                    )
            }
    }
}
