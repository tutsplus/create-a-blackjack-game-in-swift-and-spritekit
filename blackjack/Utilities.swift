//
//  Utilities.swift
//  BlackJack
//
//  Created by James Tyner on 3/4/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
