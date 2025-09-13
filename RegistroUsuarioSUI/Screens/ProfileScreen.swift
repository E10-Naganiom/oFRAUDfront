//
//  ProfileScreen.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.profileController) var profileController
    @State private var users: [User] = []
    @State private var selectedUser: User?
    @State private var showingUserDetail = false
    @State private var showingEditUser = false
    @State private var errorMessage: String = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Gestión de Usuarios")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity)
                
                if isLoading {
                    ProgressView("Cargando usuarios...")
                        .padding()
                } else {
                    List(users) { user in
                        UserRowView(user: user) {
                            selectedUser = user
                            showingUserDetail = true
                        } onEdit: {
                            selectedUser = user
                            showingEditUser = true
                        }
                    }
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Perfiles")
            .onAppear {
                Task {
                    await loadUsers()
                }
            }
            .refreshable {
                await loadUsers()
            }
        }
        .sheet(isPresented: $showingUserDetail) {
            if let user = selectedUser {
                UserDetailView(user: user)
            }
        }
        .sheet(isPresented: $showingEditUser) {
            if let user = selectedUser {
                EditUserView(user: user) { updatedUser in
                    if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
                        users[index] = updatedUser
                    }
                    showingEditUser = false
                }
            }
        }
    }
    
    private func loadUsers() async {
        isLoading = true
        errorMessage = ""
        do {
            users = try await profileController.getAllUsers()
        } catch {
            errorMessage = "Error al cargar usuarios: \(error.localizedDescription)"
        }
        isLoading = false
    }
}

struct UserRowView: View {
    let user: User
    let onTap: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Editar") {
                onEdit()
            }
            .buttonStyle(.bordered)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

struct UserDetailView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información del Usuario") {
                    HStack {
                        Text("ID:")
                        Spacer()
                        Text("\(user.id)")
                    }
                    
                    HStack {
                        Text("Nombre:")
                        Spacer()
                        Text(user.name)
                    }
                    
                    HStack {
                        Text("Email:")
                        Spacer()
                        Text(user.email)
                    }
                }
            }
            .navigationTitle("Detalle Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
struct EditUserForm {
    var name: String = ""
    var email: String = ""
    var password: String = ""
}

struct EditUserView: View {
    let user: User
    let onSave: (User) -> Void
    
    @Environment(\.profileController) var profileController
    @Environment(\.presentationMode) var presentationMode
    @State private var editForm = EditUserForm()
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Editar Usuario") {
                    TextField("Nombre", text: $editForm.name)
                    TextField("Email", text: $editForm.email)
                        .keyboardType(.emailAddress)
                    SecureField("Nueva Contraseña (opcional)", text: $editForm.password)
                }
                
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            await saveUser()
                        }
                    }) {
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Guardando...")
                            }
                        } else {
                            Text("Guardar Cambios")
                        }
                    }
                    .disabled(isLoading)
                }
            }
            .navigationTitle("Editar Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                editForm.name = user.name
                editForm.email = user.email
            }
        }
    }
    
    private func saveUser() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let name = editForm.name.isEmpty ? nil : editForm.name
            let email = editForm.email.isEmpty ? nil : editForm.email
            let password = editForm.password.isEmpty ? nil : editForm.password
            
            let updatedUser = try await profileController.updateUser(
                id: user.id,
                name: name,
                email: email,
                password: password
            )
            
            onSave(updatedUser)
        } catch {
            errorMessage = "Error al actualizar usuario: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}


#Preview {
    ProfileScreen()
}
