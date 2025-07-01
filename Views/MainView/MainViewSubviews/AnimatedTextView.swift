//
//  AnimatedTextView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 24.02.25.
//

import SwiftUI

struct AnimatedTextView: View {
    @Environment(ViewModel.self) var speechRecogManager
    
    var body: some View {
        VStack {
            ForEach(speechRecogManager.lines, id: \.self) { line in
                HStack(spacing: 5) {
                    ForEach(line) { word in
                        let containsWordToScale = speechRecogManager.scaledIndices.contains(speechRecogManager.words.firstIndex(where: { $0.id == word.id }) ?? -1)
                        
                        Text(word.text)
                            .font(.largeTitle)
                            .bold()
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .scaleEffect(speechRecogManager.isPhraseDone ? 0.9 : (containsWordToScale ? 1.0 : 0.9))
                            .blur(radius: speechRecogManager.isPhraseDone ? 7.0 : (containsWordToScale ? 0.0 : 7.0))
                            .opacity(speechRecogManager.isPhraseDone ? 0.2 : (containsWordToScale ? 1.0 : 0.2))
                            .animation(.easeInOut(duration: 0.4), value: speechRecogManager.scaledIndices)
                    }
                }
            }
        }
    }
}

#Preview {
    AnimatedTextView()
}
