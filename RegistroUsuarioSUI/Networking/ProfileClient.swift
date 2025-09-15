//
//  ProfileClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 15/09/25.
//

import Foundation

class ProfileClient {
    func getUserProfile(token:String) async throws -> UserProfileResponse {
        guard let url = URL(string: "http://10.48.238.97:3000/auth/profile") else {
            fatalError("Invalid URL" + "http://10.48.238.97:3000/auth/profile")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
        return userProfileResponse
    }
}
