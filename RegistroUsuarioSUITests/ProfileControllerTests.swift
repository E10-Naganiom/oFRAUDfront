//
//  ProfileControllerTests.swift
//  RegistroUsuarioSUITests
//
//

import Testing
import Foundation
@testable import RegistroUsuarioSUI

@MainActor
struct ProfileControllerTests {
    
    // ✅ PRUEBA EXITOSA #1: Lectura exitosa de perfil de usuario
    @Test func testGetProfileSuccess() async throws {
        // Arrange: Configurar mock client que retorna datos válidos
        let mockClient = MockProfileClient(shouldSucceed: true)
        let controller = ProfileController(profileClient: mockClient)
        
        // Simular que hay un token válido guardado
        TokenStorage.set(identifier: "accessToken", value: "valid_token_12345")
        
        // Act: Obtener el perfil
        let profile = try await controller.getProfile()
        
        // Assert: Verificar que los datos se leyeron correctamente
        #expect(profile.id > 0)
        #expect(!profile.nombre.isEmpty)
        #expect(!profile.apellido.isEmpty)
        #expect(!profile.email.isEmpty)
        #expect(profile.email.contains("@"))
        
        // Cleanup
        TokenStorage.delete(identifier: "accessToken")
    }
    
    // ❌ PRUEBA FALLIDA #5: Fallo por token inválido o inexistente
    @Test func testGetProfileFailureNoToken() async throws {
        // Arrange: Configurar cliente sin token
        let mockClient = MockProfileClient(shouldSucceed: false)
        let controller = ProfileController(profileClient: mockClient)
        
        // Asegurar que NO hay token guardado
        TokenStorage.delete(identifier: "accessToken")
        
        // Act & Assert: Intentar obtener perfil debe lanzar error
        do {
            let _ = try await controller.getProfile()
            #expect(Bool(false), "Debería haber lanzado un error por falta de token")
        } catch {
            // Se espera un error de autenticación
            #expect(error is URLError)
            let urlError = error as! URLError
            #expect(urlError.code == .userAuthenticationRequired)
        }
    }
}

// MARK: - Protocol para ProfileClient
protocol ProfileClientProtocol {
    func getUserProfile(token: String) async throws -> UserProfileResponse
    func updateUserProfile(id: Int, nombre: String, apellido: String, email: String, contrasena: String, token: String) async throws
    func changePassword(id: Int, currentPassword: String, newPassword: String, confirmPassword: String) async throws
    func deactivateUser(id: Int) async throws
}

// MARK: - Extension para que ProfileClient conforme al protocolo
extension ProfileClient: ProfileClientProtocol {}

// MARK: - Mock ProfileClient para pruebas
class MockProfileClient: ProfileClientProtocol {
    let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func getUserProfile(token: String) async throws -> UserProfileResponse {
        if token.isEmpty {
            throw URLError(.userAuthenticationRequired)
        }
        
        if !shouldSucceed {
            throw URLError(.userAuthenticationRequired)
        }
        
        // Retornar datos mock exitosos
        let mockProfile = Profile(
            id: 123,
            email: "usuario@test.com",
            nombre: "Juan",
            apellido: "Pérez",
            contrasena: "hashed_password",
            salt: "mock_salt"
        )
        
        return UserProfileResponse(profile: mockProfile)
    }
    
    func updateUserProfile(id: Int, nombre: String, apellido: String, email: String, contrasena: String, token: String) async throws {
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
    }
    
    func changePassword(id: Int, currentPassword: String, newPassword: String, confirmPassword: String) async throws {
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
    }
    
    func deactivateUser(id: Int) async throws {
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
    }
}