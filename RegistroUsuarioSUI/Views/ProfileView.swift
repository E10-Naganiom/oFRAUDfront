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
    init() {
        self.profileController = ProfileController(profileClient: ProfileClient())
    }
    
    private func loadProfile() async {
        do {
            let p = try await profileController.getProfile()
            await MainActor.run {
                profile.email = p.email
                profile.name = p.name
                profile.password = p.passwordHash
            }
        } catch {
            print("Error al cargar perfil: ", error)
        }
    }
    var body: some View {
        @Bindable var profile = profile
        Form {
            TextField("Nombre", text: $profile.name)
            TextField("Correo", text: $profile.email)
            Button("Update"){
            }
        }
        .task {
            await loadProfile()
        }
    }
}

#Preview {
    ProfileView()
}
