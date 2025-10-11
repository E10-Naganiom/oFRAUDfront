//
//  IncidentDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//
 import Foundation
import SwiftUICore


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
    let files: [Evidence]?
    
    enum CodingKeys: String, CodingKey {
        case id, titulo, id_categoria
        case nombre_atacante = "nombre_atacante"
        case telefono, correo, user_red = "user_red", red_social = "red_social"
        case descripcion, fecha_creacion, fecha_actualizacion
        case id_usuario, supervisor
        case id_estatus, es_anonimo
        case files
    }
}

struct Evidence : Codable, Identifiable {
    let id: Int
    let id_incidente: Int
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id, id_incidente
        case url
    }
}

func formatISODate(_ isoDateString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]


    if let date = isoFormatter.date(from: isoDateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy" // 👈 formato final
        displayFormatter.timeZone = .current       // convierte a zona local
        displayFormatter.locale = Locale(identifier: "es_MX")
        return displayFormatter.string(from: date)
    } else {
        return isoDateString // fallback
    }
}

func getColorStatus(_ id_estatus: Int) -> Color {
    switch id_estatus {
    case 1:
        return Color.yellow
    case 2:
        return Color.green
    case 3:
        return Color.red
    default:
        return Color.blue
    }
}
