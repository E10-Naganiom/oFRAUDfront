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
        VStack (spacing:12){
            ZStack {
                LinearGradient(
                    colors: [.gray, .green],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width:80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(radius: 8)
                Image(systemName:"shield.fill").font(.system(size: 32)).foregroundColor(.blue)
            }
            Text("oFraud")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Unete a nuestra comunidad de proteccion digital")
                .font(.caption)
                .foregroundColor(.primary)
        }.padding(.bottom,20)
        VStack {
            Text("Registro")
                .font(.title.bold())
            Text("Crea una cuenta").font(.title2)
        }
        Form {
            TextField("Nombre", text: $registrationForm.nombre)
            TextField("Correo", text: $registrationForm.correo)
            SecureField("Contrasena", text: $registrationForm.contrasena)
            Button(action: {
                errorMessages = registrationForm.validate()
                if errorMessages.isEmpty{
                    Task{
                        await register()
                    }
                }
                
            }){
                Text("Registrar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
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

