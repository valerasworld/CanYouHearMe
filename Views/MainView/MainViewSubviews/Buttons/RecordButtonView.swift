//
//  RecordButtonView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 24.02.25.
//

import SwiftUI

struct RecordButtonView: View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            if viewModel.isRecording {
                Circle()
                    .stroke(Color.accentColor, lineWidth: 4.0)
                    .frame(width: 66.0, height: 66.0)
            }
            RoundedRectangle(cornerRadius: viewModel.isRecordingAnimation ? 3.0 : 35.0)
                .foregroundStyle(Color.pink)
                .frame(width: viewModel.isRecordingAnimation ? 19.0 : 70.0, height: viewModel.isRecordingAnimation ? 19.0 : 70.0)
            Image(systemName: "mic.fill")
                .foregroundStyle(Color.black)
                .font(.title2)
                .bold()
                .scaleEffect(viewModel.isRecordingAnimation ? 0.0 : 1.0)
        }
        .opacity(viewModel.isPlaying ? 0.3 : 1.0)
        .frame(width: 70, height: 70)
    }
}

#Preview {
    RecordButtonView()
}
