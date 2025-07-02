//
//  SinWave.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 02/07/25.
//

import SwiftUI

enum SinWave {
    case indigo, purple, yellow, pink
    
    var color: Color {
        switch self {
        case .indigo: .indigo
        case .purple: .purple
        case .yellow: .yellow
        case .pink: .pink
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .indigo: gradientForColor(self.color)
        case .purple: gradientForColor(self.color)
        case .yellow: gradientForColor(self.color)
        case .pink: gradientForColor(self.color)
        }
    }
    
    var maxHeight: CGFloat {
        switch self {
        case .indigo: return 180
        case .purple: return 160
        case .yellow: return 180
        case .pink: return 160
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .indigo: return 150
        case .purple: return 150
        case .yellow: return 150
        case .pink: return 120
        }
    }
    
    var positionMultiplierAndAddition: (CGFloat, CGFloat) {
        switch self {
        case .indigo: return (1.0, 3.0)
        case .purple: return (4.0, 0.0)
        case .yellow: return (2.0, 0.0)
        case .pink: return (1.0, 0.0)
        }
    }
    
    var speedMultiplier: CGFloat {
        switch self {
        case .indigo: return 2.0
        case .purple: return 1.2
        case .yellow: return 1.2
        case .pink: return 6.0
        }
    }
    
    var smoothingMultiplierAndAddition: (CGFloat, CGFloat) {
        switch self {
        case .indigo: return (1.0, -20.0)
        case .purple: return (1.2, 0.0)
        case .yellow: return (1.2, 0.0)
        case .pink: return (1.4, 0.0)
        }
    }
    
    var strengthAddition: CGFloat {
        switch self {
        case .indigo: return -5.0
        case .purple: return -5.0
        case .yellow: return -5.0
        case .pink: return -25.0
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .indigo: return 0.8
        case .purple: return 0.8
        case .yellow: return 0.8
        case .pink: return 0.8
        }
    }
    
    func gradientForColor(_ color: Color) -> LinearGradient {
        LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7), color.opacity(0.5), color.opacity(0.7), color]), startPoint: .top, endPoint: .bottom)
    }
}

//ShaderLibrary.slowSine(
//    .float(isPresented ? time * 1.0 + 3.0 : 0.0),
//    .float(speed2 * 2.0),
//    .float(smoothing2 * 1.0 - 20.0),
//    .float(strength2 - 5),
//    .float2(proxy.size))
//
//ShaderLibrary.slowSine(
//    .float(isPresented ? time * 4.0 + 0.0 : 0.0),
//    .float(speed2 * 1.2),
//    .float(smoothing2 * 1.2 - 0.0),
//    .float(strength2 - 5.0),
//    .float2(proxy.size))
//
//ShaderLibrary.slowSine(
//    .float(isPresented ? time * 2.0 + 0.0 : 0.0),
//    .float(speed2 * 1.2),
//    .float(smoothing2 * 1.2 - 0.0),
//    .float(strength2 - 5.0),
//    .float2(proxy.size))
//
//ShaderLibrary.slowSine(
//    .float(isPresented ? time * 1.0 + 0.0 : 0.0),
//    .float(speed2 * 6),
//    .float(smoothing2 * 1.4 - 0.0),
//    .float(strength2 - 25.0),
//    .float2(proxy.size))
