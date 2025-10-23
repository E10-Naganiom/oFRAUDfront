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
        let controller = IncidentsController(incidensClient: mockClient)
        
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
        let controller = IncidentsController(incidensClient: mockClient)
        
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
        let controller = IncidentsController(incidensClient: mockClient)
        
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
        let controller = IncidentsController(incidensClient: mockClient)
        
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

// MARK: - Mock IncidentsClient para pruebas
class MockIncidentsClient: IncidentsClient {
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
    
    private func createMockIncident(userId: Int) -> IncidentFormResponse {
        return try! IncidentFormResponse(from: MockDecoder(data: [
            "id": 1,
            "titulo": "Incidente de prueba",
            "id_categoria": 1,
            "descripcion": "Descripción del incidente",
            "fecha_creacion": "2025-10-22T10:00:00.000Z",
            "fecha_actualizacion": "2025-10-22T10:00:00.000Z",
            "id_usuario": userId,
            "id_estatus": 1,
            "es_anonimo": false
        ]))
    }
}

// Helper para crear mock decoder
struct MockDecoder: Decoder {
    let data: [String: Any]
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return KeyedDecodingContainer(MockKeyedContainer<Key>(data: data))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("Not implemented")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError("Not implemented")
    }
}

struct MockKeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let data: [String: Any]
    var codingPath: [CodingKey] = []
    var allKeys: [Key] = []
    
    func contains(_ key: Key) -> Bool {
        return data[key.stringValue] != nil
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        return data[key.stringValue] == nil
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return data[key.stringValue] as! Bool
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return data[key.stringValue] as! Int
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        return data[key.stringValue] as! String
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        fatalError("Not fully implemented")
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("Not implemented")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("Not implemented")
    }
    
    func superDecoder() throws -> Decoder {
        fatalError("Not implemented")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("Not implemented")
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String? {
        return data[key.stringValue] as? String
    }
    
    func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int? {
        return data[key.stringValue] as? Int
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T: Decodable {
        return nil
    }
}