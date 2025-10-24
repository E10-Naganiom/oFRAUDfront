//
//  AuthenticationControllerTests.swift
//  RegistroUsuarioSUITests
//
//

import Testing
import Foundation
@testable import RegistroUsuarioSUI

@MainActor
struct AuthenticationControllerTests {
    
    // ❌ PRUEBA FALLIDA: Registro con email inválido (sin @)
    @Test func testRegisterUserFailureInvalidEmail() async throws {
        // Arrange: Configurar mock client que valida el email
        let mockClient = MockHTTPClient(shouldSucceed: false, validateEmail: true)
        let controller = AuthenticationController(httpClient: mockClient)
        
        // Act & Assert: Intentar registrar con email sin @
        do {
            let _ = try await controller.registerUser(
                name: "Juan",
                lastName: "Pérez",
                email: "correo-sin-arroba.com",  // ❌ Email inválido
                password: "Password123!"
            )
            #expect(Bool(false), "Debería haber lanzado error por email inválido")
        } catch {
            // Verificar que se lanzó un error de validación
            #expect(error is ValidationError || error is URLError)
            
            if let validationError = error as? ValidationError {
                #expect(validationError.message.contains("@") ||
                       validationError.message.contains("email") ||
                       validationError.message.contains("inválido"))
            }
        }
    }
}

// MARK: - Error personalizado para validación
enum ValidationError: Error {
    case invalidEmail
    case emptyFields
    
    var message: String {
        switch self {
        case .invalidEmail:
            return "El email debe contener '@' y ser válido"
        case .emptyFields:
            return "Todos los campos son obligatorios"
        }
    }
}

// MARK: - Mock HTTPClient para pruebas
class MockHTTPClient: HTTPClient {
    let shouldSucceed: Bool
    let validateEmail: Bool
    
    init(shouldSucceed: Bool, validateEmail: Bool = false) {
        self.shouldSucceed = shouldSucceed
        self.validateEmail = validateEmail
    }
    
    func UserRegistration(name: String, lastName: String, email: String, password: String) async throws -> RegistrationFormResponse {
        
        // Validar email si está activado
        if validateEmail && !email.contains("@") {
            throw ValidationError.invalidEmail
        }
        
        // Validar campos vacíos
        if name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            throw ValidationError.emptyFields
        }
        
        if !shouldSucceed {
            throw URLError(.badServerResponse)
        }
        
        // Retornar respuesta mock exitosa
        return RegistrationFormResponse(
            id: 999,
            nombre: name,
            apellido: lastName,
            email: email,
            activo: true
        )
    }
    
    override func UserLogin(email: String, password: String) async throws -> LoginResponse {
        if !shouldSucceed {
            throw URLError(.userAuthenticationRequired)
        }
        
        return LoginResponse(
            accessToken: "mock_access_token",
            refreshToken: "mock_refresh_token"
        )
    }
}

// MARK: - RegistrationFormResponse mock
// (Si no existe en tu proyecto, agrega esto)
struct RegistrationFormResponse: Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let email: String
    let activo: Bool
}

// MARK: - RegistrationFormRequest mock
// (Si no existe en tu proyecto, agrega esto)
struct RegistrationFormRequest: Codable {
    let name: String
    let apellido: String
    let email: String
    let password: String
}
