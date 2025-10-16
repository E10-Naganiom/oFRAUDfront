//
//  ProfileView.swift
//  RegistroUsuarioSUI
//

import SwiftUI

struct ProfileView: View {
    var profileController: ProfileController
    @State var profile = ProfileObs()
    @State private var isLoading = true
    @State private var showUpdateSuccess = false
    @State private var isEditing = false
    @State private var showChangePassword = false
    @State private var showDeactivateConfirmation = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    init(profileController: ProfileController = ProfileController(profileClient: ProfileClient())) {
        self.profileController = profileController
    }
    
    private func loadProfile() async {
        do {
            let p = try await profileController.getProfile()
            await MainActor.run {
                profile.email = p.email
                profile.nombre = p.nombre
                profile.apellido = p.apellido
                profile.contrasena = p.contrasena
                isLoading = false
            }
        } catch {
            print("Error al cargar perfil: ", error)
            await MainActor.run { isLoading = false }
        }
    }
    
    private func updateProfile() async {
        do {
            try await profileController.updateProfile(profile)
            print("Usuario actualizado con éxito")
            await MainActor.run { showUpdateSuccess = true }
        } catch {
            print("Error al actualizar perfil: ", error)
        }
    }
    
    private func deactivateAccount() async {
        do {
            try await profileController.deactivateAccount(id: profile.id)
            print("Cuenta desactivada correctamente")
            await MainActor.run {
                TokenStorage.delete(identifier: "accessToken")
                TokenStorage.delete(identifier: "refreshToken")
                isLoggedIn = false
            }
        } catch {
            print("Error al desactivar cuenta: ", error)
        }
    }

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Avatar con letra centrada
                ZStack(alignment: .bottomTrailing) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 120, height: 120)
                        
                        Text(String(profile.nombre.prefix(1)).uppercased())
                            .font(.system(size: 64, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    // Botón lápiz
                    Button(action: { isEditing.toggle() }) {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 32))
                            .background(Color.white.clipShape(Circle()))
                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    }
                    .offset(x: 5, y: 5)
                }
                
                Text("Hola, \(profile.nombre)")
                    .font(.title2.bold())
                
                if isLoading {
                    ProgressView("Cargando perfil...")
                        .padding()
                } else {
                    VStack(spacing: 16) {
                        // Información editable
                        Group {
                            HStack {
                                Text("Nombre:")
                                    .bold()
                                if isEditing {
                                    TextField("Nombre", text: $profile.nombre)
                                        .textFieldStyle(.roundedBorder)
                                } else {
                                    Text(profile.nombre)
                                }
                            }
                            HStack {
                                Text("Apellido:")
                                    .bold()
                                if isEditing {
                                    TextField("Apellido", text: $profile.apellido)
                                        .textFieldStyle(.roundedBorder)
                                } else {
                                    Text(profile.apellido)
                                }
                            }
                            HStack {
                                Text("Correo:")
                                    .bold()
                                if isEditing {
                                    TextField("Correo", text: $profile.email)
                                        .textFieldStyle(.roundedBorder)
                                } else {
                                    Text(profile.email)
                                }
                            }
                        }
                        
                        if isEditing {
                            Button("Guardar cambios") {
                                Task { await updateProfile() }
                                isEditing = false
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        }
                        
                        // Botón cambiar contraseña
                        Button(action: { showChangePassword.toggle() }) {
                            HStack {
                                Image(systemName: "key.fill")
                                Text("Cambiar contraseña")
                            }
                            .foregroundColor(.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        
                        // Botón desactivar cuenta
                        Button(action: { showDeactivateConfirmation = true }) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Desactivar cuenta")
                            }
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.top, 10)
                        
                        // Botón cerrar sesión
                        Button("Cerrar sesión", role: .destructive) {
                            TokenStorage.delete(identifier: "accessToken")
                            TokenStorage.delete(identifier: "refreshToken")
                            isLoggedIn = false
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Mi Perfil")
        .alert("Perfil actualizado", isPresented: $showUpdateSuccess) {
            Button("OK", role: .cancel) {}
        }
        .alert("¿Estás seguro?", isPresented: $showDeactivateConfirmation) {
            Button("Cancelar", role: .cancel) {}
            Button("Desactivar", role: .destructive) {
                Task {
                    await deactivateAccount()
                }
            }
        } message: {
            Text("Esta acción desactivará tu cuenta. Podrás reactivarla iniciando sesión nuevamente.")
        }
        .sheet(isPresented: $showChangePassword) {
            ChangePasswordView(profileController: profileController, userId: profile.id)
                .presentationDetents([.medium, .large])
        }
        .task { await loadProfile() }
    }
}

struct ChangePasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var profileController: ProfileController
    var userId: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Cambiar contraseña")) {
                    SecureField("Contraseña actual", text: $currentPassword)
                    SecureField("Nueva contraseña", text: $newPassword)
                    SecureField("Confirmar nueva contraseña", text: $confirmPassword)
                }
                
                Section {
                    Button("Actualizar contraseña") {
                        Task {
                            await changePassword()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                    Button("Cancelar", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Contraseña actualizada", isPresented: $showSuccessAlert) {
                Button("OK") { dismiss() }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func changePassword() async {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Por favor completa todos los campos"
            showErrorAlert = true
            return
        }
        
        do {
            try await profileController.changePassword(
                id: userId,
                currentPassword: currentPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            )
            await MainActor.run { showSuccessAlert = true }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    ProfileView()
}
