//
//  RegistroUsuarioSUIApp.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 22/08/25.
//

import SwiftUI

@main
struct RegistroUsuarioSUIApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
            VStack{
                UserRegistration()
                LoginScreen(onLoginSuccess: {})
            }
        }
    }
}


struct MainAppView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showingRegistration = false
    
    var body: some View {
        if isLoggedIn {
            ProfileScreen()
        } else {
            NavigationView {
                VStack {
                    LoginScreen(onLoginSuccess: {
                                            isLoggedIn = true
                                        })
                    Button("¿No tienes cuenta? Regístrate") {
                        showingRegistration = true
                    }
                    .padding()
                    .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingRegistration) {
                    UserRegistration()
                }
            }
        }
    }
}
