//
//  PlayButtonView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 24.02.25.
//

import SwiftUI

struct PlayButtonView: View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            Image(systemName: "speaker.wave.2.fill")
                .foregroundStyle(Color.white)
                .font(.title2)
                .opacity(viewModel.isPlaying ? 1.0 : 0.0)
                .bold()
            Circle()
                .fill(Color.white)
                .frame(width: 70, height: 70)
                .opacity(viewModel.isPlayButtonEnabled ? 1.0 : 0.3)
                .scaleEffect(viewModel.isPlayingAnimation ? 0.0 : 1.0)
            
            Image(systemName: "play.fill")
                .foregroundStyle(Color.black)
                .font(.title2)
                .bold()
                .scaleEffect(viewModel.isPlayingAnimation ? 0.0 : 1.0)
        }
    }
}

#Preview {
    PlayButtonView()
}
