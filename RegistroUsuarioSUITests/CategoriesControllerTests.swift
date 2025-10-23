//
//  CategoriesControllerTests.swift
//  RegistroUsuarioSUITests
//
//

import Testing
import Foundation
@testable import RegistroUsuarioSUI

@MainActor
struct CategoriesControllerTests {
    
    // ✅ PRUEBA EXITOSA #3: Lectura exitosa de todas las categorías
    @Test func testGetAllCategoriesSuccess() async throws {
        // Arrange: Configurar mock client con categorías válidas
        let mockClient = MockCategoriesClient(shouldSucceed: true)
        let controller = CategoriesController(categoriesClient: mockClient)
        
        // Simular token válido
        TokenStorage.set(identifier: "accessToken", value: "valid_token_12345")
        
        // Act: Obtener todas las categorías
        let categories = try await controller.getAllCategories()
        
        // Assert: Verificar que se leyeron las categorías correctamente
        #expect(categories.count > 0)
        #expect(categories[0].id > 0)
        #expect(!categories[0].titulo.isEmpty)
        #expect(!categories[0].descripcion.isEmpty)
        #expect(categories[0].id_riesgo > 0)
        
        // Cleanup
        TokenStorage.delete(identifier: "accessToken")
    }
    
    // ❌ PRUEBA FALLIDA #7: Fallo al obtener nivel de riesgo sin autenticación
    @Test func testGetNivelRiesgoFailureNoAuth() async throws {
        // Arrange: Cliente sin autenticación
        let mockClient = MockCategoriesClient(shouldSucceed: false)
        let controller = CategoriesController(categoriesClient: mockClient)
        
        // Eliminar token para simular falta de autenticación
        TokenStorage.delete(identifier: "accessToken")
        
        // Act & Assert: Intentar obtener nivel de riesgo debe fallar
        do {
            let _ = try await controller.getNivelRiesgo(id: 1)
            #expect(Bool(false), "Debería haber fallado por falta de autenticación")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .userAuthenticationRequired)
        }
    }
}

// MARK: - Mock CategoriesClient para pruebas
class MockCategoriesClient: CategoriesClient {
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func GetAllCategories() async throws -> [CategoryFormResponse] {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // Retornar categorías mock
        let category1 = CategoryFormResponse(
            id: 1,
            titulo: "Acoso Cibernético",
            descripcion: "Comportamiento hostil en línea",
            id_riesgo: 3,
            senales: "Mensajes amenazantes",
            prevencion: "No compartir información personal",
            acciones: "Reportar al administrador",
            ejemplos: "Insultos repetitivos en redes sociales"
        )
        
        let category2 = CategoryFormResponse(
            id: 2,
            titulo: "Phishing",
            descripcion: "Intento de robo de información",
            id_riesgo: 5,
            senales: "Correos sospechosos",
            prevencion: "Verificar remitentes",
            acciones: "No hacer clic en enlaces",
            ejemplos: "Email de banco falso"
        )
        
        return [category1, category2]
    }
    
    func GetNivelRiesgo(id: Int) async throws -> String {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // Retornar nivel de riesgo mock según ID
        switch id {
        case 1:
            return "Medio"
        case 2:
            return "Alto"
        default:
            return "Bajo"
        }
    }
    
    func GetStatsCats(id: Int) async throws -> Int {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // Retornar número de reportes mock
        return 15
    }
}