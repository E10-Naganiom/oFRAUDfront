//
//  TokenStorage.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 05/09/25.
//

import Foundation

struct TokenStorage {
    static func set(identifier: String, value: String){
        UserDefaults.standard.set(value, forKey: identifier)
    }
    
    static func get(identifier: String) -> String? {
        return UserDefaults.standard.string(forKey: identifier)
    }
}
