//
//  LoginScreen.swift
//  RegistroUsuario452
//
//  Created by José Molina on 05/09/25.
//

import SwiftUI

struct LoginScreen: View {
    @State var email: String = ""
    @State var password: String = ""
    @Environment(\.authController) var authenticationController
    let onLoginSuccess: () -> Void
    
    private func login() async {
        do{
            let loginResult = try await authenticationController.loginUser(email: email, password: password)
            if loginResult {
                onLoginSuccess()
            }
        }catch{
            print(error.localizedDescription)
        }
        
    }
    var body: some View {
        Form{
            Text("Inicio de sesión")
                .font(.title)
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
            Section{
            TextField("Correo electrónico", text: $email)
                    .keyboardType(.emailAddress)
            SecureField("Contraseña", text: $password)
            
                Button(action: {
                    Task{
                        await login()
                    }
                    
                }){
                    Text("Iniciar sesión")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
        }
    }
}

#Preview {
    LoginScreen(onLoginSuccess: {})
}
