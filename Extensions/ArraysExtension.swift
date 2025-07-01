//
//  ArraysExtension.swift
//  CanYouHearMe
//
//  Created by Valery Zazulin on 04.02.25.
//

extension Array {
    func splitInHalfs() -> [[Element]] {
        let count = self.count
        let half = count / 2
        let leftPart = self[0 ..< half]
        let rightPart = self[half ..< count]
        return [Array(leftPart), Array(rightPart)]
    }
}
