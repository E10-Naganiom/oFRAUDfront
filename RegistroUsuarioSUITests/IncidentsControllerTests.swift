//
//  IncidentsControllerTests.swift
//  RegistroUsuarioSUITests
//
//

import Testing
import Foundation
@testable import RegistroUsuarioSUI

@MainActor
struct IncidentsControllerTests {
    
    // ✅ PRUEBA EXITOSA #2: Lectura exitosa de historial de incidentes
    @Test func testLoadHistorialSuccess() async throws {
        // Arrange: Configurar mock client con datos válidos
        let mockClient = MockIncidentsClient(shouldSucceed: true)
        let controller = IncidentsController(incidentsClient: mockClient)
        
        // Simular token válido
        TokenStorage.set(identifier: "accessToken", value: "valid_token_12345")
        
        // Act: Cargar historial de usuario con ID 1
        let historial = try await controller.loadHistorial(id: 1)
        
        // Assert: Verificar que se leyeron incidentes
        #expect(historial.count > 0)
        #expect(historial[0].id > 0)
        #expect(!historial[0].titulo.isEmpty)
        #expect(!historial[0].descripcion.isEmpty)
        #expect(historial[0].id_usuario == 1)
        
        // Cleanup
        TokenStorage.delete(identifier: "accessToken")
    }
    
    // ✅ PRUEBA EXITOSA #4: Lectura exitosa de feed de incidentes recientes
    @Test func testGetFeedSuccess() async throws {
        // Arrange
        let mockClient = MockIncidentsClient(shouldSucceed: true)
        let controller = IncidentsController(incidentsClient: mockClient)
        
        TokenStorage.set(identifier: "accessToken", value: "valid_token_12345")
        
        // Act: Obtener feed de incidentes recientes
        let feed = try await controller.getFeed()
        
        // Assert: Verificar que hay incidentes en el feed
        #expect(feed.count > 0)
        #expect(feed[0].id > 0)
        #expect(!feed[0].titulo.isEmpty)
        
        // Cleanup
        TokenStorage.delete(identifier: "accessToken")
    }
    
    // ❌ PRUEBA FALLIDA #6: Fallo al obtener status sin token de autenticación
    @Test func testGetStatusFailureNoToken() async throws {
        // Arrange: Cliente configurado para fallar
        let mockClient = MockIncidentsClient(shouldSucceed: false)
        let controller = IncidentsController(incidentsClient: mockClient)
        
        // Asegurar que NO hay token
        TokenStorage.delete(identifier: "accessToken")
        
        // Act & Assert: Intentar obtener status debe fallar
        do {
            let _ = try await controller.getStatus(id: 1)
            #expect(Bool(false), "Debería haber lanzado error por falta de autenticación")
        } catch {
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .userAuthenticationRequired)
        }
    }
    
    // ❌ PRUEBA FALLIDA #8: Fallo al obtener estadísticas con datos inválidos
    @Test func testGetEstadisticasFailureInvalidResponse() async throws {
        // Arrange: Cliente que simula respuesta inválida del servidor
        let mockClient = MockIncidentsClient(shouldSucceed: false, invalidData: true)
        let controller = IncidentsController(incidentsClient: mockClient)
        
        TokenStorage.set(identifier: "accessToken", value: "valid_token")
        
        // Act & Assert: Obtener estadísticas debe fallar por datos corruptos
        do {
            let _ = try await controller.getEstadisticas()
            #expect(Bool(false), "Debería fallar por datos inválidos del servidor")
        } catch {
            // Se espera un error de decodificación o servidor
            #expect(error is DecodingError || error is URLError)
        }
        
        // Cleanup
        TokenStorage.delete(identifier: "accessToken")
    }
}

