//
//  CollectionExtension.swift
//  Inbbbox
//
//  Created by Patryk Kaczmarek on 30/12/15.
//  Copyright © 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension CollectionType {
    
    /// Shuffle CollectionType.
    ///
    /// - returns: Same collection with random order of elements.
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

private extension MutableCollectionType where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
