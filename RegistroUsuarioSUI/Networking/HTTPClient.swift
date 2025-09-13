//
//  HTTPClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 29/08/25.
//

import Foundation

struct HTTPClient {
    func UserRegistration(name: String, email:String, password:String) async throws -> RegistrationFormResponse {
        let requestForm = RegistrationFormRequest(name: name, email: email, password: password)
        let url = URL(string: "http://10.48.238.97:3000/users")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(requestForm)
        httpRequest.httpBody = jsonData
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(RegistrationFormResponse.self, from: data)
        return response                   
    }
    
    func UserLogin(email: String, password: String) async throws -> LoginResponse {
        let loginRequest = LoginRequest(email: email, password: password)
        guard let url = URL(string: "http://10.48.238.97:3000/auth/login") else {
            fatalError( "Invalid URL" + "http://10.48.238.97:3000/auth/login")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(loginRequest)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return loginResponse
    }
    
    func getUserList() async throws -> [User] {
            let url = URL(string: "http://10.48.184.191:3000/user/list")!
            var httpRequest = URLRequest(url: url)
            httpRequest.httpMethod = "GET"
            httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = TokenStorage.get(identifier: "accessToken") {
                httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, _) = try await URLSession.shared.data(for: httpRequest)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        }
        
        func getUserById(id: Int) async throws -> User {
            let url = URL(string: "http://10.48.184.191:3000/user/\(id)")!
            var httpRequest = URLRequest(url: url)
            httpRequest.httpMethod = "GET"
            httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = TokenStorage.get(identifier: "accessToken") {
                httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let (data, _) = try await URLSession.shared.data(for: httpRequest)
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        }
        
        func updateUser(id: Int, updateRequest: UpdateUserRequest) async throws -> User {
            let url = URL(string: "http://10.48.184.191:3000/user/\(id)")!
            var httpRequest = URLRequest(url: url)
            httpRequest.httpMethod = "PUT"
            httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let token = TokenStorage.get(identifier: "accessToken") {
                httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let jsonData = try JSONEncoder().encode(updateRequest)
            httpRequest.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: httpRequest)
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        }
}
