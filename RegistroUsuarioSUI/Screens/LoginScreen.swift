//
//  LoginScreen.swift
//  RegistroUsuario452
//

//  Created by Usuario on 05/09/25.

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
        
        // Validar antes de intentar login
        let loginForm = UserLoginForm(correo: email, contrasena: password)
        errorMessages = loginForm.validate()
        
        if !errorMessages.isEmpty {
            return
        }
        
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
            
            ScrollViewReader { proxy in
                Form{
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
                                if !errorMessages.isEmpty {
                                    withAnimation {
                                        proxy.scrollTo("errorSection", anchor: .top)
                                    }
                                }
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
                    
                    // ValidationSummary entre el botón y el registro
                    if(!errorMessages.isEmpty){
                        Section {
                            ValidationSummary(errors: errorMessages)
                        }
                        .id("errorSection")
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
                }
            }
        }
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
            
            if correo.isEmpty{
                errors.append("El correo es requerido")
            }
            if contrasena.isEmpty{
                errors.append("La contraseña es requerida")
            }
            return errors
        }
    }
}
#Preview {
    LoginScreen()
}
