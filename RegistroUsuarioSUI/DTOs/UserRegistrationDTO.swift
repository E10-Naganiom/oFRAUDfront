//
//  UserRegistrationDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 29/08/25.
//

import Foundation


struct RegistrationFormRequest: Codable {
    var name: String
    var apellido: String
    var email: String
    var password: String
}

struct RegistrationFormResponse: Codable {
    let id: Int
    let email, name, apellido, contrasena, salt: String
    let is_admin, is_active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, email, name, apellido
        case contrasena
        case salt
        case is_active, is_admin
    }
}
