//
//  ProfileController.swift
//  RegistroUsuarioSUI
//
//  Created by Gabriel Gutierrez on 12/09/25.
//

import Foundation
import Combine

struct ProfileController {
    
    private var profileClient = ProfileClient()
    
    init(profileClient: ProfileClient) {
        self.profileClient = profileClient
    }
    
    func getProfile() async throws -> ProfileObs {
        guard let accessToken = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        let response = try await profileClient.getUserProfile(token: accessToken)

        let profileObs = ProfileObs()
        profileObs.id = response.profile.id
        profileObs.nombre = response.profile.nombre
        profileObs.apellido = response.profile.apellido
        profileObs.email = response.profile.email
        profileObs.contrasena = response.profile.contrasena
        return profileObs
    }
        
    func updateProfile(_ profile: ProfileObs) async throws {
        let accessToken = TokenStorage.get(identifier: "accessToken")!
        try await profileClient.updateUserProfile(
            id: profile.id,
            nombre: profile.nombre,
            apellido: profile.apellido,
            email: profile.email,
            contrasena: profile.contrasena,
            token: accessToken
        )
    }
    
    func changePassword(id: Int, currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        let accessToken = TokenStorage.get(identifier: "accessToken")!
        try await profileClient.changePassword(
            id: id,
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
            token: accessToken
        )
    }
    
    func deactivateAccount(id: Int) async throws {
        let accessToken = TokenStorage.get(identifier: "accessToken")!
        try await profileClient.deactivateUser(id: id)
    }

}
