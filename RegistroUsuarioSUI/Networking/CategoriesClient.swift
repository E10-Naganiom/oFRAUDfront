//
//  CategoriesClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 02/10/25.
//

import Foundation

struct CategoriesClient {
    func GetAllCategories() async throws -> [CategoryFormResponse] {
        let url = URL(string: "http://10.48.239.74:3000/categories")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode([CategoryFormResponse].self, from: data)
        return response
    }
    
    func GetNivelRiesgo(id: Int) async throws -> String {
        let url = URL(string: "http://10.48.239.74:3000/categories/\(id)/risk-level")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(String.self, from: data)
        return response
    }
    
}
