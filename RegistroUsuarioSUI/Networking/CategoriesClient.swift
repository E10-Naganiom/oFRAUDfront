//
//  CategoriesClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 02/10/25.
//

import Foundation

struct CategoriesClient {
    
    struct RiskResponse: Codable {
        let descripcion: String
    }
    
    struct CategoryCountResponse: Codable {
        let id: Int
        let titulo: String
        let count: Int
    }
    
    func GetAllCategories() async throws -> [CategoryFormResponse] {
        let url = URL(string: "\(APIConfig.baseURL)/categories")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode([CategoryFormResponse].self, from: data)
        return response
    }
    
    func GetNivelRiesgo(id: Int) async throws -> String {
        let url = URL(string: "\(APIConfig.baseURL)/categories/\(id)/risk-level")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(RiskResponse.self, from: data)
        return response.descripcion
    }
    
    func GetStatsCats(id: Int) async throws -> Int {
        let url = URL(string: "\(APIConfig.baseURL)/categories/\(id)/report-count")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(CategoryCountResponse.self, from: data)
        return response.count
    }
    
}
