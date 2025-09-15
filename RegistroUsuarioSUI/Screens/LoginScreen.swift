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
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State var errorMessages: [String] = []
    
    private func login() async {
        await MainActor.run { errorMessages.removeAll()}
        do{
            let success = try await authenticationController.loginUser(email: email, password: password)
            if success {
                isLoggedIn = true
                print("Usuario login exitoso \(isLoggedIn)")
            }
            else{
                await MainActor.run {
                    errorMessages.append("Usuario o contraseña incorrectos")
                }
            }
        }catch{
            await MainActor.run {
                errorMessages.append(error.localizedDescription)
            }
            print(error.localizedDescription)
        }
        
    }
    var body: some View {
        NavigationStack {
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
                Text("Proteccion digital al alcance de todos")
                    .font(.caption)
                    .foregroundColor(.primary)
            }.padding(.bottom,20)
            VStack(spacing:20){
                Text("Inicio de Sesion").font(.title2.bold()).foregroundColor(.gray)
            }
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
                
                Text("No tienes una cuenta?")
                NavigationLink("Registrarse"){
                    UserRegistration()
                }
            }
            if(!errorMessages.isEmpty){
                ValidationSummary(errors: errorMessages)
            }
        }.navigationTitle("Login")
    }
}

extension LoginScreen{
    struct UserLoginForm{
        var correo: String = ""
        var contrasena: String = ""
        
        func validate() -> [String]{
            var errors: [String] = []
            
            if correo.esVacío{
                errors.append( "El correo es requerido")
            }
            if contrasena.esVacío{
                errors.append( "La contrasena es requerida")
            }

            
            return errors
        }
    }
}
#Preview {
    LoginScreen()
}
