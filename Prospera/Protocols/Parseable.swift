//
//  Parseable.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Protocol for parsing movies
protocol Parseable {
    
    // the generic way
    associatedtype T
    
    func parse(from data: Data) throws -> T
}
