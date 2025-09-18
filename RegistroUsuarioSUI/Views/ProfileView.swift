//
//  ProfileView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 15/09/25.
//

import SwiftUI

struct ProfileView: View {
    var profileController: ProfileController
    @State var profile = ProfileObs()
    @State private var isLoading = true
    @State private var showUpdateSuccess = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    init() {
        self.profileController = ProfileController(profileClient: ProfileClient())
    }
    
    private func loadProfile() async {
        do {
            let p = try await profileController.getProfile()
            await MainActor.run {
                profile.email = p.email
                profile.name = p.name
                profile.password = p.password
                isLoading = false
            }
        } catch {
            print("Error al cargar perfil: ", error)
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func updateProfile() async {
        do {
            try await profileController.updateProfile(profile)
            print("Usuario actualizado con exito")
        } catch {
            print("Error al actualizar el perfil: ", error)
        }
    }
    var body: some View {
        @Bindable var profile = profile
        Group{
            if isLoading {
                ProgressView("Cargando perfil ...")
            }
            else {
                Form{
                    Section(header: Text("Informacion de usuario")){
                        TextField("Nombre", text: $profile.name)
                        TextField("Correo", text: $profile.email)
                    }
                    Section {
                        Button("Actualizar datos"){
                            Task { await updateProfile()}
                        }.buttonStyle(.borderedProminent)
                    }
                    Section{
                        Button("Cerrar sesion", role: .destructive){
                            TokenStorage.delete(identifier: "accessToken")
                            TokenStorage.delete(identifier: "refreshToken")
                            isLoggedIn = false
                        }
                    }
                }
            }
        }
        .task {
            await loadProfile()
        }
        .alert("Perfil actualizado", isPresented: $showUpdateSuccess){
            Button("OK", role: .cancel) {}
        }

    }
}

#Preview {
    ProfileView()
}
