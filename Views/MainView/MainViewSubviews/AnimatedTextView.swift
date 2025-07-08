//
//  AnimatedTextView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 24.02.25.
//

import SwiftUI

struct AnimatedTextView: View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            ForEach(viewModel.lines, id: \.self) { line in
                HStack(spacing: 5) {
                    ForEach(line) { word in
                        let containsWordToScale = viewModel.scaledIndices.contains(viewModel.words.firstIndex(where: { $0.id == word.id }) ?? -1)
                        
                        Text(word.text)
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .scaleEffect(viewModel.isPhraseDone ? 0.9 : (containsWordToScale ? 1.0 : 0.9))
                            .blur(radius: viewModel.isPhraseDone ? 7.0 : (containsWordToScale ? 0.0 : 7.0))
                            .opacity(viewModel.isPhraseDone ? 0.2 : (containsWordToScale ? 1.0 : 0.2))
                            .animation(.easeInOut(duration: 0.4), value: viewModel.scaledIndices)
                    }
                }
            }
        }
    }
}

#Preview {
    AnimatedTextView()
}
