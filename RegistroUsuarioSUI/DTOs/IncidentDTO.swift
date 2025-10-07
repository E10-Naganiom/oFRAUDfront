//
//  IncidentDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//
 import Foundation

struct Incident: Identifiable, Decodable {
        let id: Int
    let titulo: String
    let status: String
    let createdAt: String
    let lastUpdated: String
    let attachments: Int
}


struct IncidentFormRequest: Codable {
    var titulo: String
    var id_categoria: Int
    var nombre_atacante: String?
    var telefono: String?
    var correo: String?
    var user: String?
    var red_social: String?
    var descripcion: String
    var id_usuario: Int
    var supervisor: Int?
    var es_anonimo: Bool
}

struct IncidentFormResponse: Codable, Identifiable {
    let id: Int
    let titulo: String
    let id_categoria: Int
    let nombre_atacante, telefono, correo, user_red, red_social: String?
    let descripcion, fecha_creacion, fecha_actualizacion: String
    let id_usuario: Int
    let supervisor: Int?
    let id_estatus: Int
    let es_anonimo: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, titulo, id_categoria
        case nombre_atacante = "nombre_atacante"
        case telefono, correo, user_red = "user_red", red_social = "red_social"
        case descripcion, fecha_creacion, fecha_actualizacion
        case id_usuario, supervisor
        case id_estatus, es_anonimo
    }
}
