//
//  Set.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Extension for adding functionality for converting Set to Array
extension Set {
    func toArray() -> [Element] {
        return Array(self)
    }
}
