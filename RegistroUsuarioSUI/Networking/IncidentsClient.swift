//
//  IncidentsClient.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 30/09/25.
//

import Foundation

struct IncidentsClient {
    func CreateIncident(titulo: String, id_categoria: Int, nombre_atacante:String?, telefono:String?, correo:String?, user:String?, red_social:String?, descripcion:String, id_usuario:Int, supervisor:Int?, es_anonimo:Bool) async throws -> IncidentFormResponse {
        let requestForm = IncidentFormRequest(titulo: titulo, id_categoria: id_categoria, nombre_atacante: nombre_atacante, telefono: telefono, correo: correo, user: user, red_social: red_social, descripcion: descripcion, id_usuario: id_usuario, supervisor: supervisor, es_anonimo: es_anonimo)
        let url = URL(string: "http://10.48.237.103:3000/incidents")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(requestForm)
        httpRequest.httpBody = jsonData
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(IncidentFormResponse.self, from: data)
        return response
    }
    
}
