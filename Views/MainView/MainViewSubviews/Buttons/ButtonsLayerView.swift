//
//  ButtonsLayerView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 20/05/25.
//
import SwiftUI

struct ButtonsLayerView: View {
    let viewModel: ViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.startOrStopRecordingAnimations()
            } label: {
                RecordButtonView()
            }
            .padding(.vertical, 25)
            .disabled(viewModel.isPlaying)
            
            Button {
                viewModel.playRecording()
                viewModel.startTimer()
                viewModel.playAnimations()
            } label: {
                PlayButtonView()
            }
            .disabled(!viewModel.isPlayButtonEnabled)
            .overlay {
                if viewModel.isPlaying {
                    PlayButtonProgressCircleView(viewModel: viewModel)
                }
            }
        }
        .offset(y: -30)
    }
}
