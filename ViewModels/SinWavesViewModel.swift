//
//  SinWavesViewModel.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 02/07/25.
//

import SwiftUI

@Observable
class SinWavesViewModel {
    var startTime = Date.now
    var speed = 0.1
    var smoothing = 96.0
    var strength = 49.0
    var nearT = 5.0
    var nearPosX = 40.0
    var isPresented: Bool = false
}
