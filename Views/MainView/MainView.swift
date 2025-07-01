//
//  MainView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 31.01.25.
//

import SwiftUI
import Foundation

struct MainView: View {
    @Binding var viewModel: ViewModel
    
        
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                Spacer()
                ZStack {
                    var grayState: Float {
                        return 1 - abs(viewModel.waveStateValue)
                    }
                    var redState: Float {
                        return max(0.0, (viewModel.waveStateValue - 1.0) * -1.0)
                    }
                    
                    
                    ColorfulSineWavesView()
                        .opacity(max(0.08, Double(1.0 - grayState)))
                        .colorEffect(
                            ShaderLibrary.grayShades(.float(viewModel.isPlayingWaveShaderTransition ? 0.0 : 1.0))
                        )
                        .colorEffect(
                            ShaderLibrary.indingoShades(.float(redState))
                        )
                        .colorEffect(
                            ShaderLibrary.grayShades(.float(grayState))
                        )
                    
                    if viewModel.lines.isEmpty {
                        Text(viewModel.isRecording ? "Recording..." : (viewModel.audioFile != nil ?
                                 "Doing magic..." : "Ready to record"))
                            .font(.largeTitle)
                            .bold()
                            .padding()
                            .frame(maxHeight: .infinity)
                            .frame(width: geometry.size.width)
                    } else {
                        AnimatedTextView()
                        .frame(maxHeight: .infinity)
                        .frame(width: geometry.size.width)
                    }
                    
                    // Haptic blur
                    /*
//                    ZStack(alignment: .bottom) {
//                        Rectangle()
//                            .foregroundStyle(LinearGradient(colors: [.indigo, .indigo, .indigo, .indigo.opacity(0)], startPoint: .bottom, endPoint: .top))
//                            .frame(height: 220)
////                            .offset(y: 380)
//                        RoundedRectangle(cornerRadius: 37)
//                            .foregroundStyle(LinearGradient(colors: [.black, .black, .black.opacity(0)], startPoint: .bottom, endPoint: .top))
//                            .frame(height: 440)
////                            .offset(y: 249)
//                            .blur(radius: viewModel.hapticBlurValue)
//                            .mask {
//                                Rectangle()
//                                    .frame(height: 220)
//                                    .offset(y: 110)
//                                    
//                            }
//                        
//                    }
//                    .offset(y: 255)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .ignoresSafeArea()
                    
                    */
                    
                }
                .shadow(color: .black.opacity(0.7), radius: 20)
                
                
                
                // Buttons
                
                ButtonsLayerView(viewModel: viewModel)
                
            }
            
            .onChange(of: geometry.size.width) { _, newWidth in
                viewModel.availableWidth = newWidth
                viewModel.splitWordsIntoLines()
            }
//            .onChange(of: viewModel.syllableIndex) {
//                animateHapticCircles()
//            }
        }
        
        .alert("Sorry, we didn't get you", isPresented: .constant(viewModel.alertIsPresented)) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please try again or check if CanYouHearMe has access to the microphone and speech recognition in Settings.")
        }
        .onAppear {
            viewModel.isPresented = true
            viewModel.configureAudioSession()
        }
        .onDisappear {
            viewModel.isPresented = false
            viewModel.stopTimer()
        }
        .fullScreenCover(isPresented: $viewModel.showModal) {
            OnboardingView(hasPermission: $viewModel.hasPermission, showModal: $viewModel.showModal)
        }
    }
    
    // Haptic Blur Method
//    func animateHapticCircles() {
//        
//        guard viewModel.syllableIndex <= viewModel.syllables.count - 1 else { return }
//        let syllableType = viewModel.syllables[viewModel.syllableIndex].0
//        if viewModel.syllableIndex == viewModel.syllables.count - 1 {
//            withAnimation(.spring(duration: 0.05)) {
//                if syllableType == .stressed {
//                    viewModel.hapticBlurValue = 30
//                }
//                if syllableType == .unstressed {
//                    viewModel.hapticBlurValue = 15
//                }
//                if syllableType == .consonant {
//                    viewModel.hapticBlurValue = 0
//                }
//            }
//            withAnimation(.spring(duration: 1)) {
//                viewModel.hapticBlurValue = 0
//            }
//            
//        } else {
//            withAnimation(.spring(duration: 0.05)) {
//                if syllableType == .stressed {
//                    viewModel.hapticBlurValue = 30
//                }
//                if syllableType == .unstressed {
//                    viewModel.hapticBlurValue = 15
//                }
//                if syllableType == .consonant {
//                    viewModel.hapticBlurValue = 0
//                }
//            }
//        }
//    }
}





