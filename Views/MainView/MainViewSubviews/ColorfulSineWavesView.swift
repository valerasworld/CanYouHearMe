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
    
    @State private var startTime = Date.now
    @State private var speed = 0.1
    @State private var smoothing = 96.0
    @State private var strength = 49.0
    
    @State private var nearT = 5.0
    @State private var nearPosX = 40.0
    
    @State private var isPresented: Bool = false
    
    
    var body: some View {
        TimelineView(.animation) { tl in
            
            let time = tl.date.distance(to: startTime)
            let speed2 = speed
            let smoothing2 = smoothing
            let strength2 = strength
            let nearT2 = nearT
            let nearPosX2 = nearPosX
            
            let strengthValue2 = viewModel.strengthValue
            let volumeChangeValue2 = viewModel.volumeChangeValue
            let isPlaying2 = viewModel.isPlaying
            let isPresented = isPresented
            
            ZStack {
                Color.black
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.indigo, .indigo.opacity(0.7), .indigo.opacity(0.5), .indigo.opacity(0.7), .indigo]), startPoint: .top, endPoint: .bottom))
                            .frame(maxHeight: 180)
                            .padding(.vertical, 150)
                            .background(.white.opacity(0.001))
                            .drawingGroup()
                            .visualEffect { content, proxy in
                                 content
                                    .distortionEffect(
                                            ShaderLibrary.slowSine(
                                                .float(isPresented ? time + 3.0 : 0.0),
                                                .float(speed2 * 2.0),
                                                .float(smoothing2 - 20),
                                                .float(strength2 - 5),
                                                .float2(proxy.size)
                                                
                                            ), maxSampleOffset: .zero
                                    )
                            }
                            .opacity(0.8)
                        
                        Rectangle()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.yellow, .yellow.opacity(0.7), .yellow.opacity(0.5), .yellow.opacity(0.7), .yellow]), startPoint: .top, endPoint: .bottom))
                            .frame(maxHeight: 160)
                            .padding(.vertical, 150)
                            .background(.white.opacity(0.001))
                            .drawingGroup()
                            .visualEffect { content, proxy in
                                content
                                    .distortionEffect(
                                        ShaderLibrary.slowSine(
                                            .float(isPresented ? time * 4.0 : 0.0),
                                            .float(speed2 * 1.2),
                                            .float(smoothing2 * 1.2),
                                            .float(strength2 - 5.0),
                                            .float2(proxy.size)
                                            
                                        ), maxSampleOffset: .zero)
                            }
                            .opacity(0.8)
                        
                        Rectangle()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .purple.opacity(0.7), .purple.opacity(0.5), .purple.opacity(0.7), .purple]), startPoint: .top, endPoint: .bottom))
                            .frame(maxHeight: 180)
                            .padding(.vertical, 150)
                            .background(.white.opacity(0.001))
                            .drawingGroup()
                            .visualEffect { content, proxy in
                                content
                                    .distortionEffect(
                                        ShaderLibrary.slowSine(
                                            .float(isPresented ? time * 2.0 : 0.0),
                                            .float(speed2 * 1.2),
                                            .float(smoothing2 * 1.2),
                                            .float(strength2 - 5.0),
                                            .float2(proxy.size)
                                            
                                        ), maxSampleOffset: .zero)
                            }
                            .opacity(0.8)

                        
                        Rectangle()
                        
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [
                                    .pink,
                                    .pink.opacity(0.7),
                                    .pink.opacity(0.5),
                                    .pink.opacity(0.7),
                                    .pink]),
                                startPoint: .top,
                                endPoint: .bottom))
                        
                                
                            .frame(maxHeight: 160)
                                

                            .padding(.vertical, 120)
                            .background(.white.opacity(0.001))
                            .drawingGroup()
                            .visualEffect { content, proxy in
                                content
                                    .distortionEffect(
                                        ShaderLibrary.slowSine(
                                            .float(isPresented ? time : 0.0),
                                            .float(speed2 * 6),
                                            .float(smoothing2 * 1.4),
                                            .float(strength2 - 25.0),
                                            .float2(proxy.size)
                                            
                                        ), maxSampleOffset: .zero)
                            }
                            .opacity(0.8)
                            
                    }
                    .visualEffect { content, proxy in
                        content
                            .distortionEffect(
                                ShaderLibrary.waveHoriz(
                                    .float(isPresented ? time / 4 : 0.0),
                                    .float2(proxy.size),
                                    .float(nearT2),
                                    .float(nearPosX2),
                                    .float(strengthValue2
                                            - Float(isPlaying2 ? volumeChangeValue2 : 1.0))
                                ), maxSampleOffset: .zero)
                    }
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            isPresented = true
        }
        .onDisappear {
            isPresented = false
        }
    }
}

#Preview {
    ColorfulSineWavesView()
}
