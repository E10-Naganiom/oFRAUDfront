//
//  IncidentsController.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 30/09/25.
//

import Foundation

struct IncidentsController {
    let incidentsClient: IncidentsClient
    
    init(incidentsClient: IncidentsClient) {
        self.incidentsClient = incidentsClient
    }
    
    func createIncident(titulo:String, id_categoria:Int, nombre_atacante:String?, telefono:String?, correo:String?, user:String?, red_social:String?, descripcion:String, id_usuario:Int, supervisor:Int?, es_anonimo:Bool, evidences:[Data]?) async throws -> IncidentFormResponse {
        return try await incidentsClient.CreateIncident(titulo: titulo, id_categoria: id_categoria, nombre_atacante: nombre_atacante, telefono: telefono, correo: correo, user: user, red_social: red_social, descripcion: descripcion, id_usuario: id_usuario, supervisor: supervisor, es_anonimo: es_anonimo, evidences: evidences)
    }
    
    func updateIncident(
        id: Int,
        titulo: String?,
        id_categoria: Int?,
        nombre_atacante: String?,
        telefono: String?,
        correo: String?,
        user_red: String?,
        red_social: String?,
        descripcion: String?
    ) async throws -> IncidentFormResponse {
        return try await incidentsClient.UpdateIncident(
            id: id,
            titulo: titulo,
            id_categoria: id_categoria,
            nombre_atacante: nombre_atacante,
            telefono: telefono,
            correo: correo,
            user_red: user_red,
            red_social: red_social,
            descripcion: descripcion
        )
    }
    
    func loadHistorial(id: Int) async throws -> [IncidentFormResponse] {
        return try await incidentsClient.GetHistorial(id: id)
    }
    
    func getStatus(id: Int) async throws -> String {
        return try await incidentsClient.GetEstatus(id: id)
    }
    
    func getCompleteName(id: Int) async throws -> String {
        return try await incidentsClient.GetUsuario(id: id)
    }
    
    func getFeed() async throws -> [IncidentFormResponse] {
        return try await incidentsClient.GetFeed()
    }
    
    func getEstadisticas() async throws -> StatsResponse {
        return try await incidentsClient.GetStats()
    }
    
    func getSummaryUser(id: Int) async throws -> SummaryResponse {
        return try await incidentsClient.GetSummaryUser(id: id)
    }
}
