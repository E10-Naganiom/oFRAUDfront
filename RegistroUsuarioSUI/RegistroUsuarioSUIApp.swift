//
//  RegistroUsuarioSUIApp.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 22/08/25.
//

import SwiftUI

@main
struct RegistroUsuarioSUIApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeScreen()
            }
            else{
                NavigationStack{
                    LoginScreen()
                }
            }
        }
    }
}
