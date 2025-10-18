//
//  ProfileClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 15/09/25.
//

import Foundation

class ProfileClient {
    func getUserProfile(token: String) async throws -> UserProfileResponse {
        guard let url = URL(string: "\(APIConfig.baseURL)/auth/profile") else {
            fatalError("Invalid URL" + "\(APIConfig.baseURL)/auth/profile")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
        return userProfileResponse
    }
    
    func updateUserProfile(id: Int, nombre: String, apellido: String, email: String, contrasena: String, token: String) async throws {
        guard let url = URL(string: "\(APIConfig.baseURL)/users/\(id)") else {
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
    
    func changePassword(id: Int, currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(APIConfig.baseURL)/users/\(id)/change-password") else {
            fatalError("Invalid URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "currentPassword": currentPassword,
            "newPassword": newPassword,
            "confirmPassword": confirmPassword
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            print("Contraseña actualizada correctamente")
        case 400:
            let msg = String(data: data, encoding: .utf8) ?? "Solicitud inválida"
            throw NSError(domain: msg, code: 400)
        case 401:
            throw NSError(domain: "No autorizado", code: 401)
        default:
            let msg = String(data: data, encoding: .utf8) ?? "Error desconocido"
            throw NSError(domain: msg, code: httpResponse.statusCode)
        }
    }
    
    func deactivateUser(id: Int) async throws {
        guard let accessToken = TokenStorage.get(identifier: "accessToken") else {
            throw NSError(domain: "Token no encontrado", code: 401)
        }
        
        guard let url = URL(string: "\(APIConfig.baseURL)/users/\(id)/inactivate") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization") // 👈 Aquí se agrega el token

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 401 {
            throw NSError(domain: "No autorizado. Token inválido o expirado", code: 401)
        } else if httpResponse.statusCode == 404 {
            throw NSError(domain: "Usuario no encontrado", code: 404)
        } else if httpResponse.statusCode != 200 {
            throw NSError(domain: "Error del servidor", code: httpResponse.statusCode)
        }

        print("Cuenta desactivada exitosamente")
    }
}
