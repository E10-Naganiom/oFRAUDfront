//
//  ProfileController.swift
//  RegistroUsuario452
//
//  Created by Gabriel gUTIERREZ on 12/09/25.
//

import Foundation
import Combine

struct ProfileController {
    
    private var profileClient = ProfileClient()
    
    init(profileClient: ProfileClient) {
        self.profileClient = profileClient
    }
    
    func getProfile() async throws -> ProfileObs {
            let accessToken = TokenStorage.get(identifier: "accessToken")!
            let response = try await profileClient.getUserProfile(token: accessToken)


            let profileObs = ProfileObs()
            profileObs.id = response.profile.id
            profileObs.name = response.profile.name
            profileObs.email = response.profile.email
            profileObs.password = response.profile.passwordHash
            return profileObs
        }
        
        func updateProfile(_ profile: ProfileObs) async throws {
            let accessToken = TokenStorage.get(identifier: "accessToken")!
            try await profileClient.updateUserProfile(
                id: profile.id,
                name: profile.name,
                email: profile.email,
                password: profile.password,
                token: accessToken
            )
        }



}
