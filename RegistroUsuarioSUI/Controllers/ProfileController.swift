//
//  ProfileController.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//

import Foundation

struct ProfileController {
    let httpClient: HTTPClient
    
    func getAllUsers() async throws -> [User] {
        let users = try await httpClient.getUserList()
        return users
    }
    
    func getUserById(id: Int) async throws -> User {
        let user = try await httpClient.getUserById(id: id)
        return user
    }
    
    func updateUser(id: Int, name: String?, email: String?, password: String?) async throws -> User {
        let updateRequest = UpdateUserRequest(name: name, email: email, password: password)
        let user = try await httpClient.updateUser(id: id, updateRequest: updateRequest)
        return user
    }
}
