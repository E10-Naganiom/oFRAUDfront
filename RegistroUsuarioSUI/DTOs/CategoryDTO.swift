//
//  CategoryDTO.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 02/10/25.
//

//struct CategoryFormRequest: Codable {
//    var titulo: String
//    var descripcion: String
//    var id_riesgo: Int
//    var senales: String?
//    var prevencion: String?
//    var acciones: String?
//    var ejemplos: String?
//}

struct CategoryFormResponse: Codable, Identifiable {
    let id: Int
    var titulo: String
    var descripcion: String
    var id_riesgo: Int
    var senales: String?
    var prevencion: String?
    var acciones: String?
    var ejemplos: String?
    
    enum CodingKeys: String, CodingKey {
        case id, titulo, descripcion, id_riesgo
        case senales, prevencion, acciones, ejemplos
    }
}
