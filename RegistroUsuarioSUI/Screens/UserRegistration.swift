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
    @State private var acceptedTerms: Bool = false
    
    @State private var showSuccessMessage: Bool = false
    @State private var navigateToLogin: Bool = false
    
    func register() async {
        do{
            let response = try await authenticationController.registerUser(name: registrationForm.nombre, lastName: registrationForm.apellido, email: registrationForm.correo, password: registrationForm.contrasena)
            print("Usuario registrado con éxito: \(response)")
            
            DispatchQueue.main.async {
                showSuccessMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    navigateToLogin = true
                }
            }
            
        }
        catch{
            print("Error al registrar el usuario: \(error)")
            errorMessages.append("Error al registrar el usuario: Datos invalidos o el usuario ya existe.")
        }
    }
    
    
    var body: some View {
        NavigationStack{
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
                Text("Unete a nuestra comunidad de protección digital")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom)
            }.padding(.bottom,20)
            VStack(spacing:20){
                Text("Registro").font(.title2.bold()).foregroundColor(.green)
                Text("Completa tus datos para crear una cuenta")
            }
            Form {
                Section{
                    VStack(alignment: .leading, spacing:4){
                        Text("Nombre").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"person.crop.circle.fill")
                            TextField("Nombre", text: $registrationForm.nombre)
                        }
                    }
                    VStack(alignment: .leading, spacing:4){
                        Text("Apellido").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"person.crop.circle")
                            TextField("Apellido", text: $registrationForm.apellido)
                        }
                    }
                    VStack(alignment: .leading, spacing:4){
                        Text("Correo electrónico").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"envelope.fill")
                            TextField("E-mail", text: $registrationForm.correo)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress).autocapitalization(.none)
                        }
                    }
                    VStack(alignment: .leading, spacing:4){
                        Text("Contraseña").font(.caption).foregroundColor(.gray)
                        HStack{
                            Image(systemName:"lock.fill")
                            SecureField("Contrasena", text: $registrationForm.contrasena)
                        }
                    }
                }
                
                // Terms and conditions section
                Section {
                    HStack(alignment: .top, spacing: 8) {
                        Button(action: {
                            acceptedTerms.toggle()
                        }) {
                            Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                                .foregroundColor(acceptedTerms ? .green : .gray)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        (Text("Acepto los ") +
                         Text("términos de servicio y políticas de privacidad")
                            .foregroundColor(.green)
                            .underline())
                        .font(.footnote)
                        .onTapGesture {
                            // Only trigger on the green text area
                            // TODO: Navigate to terms of service
                            print("Navigate to terms of service")
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section {
                    Button(action: {
                        errorMessages = registrationForm.validate(acceptedTerms: acceptedTerms)
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
                            .background(acceptedTerms ? Color.green : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!acceptedTerms)
                }
                
                VStack(spacing:8){
                    HStack(spacing: 4){
                        Text("Ya tienes una cuenta?")
                        Text("Inicia sesión").foregroundColor(.green).bold().onTapGesture {
                            navigateToLogin = true
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
            }
            if !errorMessages.isEmpty{
                ValidationSummary(errors: errorMessages)
            }
            
        }
        .navigationDestination(isPresented: $navigateToLogin){
            LoginScreen()
        }
        .alert("Registro exitoso", isPresented: $showSuccessMessage){
            Button("Aceptar", role: .cancel){
                navigateToLogin = true
            }
        } message: {
            Text("Se ha registrado con exito. Favor de iniciar sesion.")
        }
    }
}

extension UserRegistration{
    struct UserRegistrationForm{
        var nombre: String = ""
        var apellido: String = ""
        var correo: String = ""
        var contrasena: String = ""
        
        func validate(acceptedTerms: Bool) -> [String]{
            var errors: [String] = []
            
            if nombre.esVacío{
                errors.append("El nombre es requerido")
            }
            if apellido.esVacío{
                errors.append("El apellido es requerido")
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
            if !acceptedTerms{
                errors.append("Debes aceptar los términos de servicio y política de privacidad")
            }
            
            return errors
        }
    }
}

#Preview {
    UserRegistration()
}
