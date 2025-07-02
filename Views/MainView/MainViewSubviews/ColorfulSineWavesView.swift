//
//  ColorfulSineWavesView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 12.02.25.
//

import SwiftUI

@MainActor
struct ColorfulSineWavesView: View {
    
    @Environment(ViewModel.self) var viewModel
    
    @State var sinWavesViewModel = SinWavesViewModel()
    
    var body: some View {
        TimelineView(.animation) { tl in
            
            let time = tl.date.distance(to: sinWavesViewModel.startTime)
            let speed = sinWavesViewModel.speed
            let smoothing = sinWavesViewModel.smoothing
            let strength = sinWavesViewModel.strength
            let nearT = sinWavesViewModel.nearT
            let nearPosX = sinWavesViewModel.nearPosX
            
            let strengthValue = viewModel.strengthValue
            let volumeChangeValue = viewModel.volumeChangeValue
            let isPlaying = viewModel.isPlaying
            let isPresented = sinWavesViewModel.isPresented
            
            ZStack {
                Color.black
                ZStack {
                    // Indigo Wave
                    SinWaveView(sinWave: .indigo, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented)
                    
                    // Yellow Wave
                    SinWaveView(sinWave: .yellow, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented)
                    
                    // Purple Wave
                    SinWaveView(sinWave: .purple, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented)
                    
                    // Pink Wave
                    SinWaveView(sinWave: .pink, time: time, speed: speed, smoothing: smoothing, strength: strength, isPresented: isPresented)
                    
                }
                .visualEffect { content, proxy in
                    content
                    // Volume Distortion Shader
                        .distortionEffect(
                            ShaderLibrary.waveHoriz(
                                .float(isPresented ? time / 4 : 0.0),
                                .float2(proxy.size),
                                .float(nearT),
                                .float(nearPosX),
                                .float(strengthValue
                                       - Float(isPlaying ? volumeChangeValue : 1.0))
                            ), maxSampleOffset: .zero)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            sinWavesViewModel.isPresented = true
        }
        .onDisappear {
            sinWavesViewModel.isPresented = false
        }
    }
}

#Preview {
    ColorfulSineWavesView()
        .environment(ViewModel())
}





