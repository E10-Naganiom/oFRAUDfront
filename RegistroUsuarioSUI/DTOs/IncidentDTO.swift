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
    let evidencias: [Evidence]?
    
    enum CodingKeys: String, CodingKey {
        case id, titulo, id_categoria
        case nombre_atacante = "nombre_atacante"
        case telefono, correo, user_red = "user_red", red_social = "red_social"
        case descripcion, fecha_creacion, fecha_actualizacion
        case id_usuario, supervisor
        case id_estatus, es_anonimo
        case evidencias
    }
}

struct StatsResponse: Codable {
    let total_incidentes: Int
    let total_categorias: Int
    let por_estatus: [IncidentesPorEstatus]
    let por_categoria: [IncidentesPorCategoria]
    let metodos_contacto: [IncidentesPorMetodoContacto]
    let redes_sociales: [IncidentesPorRedesSociales]
    
    enum CodingKeys: String, CodingKey {
        case total_incidentes, total_categorias
        case por_estatus
        case por_categoria
        case metodos_contacto
        case redes_sociales
    }
}
struct IncidentesPorEstatus: Codable {
    let estatus: String
    let total: Int
    let porcentaje: Double
    
    enum CodingKeys: String, CodingKey {
        case estatus
        case total
        case porcentaje
    }
}
struct IncidentesPorCategoria: Codable {
    let titulo: String
    let total: Int
    let porcentaje: Double
    
    enum CodingKeys: String, CodingKey {
        case titulo
        case total
        case porcentaje
    }
}
struct IncidentesPorMetodoContacto : Codable {
    let metodo: String
    let total: Int
    let porcentaje: Double
    
    enum CodingKeys: String, CodingKey {
        case metodo
        case total
        case porcentaje
    }
}

struct IncidentesPorRedesSociales : Codable {
    let nombre: String
    let total: Int
    let porcentaje: Double
    
    enum CodingKeys: String, CodingKey {
        case nombre
        case total
        case porcentaje
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
