//
//  PlayButtonProgressCircleView.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 20/05/25.
//
import SwiftUI

struct PlayButtonProgressCircleView: View {
    let viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 66, height: 66)
                .opacity(0.3)
            Circle()
                .trim(from: 0.0,
                      to: viewModel.count == 0.0 ? 1.0 : (CGFloat(viewModel.count) / CGFloat(viewModel.duration))
                )
                .stroke(Color.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 66, height: 66)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
