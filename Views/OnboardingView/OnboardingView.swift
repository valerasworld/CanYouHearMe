//
//  OnboardingView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 20.02.25.
//

import SwiftUI
import Speech

struct OnboardingView: View {
    @Environment(ViewModel.self) var viewModel
    let onboardingData = OnboardingData()
    
    @Binding var hasPermission: Bool
    @Binding var showModal: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Wave
            OnboardingWaveView(showModal: $showModal)

            VStack(spacing: 48) {
                
                Spacer()
                
                // Title
                Text(onboardingData.title)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.7), radius: 20)
                
                // Text Rows
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(onboardingData.onboardingTextRows, id: \.self) { row in
                        OnboardingTextRowView(onboardingTextRow: row)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 40)
                
                // Button
                Button {
                    showModal = false
                    Task {
                        await viewModel.requestMicrophonePermission()
                        await viewModel.requestSpeechPermission()
                    }
                    
                } label: {
                    Text("Let's Start")
                        .bold()
                        .font(.title3)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .modifier(OnboardingButtonStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.05))
        .ignoresSafeArea()
    }
}

#Preview {
//    OnboardingView()
}