// MARK: - Protocol para IncidentsClient
protocol IncidentsClientProtocol {
    func CreateIncident(
        titulo: String,
        id_categoria: Int,
        nombre_atacante: String?,
        telefono: String?,
        correo: String?,
        user: String?,
        red_social: String?,
        descripcion: String,
        id_usuario: Int,
        supervisor: Int?,
        es_anonimo: Bool,
        evidences: [Data]?
    ) async throws -> IncidentFormResponse
    
    func UpdateIncident(
        id: Int,
        titulo: String?,
        id_categoria: Int?,
        nombre_atacante: String?,
        telefono: String?,
        correo: String?,
        user_red: String?,
        red_social: String?,
        descripcion: String?
    ) async throws -> IncidentFormResponse
    
    func GetHistorial(id: Int) async throws -> [IncidentFormResponse]
    func GetEstatus(id: Int) async throws -> String
    func GetUsuario(id: Int) async throws -> String
    func GetFeed() async throws -> [IncidentFormResponse]
    func GetStats() async throws -> StatsResponse
    func GetSummaryUser(id: Int) async throws -> SummaryResponse
}

// MARK: - Extension para que IncidentsClient conforme al protocolo
extension IncidentsClient: IncidentsClientProtocol {}

// MARK: - Mock IncidentsClient para pruebas
struct MockIncidentsClient: IncidentsClientProtocol {
    let shouldSucceed: Bool
    let invalidData: Bool
    
    init(shouldSucceed: Bool, invalidData: Bool = false) {
        self.shouldSucceed = shouldSucceed
        self.invalidData = invalidData
    }
    
    func GetHistorial(id: Int) async throws -> [IncidentFormResponse] {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // Retornar datos mock
        let mockIncident = createMockIncident(userId: id)
        return [mockIncident]
    }
    
    func GetFeed() async throws -> [IncidentFormResponse] {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        let mockIncident = createMockIncident(userId: 1)
        return [mockIncident, mockIncident]
    }
    
    func GetEstatus(id: Int) async throws -> String {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        return "Pendiente"
    }
    
    func GetStats() async throws -> StatsResponse {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if invalidData || !shouldSucceed {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Datos inválidos del servidor"
                )
            )
        }
        
        // Retornar estadísticas mock
        return StatsResponse(
            total_incidentes: 10,
            total_categorias: 5,
            por_estatus: [],
            por_categoria: [],
            metodos_contacto: [],
            redes_sociales: []
        )
    }
    
    func GetUsuario(id: Int) async throws -> String {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        return "Juan Pérez"
    }
    
    func GetSummaryUser(id: Int) async throws -> SummaryResponse {
        guard TokenStorage.get(identifier: "accessToken") != nil else {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        return SummaryResponse(
            total_incidentes: 5,
            total_aprobados: 3,
            total_pendientes: 1,
            total_rechazados: 1
        )
    }
    
    func CreateIncident(
        titulo: String,
        id_categoria: Int,
        nombre_atacante: String?,
        telefono: String?,
        correo: String?,
        user: String?,
        red_social: String?,
        descripcion: String,
        id_usuario: Int,
        supervisor: Int?,
        es_anonimo: Bool,
        evidences: [Data]?
    ) async throws -> IncidentFormResponse {
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        return createMockIncident(userId: id_usuario)
    }
    
    func UpdateIncident(
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
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        return createMockIncident(userId: 1)
    }
    
    private func createMockIncident(userId: Int) -> IncidentFormResponse {
        // Crear un incidente mock manualmente
        let mockData: [String: Any] = [
            "id": 1,
            "titulo": "Incidente de prueba",
            "id_categoria": 1,
            "descripcion": "Descripción del incidente",
            "fecha_creacion": "2025-10-22T10:00:00.000Z",
            "fecha_actualizacion": "2025-10-22T10:00:00.000Z",
            "id_usuario": userId,
            "id_estatus": 1,
            "es_anonimo": false
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: mockData)
        let decoder = JSONDecoder()
        return try! decoder.decode(IncidentFormResponse.self, from: jsonData)
    }
}