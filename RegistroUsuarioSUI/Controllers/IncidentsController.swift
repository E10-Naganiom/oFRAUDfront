//
//  IncidentsController.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 30/09/25.
//

import Foundation

struct IncidentsController {
    let incidensClient: IncidentsClient
    
    func createIncident(titulo:String, id_categoria:Int, nombre_atacante:String?, telefono:String?, correo:String?, user:String?, red_social:String?, descripcion:String, id_usuario:Int, supervisor:Int?, es_anonimo:Bool) async throws -> IncidentFormResponse {
        return try await incidensClient.CreateIncident(titulo: titulo, id_categoria: id_categoria, nombre_atacante: nombre_atacante, telefono: telefono, correo: correo, user: user, red_social: red_social, descripcion: descripcion, id_usuario: id_usuario, supervisor: supervisor, es_anonimo: es_anonimo)
    }
    
    func loadHistorial(id: Int) async throws -> [IncidentFormResponse] {
        return try await incidensClient.GetHistorial(id: id)
    }
    
}
