//
//  IncidentsClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 30/09/25.
//

import Foundation

struct IncidentsClient {
    
    struct StatusResponse: Codable {
        let descripcion: String
    }
    struct NameResonse: Codable {
        let nombreCompleto: String
    }

    func CreateIncident(
        titulo: String,
        id_categoria: Int,
        nombre_atacante: String?,
        telefono: String?,
        correo: String?,
        user: String?,
        red_social: String?,
        descripcion: String,
        id_usuario: Int,
        supervisor: Int?,
        es_anonimo: Bool,
        files: [Data]?
    ) async throws -> IncidentFormResponse {
        
        let url = URL(string: "http://10.48.238.32:3000/incidents")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // ⚠️ multipart/form-data boundary
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Agrega los campos JSON manualmente
        let params: [String: Any?] = [
            "titulo": titulo,
            "id_categoria": id_categoria,
            "nombre_atacante": nombre_atacante,
            "telefono": telefono,
            "correo": correo,
            "user": user,
            "red_social": red_social,
            "descripcion": descripcion,
            "id_usuario": id_usuario,
            "supervisor": supervisor,
            "es_anonimo": es_anonimo
        ]
        
        for (key, value) in params {
            if let v = value {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(v)\r\n".data(using: .utf8)!)
            }
        }
        
        // Agrega los archivos adjuntos
        if let files = files {
            for (index, fileData) in files.enumerated() {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files\"; filename=\"evidencia_\(index).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(fileData)
                body.append("\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            print("Codigo de estado: \(httpResponse.statusCode)")
            print("Respuesta", String(data: data, encoding: .utf8) ?? "sin datos")
        }
        return try JSONDecoder().decode(IncidentFormResponse.self, from: data)
    }
    
    func GetHistorial(id: Int) async throws -> [IncidentFormResponse] {
        let url = URL(string: "http://10.48.238.32:3000/incidents/user/\(id)")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode([IncidentFormResponse].self, from: data)
        return response
    }
    
    func GetEstatus(id: Int) async throws -> String {
        let url = URL(string: "http://10.48.238.32:3000/incidents/\(id)/status")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(StatusResponse.self, from: data)
        return response.descripcion
    }
    
    func GetUsuario(id: Int) async throws -> String {
        let url = URL(string: "http://10.48.238.32:3000/incidents/\(id)/username")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(NameResonse.self, from: data)
        return response.nombreCompleto
    }
    
}
