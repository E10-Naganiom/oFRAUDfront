//
//  ContentView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 22/08/25.
//

import SwiftUI

struct UserRegistration: View {
    @Environment(\.authController) var authenticationController
    @State var registrationForm = UserRegistrationForm()
    @State var errorMessages: [String] = []
    
    func register() async {
        do{
            let response = try await authenticationController.registerUser(name: registrationForm.nombre, email: registrationForm.correo, password: registrationForm.contrasena)
            print("Usuario registrado con éxito: \(response)")
        }
        catch{
            print("Error al registrar el usuario: \(error)")
        }
    }
    
    
    var body: some View {
        VStack {
            Text("Registro")
                .font(.title)
        }
        Form {
            TextField("Nombre", text: $registrationForm.nombre)
            TextField("Correo", text: $registrationForm.correo)
            SecureField("Contrasena", text: $registrationForm.contrasena)
            Button("Registrar"){
                errorMessages = registrationForm.validate()
                if errorMessages.isEmpty{
                    Task{
                        await register()
                    }
                }
            }
        }
        if !errorMessages.isEmpty{
            ValidationSummary(errors: errorMessages)
        }

    }
}

extension UserRegistration{
    struct UserRegistrationForm{
        var nombre: String = ""
        var correo: String = ""
        var contrasena: String = ""
        
        func validate() -> [String]{
            var errors: [String] = []
            
            if nombre.esVacío{
                errors.append("El nombre es requerido")
            }
            if correo.esVacío{
                errors.append( "El correo es requerido")
            }
            if contrasena.esVacío{
                errors.append( "La contrasena es requerida")
            }
            if !correo.esCorreoValido{
                errors.append("El correo no es valido")
            }
            if !contrasena.esPasswordValido{
                errors.append("La contrasena no cumple con el requerimiento de tener al menos 8 caracteres")
            }
            
            return errors
        }
    }
}

#Preview {
    UserRegistration()
}

