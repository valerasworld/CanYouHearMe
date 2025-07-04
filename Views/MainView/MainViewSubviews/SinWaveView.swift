//
//  SinWaveView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 02/07/25.
//

import SwiftUI

struct SinWaveView: View {
    let sinWave: SinWave
    var time: Double
    var speed: Double
    var smoothing: Double
    var strength: Double
    
    var isPresented: Bool
    
    var body: some View {
        Rectangle()
            .foregroundStyle(sinWave.gradient)
            .frame(maxHeight: sinWave.maxHeight)
            .padding(.vertical, sinWave.padding)
            .sinWaveModifier(sinWave: sinWave, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented)
            .opacity(sinWave.opacity)
    }
}
