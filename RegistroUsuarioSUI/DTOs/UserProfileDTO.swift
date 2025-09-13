//
//  UserProfileDTO.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let name: String
    let passwordHash: String
    let salt: String
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case passwordHash = "password_hash"
        case salt
    }
}

struct UpdateUserRequest: Codable {
    var name: String?
    var email: String?
    var password: String?
}

struct UserListResponse: Codable {
    let users: [User]
}
