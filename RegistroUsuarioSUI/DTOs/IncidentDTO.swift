//
//  IncidentDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//
 import Foundation
import SwiftUI


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

// ✨ NUEVO: DTO para actualización de incidentes
struct UpdateIncidentRequest: Codable {
    var titulo: String?
    var id_categoria: Int?
    var nombre_atacante: String?
    var telefono: String?
    var correo: String?
    var user_red: String?
    var red_social: String?
    var descripcion: String?
    var supervisor: Int?
    var id_estatus: Int?
}

struct IncidentFormResponse: Codable, Identifiable {
    let id: Int
    let titulo: String
    let id_categoria: Int  // Esto espera Int
    let nombre_atacante: String?
    let telefono: String?
    let correo: String?
    let user_red: String?
    let red_social: String?
    let descripcion: String
    let fecha_creacion: String
    let fecha_actualizacion: String
    let id_usuario: Int
    let id_estatus: Int
    let supervisor: Int?
    let es_anonimo: Bool
    let evidencias: [Evidence]?
    
    enum CodingKeys: String, CodingKey {
        case id, titulo
        case id_categoria = "id_categoria"
        case nombre_atacante, telefono, correo
        case user_red = "user_red"
        case red_social = "red_social"
        case descripcion, fecha_creacion, fecha_actualizacion
        case id_usuario = "id_usuario"
        case id_estatus = "id_estatus"
        case supervisor, es_anonimo, evidencias
    }
    
    // Decodificación personalizada para manejar strings como números
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.titulo = try container.decode(String.self, forKey: .titulo)
        
        // Decodificar id_categoria como Int o String convertido a Int
        if let idCatInt = try? container.decode(Int.self, forKey: .id_categoria) {
            self.id_categoria = idCatInt
        } else {
            let idCatStr = try container.decode(String.self, forKey: .id_categoria)
            self.id_categoria = Int(idCatStr) ?? 0
        }
        
        self.nombre_atacante = try container.decodeIfPresent(String.self, forKey: .nombre_atacante)
        self.telefono = try container.decodeIfPresent(String.self, forKey: .telefono)
        self.correo = try container.decodeIfPresent(String.self, forKey: .correo)
        self.user_red = try container.decodeIfPresent(String.self, forKey: .user_red)
        self.red_social = try container.decodeIfPresent(String.self, forKey: .red_social)
        self.descripcion = try container.decode(String.self, forKey: .descripcion)
        self.fecha_creacion = try container.decode(String.self, forKey: .fecha_creacion)
        self.fecha_actualizacion = try container.decode(String.self, forKey: .fecha_actualizacion)
        
        // Decodificar id_usuario como Int o String
        if let idUserInt = try? container.decode(Int.self, forKey: .id_usuario) {
            self.id_usuario = idUserInt
        } else {
            let idUserStr = try container.decode(String.self, forKey: .id_usuario)
            self.id_usuario = Int(idUserStr) ?? 0
        }
        
        self.id_estatus = try container.decode(Int.self, forKey: .id_estatus)
        self.supervisor = try container.decodeIfPresent(Int.self, forKey: .supervisor)
        
        // Decodificar es_anonimo como Bool o String
        if let esBoolVal = try? container.decode(Bool.self, forKey: .es_anonimo) {
            self.es_anonimo = esBoolVal
        } else {
            let esStr = try container.decode(String.self, forKey: .es_anonimo)
            self.es_anonimo = esStr.lowercased() == "true" || esStr == "1"
        }
        
        self.evidencias = try container.decodeIfPresent([Evidence].self, forKey: .evidencias)
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

struct SummaryResponse: Codable {
    let total_incidentes: Int
    let total_aprobados: Int
    let total_pendientes: Int
    let total_rechazados: Int
    
    enum CodingKeys: String, CodingKey {
        case total_incidentes
        case total_aprobados
        case total_pendientes
        case total_rechazados
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