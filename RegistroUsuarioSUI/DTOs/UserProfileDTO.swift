//
//  UserProfileDTO.swift
//  RegistroUsuario452
//
//  Created by Gabriel Gutierrez on 12/09/25.
//

import Foundation

struct UserProfileResponse: Decodable {
    let profile: Profile
}

struct Profile: Decodable {
    let id: Int
    let email, name, passwordHash, salt: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case passwordHash = "password_hash"
        case salt
    }
}
