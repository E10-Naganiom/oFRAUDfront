import Foundation

struct IncidentsClient {
    
    struct StatusResponse: Codable {
        let descripcion: String
    }
    
    struct NameResponse: Codable {
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
        evidences: [Data]?
    ) async throws -> IncidentFormResponse {
        
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        
        // ✅ AGREGAR TOKEN
        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        httpRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Agregar campos de texto
        addFormField(&body, name: "titulo", value: titulo, boundary: boundary)
        addFormField(&body, name: "id_categoria", value: String(id_categoria), boundary: boundary)
        addFormField(&body, name: "nombre_atacante", value: nombre_atacante ?? "", boundary: boundary)
        addFormField(&body, name: "telefono", value: telefono ?? "", boundary: boundary)
        addFormField(&body, name: "correo", value: correo ?? "", boundary: boundary)
        addFormField(&body, name: "user_red", value: user ?? "", boundary: boundary)
        addFormField(&body, name: "red_social", value: red_social ?? "", boundary: boundary)
        addFormField(&body, name: "descripcion", value: descripcion, boundary: boundary)
        addFormField(&body, name: "id_usuario", value: String(id_usuario), boundary: boundary)
        if let supervisor = supervisor {
            addFormField(&body, name: "supervisor", value: String(supervisor), boundary: boundary)
        }
        addFormField(&body, name: "es_anonimo", value: es_anonimo ? "1" : "0", boundary: boundary)
        
        // Agregar archivos de fotos
        if let evidences = evidences, !evidences.isEmpty {
            for (index, imageData) in evidences.enumerated() {
                addFormFile(&body, name: "files", filename: "image_\(index).jpg", data: imageData, boundary: boundary)
            }
        }
        
        // Cerrar boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        httpRequest.httpBody = body
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        if let jsonString = String(data: data, encoding: .utf8){
            print("JSON: ", jsonString)
        }
        let response = try JSONDecoder().decode(IncidentFormResponse.self, from: data)
        return response
    }
    
    private func addFormField(_ body: inout Data, name: String, value: String, boundary: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    private func addFormFile(_ body: inout Data, name: String, filename: String, data: Data, boundary: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)
    }
    
    func GetHistorial(id: Int) async throws -> [IncidentFormResponse] {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/user/\(id)")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode([IncidentFormResponse].self, from: data)
        return response
    }
    
    func GetEstatus(id: Int) async throws -> String {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/\(id)/status")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(StatusResponse.self, from: data)
        return response.descripcion
    }
    
    func GetUsuario(id: Int) async throws -> String {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/\(id)/username")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(NameResponse.self, from: data)
        return response.nombreCompleto
    }
    
    func GetFeed() async throws -> [IncidentFormResponse] {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/recent/incidents")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode([IncidentFormResponse].self, from: data)
        return response
    }
    
    func GetStats() async throws -> StatsResponse {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/statistics/summary")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(StatsResponse.self, from: data)
        return response
    }
    
    func GetSummaryUser(id: Int) async throws -> SummaryResponse {
        // ✅ OBTENER TOKEN
        guard let token = TokenStorage.get(identifier: "accessToken") else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let url = URL(string: "\(APIConfig.baseURL)/incidents/user/\(id)/summary")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ AGREGAR TOKEN
        httpRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(SummaryResponse.self, from: data)
        return response
    }
    
}
