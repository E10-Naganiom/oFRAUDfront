//
//  ProfileClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 15/09/25.
//

import Foundation

class ProfileClient {
    func getUserProfile(token:String) async throws -> UserProfileResponse {
        guard let url = URL(string: "http://10.48.237.103:3000/auth/profile") else {
            fatalError("Invalid URL" + "http://10.48.237.37:3000/auth/profile")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
        return userProfileResponse
    }
    
    func updateUserProfile(id: Int, nombre: String, apellido: String, email: String, contrasena: String, token: String) async throws {
            guard let url = URL(string: "http://10.48.237.103:3000/users/\(id)") else {
                fatalError("Invalid URL")
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any?] = [
                "nombre": nombre,
                "apellido": apellido,
                "email": email,
                "contrasena": contrasena
            ]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        }



}
