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
    @State private var navigateToRegister = false
    
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
                errorMessages.append("Credenciales invalidas")
            }
            print(error.localizedDescription)
        }
        
    }
    var body: some View {
        NavigationStack {
            VStack (spacing:12){
                ZStack {
                    LinearGradient(
                        colors: [.green, .white],
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
                Text("Proteccion digital al alcance de todos")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom)
            }.padding(.bottom,20)
            VStack(spacing:20){
                Text("Inicio de Sesion").font(.title2.bold()).foregroundColor(.green)
                Text("Ingresa a tu cuenta para continuar")
            }
            Form{
//                Text("Inicio de sesión")
//                    .font(.title)
//                    .foregroundStyle(.blue)
//                    .frame(maxWidth: .infinity)
                Section{
                    VStack(alignment: .leading, spacing:4){
                        Text("Correo electronico").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"envelope.fill")
                            TextField("Correo electrónico", text: $email)
                                .keyboardType(.emailAddress).autocapitalization(.none)
                        }
                    }
                    VStack(alignment: .leading, spacing:4){
                        Text("Contraseña").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"lock.fill")
                            SecureField("Contraseña", text: $password)
                        }
                    }
                    
                    Button(action: {
                        
                        Task{
                            await login()
                        }
                        
                    }){
                        Text("Iniciar sesión")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                VStack(spacing:8){
                    HStack(spacing: 4){
                        Text("No tienes una cuenta?")
                        Text("Registrarse").foregroundColor(.green).bold().onTapGesture {
                            navigateToRegister = true
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    
                    Text ("Al continuar, aceptas nuestros términos de servicio y política de privacidad.").font(.footnote).foregroundColor(.gray).multilineTextAlignment(.center).padding(.top, 8)
                }
                

//                NavigationLink("Registrarse"){
//                    UserRegistration()
//                }
            }
            if(!errorMessages.isEmpty){
                ValidationSummary(errors: errorMessages)
            }
        }.navigationTitle("Login")
            .navigationDestination(isPresented: $navigateToRegister){
                UserRegistration()
            }
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
