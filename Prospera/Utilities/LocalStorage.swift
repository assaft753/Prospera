//
//  LocalStorage.swift
//  Prospera
//
//  Created by Assaf Tayouri on 08/12/2020.
//

import Foundation

// Struct that handles local storage actions
struct LocalStorage {
    
    private let defaults: UserDefaults
    
    init() {
        defaults = .standard
    }
    
    func store<T>(for key: String, value: T) {
        defaults.setValue(value, forKey: key)
    }
    
    func read<T>(for key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
}
