//
//  CategoriesController.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 02/10/25.
//

import Foundation

struct CategoriesController {
    let categoriesClient: CategoriesClient
    
    init(categoriesClient: CategoriesClient = CategoriesClient()) {
        self.categoriesClient = categoriesClient
    }
    
    func getAllCategories() async throws -> [CategoryFormResponse] {
        return try await categoriesClient.GetAllCategories()
    }
    
    func getNivelRiesgo(id:Int) async throws -> String {
        return try await categoriesClient.GetNivelRiesgo(id: id)
    }
    
    func getNumRep(id:Int) async throws -> Int {
        return try await categoriesClient.GetStatsCats(id: id)
    }
    
}
