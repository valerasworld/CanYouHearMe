//
//  Array.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 04.07.25.
//

import Foundation

//extension Array {
//    subscript(safe index: Int) -> Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
