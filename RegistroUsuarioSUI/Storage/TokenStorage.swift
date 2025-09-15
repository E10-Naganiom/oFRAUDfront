//
//  TokenStorage.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 05/09/25.
//

import Foundation

struct TokenStorage {
    @discardableResult
    static func set(identifier: String, value: String) -> Bool {
        UserDefaults.standard.set(value, forKey: identifier)
        return true
    }
    
    static func get(identifier: String) -> String? {
        return UserDefaults.standard.string(forKey: identifier)
    }
    
    @discardableResult
    static func delete(identifier: String) -> Bool {
        let existed = UserDefaults.standard.object(forKey: identifier) != nil
        if existed {
            UserDefaults.standard.removeObject(forKey: identifier)
        }
        return existed
    }
}
