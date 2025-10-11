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

    func CreateIncident(titulo: String, id_categoria: Int, nombre_atacante:String?, telefono:String?, correo:String?, user:String?, red_social:String?, descripcion:String, id_usuario:Int, supervisor:Int?, es_anonimo:Bool) async throws -> IncidentFormResponse {
        let requestForm = IncidentFormRequest(titulo: titulo, id_categoria: id_categoria, nombre_atacante: nombre_atacante, telefono: telefono, correo: correo, user: user, red_social: red_social, descripcion: descripcion, id_usuario: id_usuario, supervisor: supervisor, es_anonimo: es_anonimo)
        let url = URL(string: "http://10.48.239.74:3000/incidents")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(requestForm)
        httpRequest.httpBody = jsonData
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(IncidentFormResponse.self, from: data)
        return response
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
