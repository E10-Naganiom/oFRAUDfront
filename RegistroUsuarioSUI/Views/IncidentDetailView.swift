//
//  IncidentDetailView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 18/09/25.
//

import SwiftUI

struct IncidentDetailView: View {
    
    let incidente: IncidentFormResponse
    let categories: [CategoryFormResponse]
    
    let estatus: String
    let nombreCompleto: String
    
    @State private var isEditing = false
    @State private var editedIncident: EditableIncident
    @State private var showUpdateSuccess = false
    
    // Estados para manejo de actualización
    @State private var showUpdateError = false
    @State private var errorMessage = ""
    @State private var isUpdating = false
    @State private var updatedIncidentData: IncidentFormResponse?
    
    // ✨ NUEVO: Estados para vista de imagen en pantalla completa
    @State private var selectedImageURL: URL?
    @State private var showFullScreenImage = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(incidente: IncidentFormResponse, categories: [CategoryFormResponse], estatus: String, nombreCompleto: String) {
        self.incidente = incidente
        self.categories = categories
        self.estatus = estatus
        self.nombreCompleto = nombreCompleto
        _editedIncident = State(initialValue: EditableIncident(from: incidente))
    }
    
    private var currentIncident: IncidentFormResponse {
        updatedIncidentData ?? incidente
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Header con botón de editar
                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                    Text("Detalle del Incidente")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Solo mostrar botón de editar si NO está aprobado (id_estatus != 2)
                    if currentIncident.id_estatus == 1 {
                        Button(action: { isEditing.toggle() }) {
                            Image(systemName: isEditing ? "xmark.circle.fill" : "pencil.circle.fill")
                                .foregroundColor(isEditing ? .red : .green)
                                .font(.system(size: 32))
                        }
                    }
                }
                .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Título (editable)
                    HStack {
                        Text("Titulo:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        if isEditing {
                            TextField("Título", text: $editedIncident.titulo)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)
                        } else {
                            Text(editedIncident.titulo)
                                .font(.subheadline.bold())
                        }
                    }
                    
                    // Categoría (editable)
                    HStack {
                        Text("Categoria:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        if isEditing {
                            Picker("Categoría", selection: $editedIncident.id_categoria) {
                                ForEach(categories, id: \.id) { category in
                                    Text(category.titulo).tag(category.id)
                                }
                            }
                            .pickerStyle(.menu)
                        } else {
                            Text(obtenerNombreCategoria(id: editedIncident.id_categoria))
                                .font(.subheadline.bold())
                        }
                    }
                    
                    // Usuario (NO editable)
                    HStack {
                        Text("Usuario:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        if(!currentIncident.es_anonimo){
                            Text(nombreCompleto)
                                .font(.subheadline.bold())
                        }
                        else {
                            Text("Anonimo")
                                .font(.subheadline.bold())
                        }
                    }
                    
                    // Estado (NO editable)
                    HStack {
                        Text("Estado:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(estatus)
                            .font(.subheadline.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(getColorStatus(currentIncident.id_estatus).opacity(0.15))
                            .foregroundColor(getColorStatus(currentIncident.id_estatus))
                            .cornerRadius(12)
                    }
                    
                    // Creación (NO editable)
                    HStack {
                        Text("Creacion:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatISODate(currentIncident.fecha_creacion))
                            .font(.subheadline)
                    }
                    
                    // Última actualización
                    HStack {
                        Text("Última actualización:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatISODate(currentIncident.fecha_actualizacion))
                            .font(.subheadline)
                    }
                    
                }
                .padding().frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Descripción (editable)
                VStack(alignment: .leading, spacing: 12){
                    Text("Descripcion del incidente").font(.headline)
                    if isEditing {
                        TextEditor(text: $editedIncident.descripcion)
                            .frame(minHeight: 100)
                            .padding(8).frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                    } else {
                        Text(editedIncident.descripcion).frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding().frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Medios de contacto (editables)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Medios de contacto")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    // Atacante
                    HStack(spacing: 12) {
                        Image(systemName: "person.badge.shield.exclamationmark.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Atacante")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if isEditing {
                                TextField("Nombre del atacante", text: Binding(
                                    get: { editedIncident.nombre_atacante ?? "" },
                                    set: { editedIncident.nombre_atacante = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                            } else {
                                Text((editedIncident.nombre_atacante ?? "").isEmpty ? "No proporcionado" : editedIncident.nombre_atacante!)
                                    .font(.subheadline.bold())
                            }
                        }
                        Spacer()
                    }
                    
                    // Teléfono
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Teléfono")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if isEditing {
                                TextField("Teléfono", text: Binding(
                                    get: { editedIncident.telefono ?? "" },
                                    set: { editedIncident.telefono = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                            } else {
                                Text((editedIncident.telefono ?? "").isEmpty ? "No proporcionado" : editedIncident.telefono!)
                                    .font(.subheadline.bold())
                            }
                        }
                        Spacer()
                    }
                    
                    // Correo
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Correo electrónico")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if isEditing {
                                TextField("Correo", text: Binding(
                                    get: { editedIncident.correo ?? "" },
                                    set: { editedIncident.correo = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            } else {
                                Text((editedIncident.correo ?? "").isEmpty ? "No proporcionado" : editedIncident.correo!)
                                    .font(.subheadline.bold())
                            }
                        }
                        Spacer()
                    }
                    
                    // Red social
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .foregroundColor(.blue)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Usuario en red social")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if isEditing {
                                TextField("Usuario", text: Binding(
                                    get: { editedIncident.user_red ?? "" },
                                    set: { editedIncident.user_red = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                                TextField("Red social", text: Binding(
                                    get: { editedIncident.red_social ?? "" },
                                    set: { editedIncident.red_social = $0.isEmpty ? nil : $0 }
                                ))
                                .textFieldStyle(.roundedBorder)
                            } else {
                                Text((editedIncident.user_red ?? "").isEmpty ? "No proporcionado" : editedIncident.user_red!)
                                    .font(.subheadline.bold())
                                Text((editedIncident.red_social ?? "").isEmpty ? "No proporcionado" : editedIncident.red_social!)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Botón guardar con loading state
                if isEditing && currentIncident.id_estatus == 1 {
                    Button(action: {
                        Task {
                            await updateIncident()
                        }
                    }) {
                        HStack {
                            if isUpdating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Text("Guardando...")
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Guardar cambios")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isUpdating ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(isUpdating)
                }
                
                // ✨ MODIFICADO: Evidencias con click para ver en pantalla completa
                if let evidencias = currentIncident.evidencias, !evidencias.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Evidencias")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                            ForEach(evidencias) { evidencia in
                                let fullURL = URL(string: "\(APIConfig.baseURL)/\(evidencia.url)")
                                
                                if let url = fullURL,
                                   evidencia.url.lowercased().hasSuffix(".jpg") ||
                                   evidencia.url.lowercased().hasSuffix(".jpeg") ||
                                   evidencia.url.lowercased().hasSuffix(".png") {
                                    
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipped()
                                                .cornerRadius(12)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    selectedImageURL = url
                                                    showFullScreenImage = true
                                                }
                                        case .failure:
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "doc.text.fill")
                                            .resizable()
                                            .frame(width: 40, height: 50)
                                            .foregroundColor(.gray)
                                        Text("Documento")
                                            .font(.caption2)
                                    }
                                    .frame(width: 120, height: 120)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                } else {
                    Text("No hay evidencias registradas.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle("Incidente")
        .navigationBarTitleDisplayMode(.inline)
        .alert("✅ Incidente actualizado", isPresented: $showUpdateSuccess) {
            Button("OK", role: .cancel) {
                isEditing = false
            }
        } message: {
            Text("Los cambios se guardaron correctamente")
        }
        .alert("❌ Error al actualizar", isPresented: $showUpdateError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        // ✨ NUEVO: Vista de imagen en pantalla completa
        .fullScreenCover(isPresented: $showFullScreenImage) {
            if let imageURL = selectedImageURL {
                FullScreenImageFromURLView(imageURL: imageURL, isPresented: $showFullScreenImage)
            }
        }
    }
    
    private func obtenerNombreCategoria(id: Int) -> String {
        for categoria in categories {
            if categoria.id == id {
                return categoria.titulo
            }
        }
        return "No especificada"
    }
    
    private func updateIncident() async {
        isUpdating = true
        defer { isUpdating = false }
        
        let incidentsController = IncidentsController(incidentsClient: IncidentsClient())
        
        do {
            let updatedIncident = try await incidentsController.updateIncident(
                id: incidente.id,
                titulo: editedIncident.titulo,
                id_categoria: editedIncident.id_categoria,
                nombre_atacante: editedIncident.nombre_atacante,
                telefono: editedIncident.telefono,
                correo: editedIncident.correo,
                user_red: editedIncident.user_red,
                red_social: editedIncident.red_social,
                descripcion: editedIncident.descripcion
            )
            
            updatedIncidentData = updatedIncident
            editedIncident = EditableIncident(from: updatedIncident)
            
            print("Incidente actualizado exitosamente: \(updatedIncident)")
            showUpdateSuccess = true
            
        } catch {
            print("Error al actualizar incidente: \(error)")
            errorMessage = "No se pudo actualizar el incidente. Por favor intenta de nuevo."
            showUpdateError = true
        }
    }
}

// Struct auxiliar para manejar la edición
struct EditableIncident {
    var titulo: String
    var id_categoria: Int
    var nombre_atacante: String?
    var telefono: String?
    var correo: String?
    var user_red: String?
    var red_social: String?
    var descripcion: String
    
    init(from incident: IncidentFormResponse) {
        self.titulo = incident.titulo
        self.id_categoria = incident.id_categoria
        self.nombre_atacante = incident.nombre_atacante
        self.telefono = incident.telefono
        self.correo = incident.correo
        self.user_red = incident.user_red
        self.red_social = incident.red_social
        self.descripcion = incident.descripcion
    }
}

struct FullScreenImageFromURLView: View {
    let imageURL: URL
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Botón de cerrar
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                .zIndex(1)
                
                // Imagen
                ZStack {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(2)
                                Text("Cargando imagen...")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .scaleEffect(scale)
                                .offset(offset)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let delta = value / lastScale
                                            lastScale = value
                                            scale = min(max(scale * delta, 1.0), 5.0)
                                        }
                                        .onEnded { _ in
                                            lastScale = 1.0
                                            if scale < 1.0 {
                                                withAnimation(.spring()) {
                                                    scale = 1.0
                                                    offset = .zero
                                                }
                                            }
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if scale > 1.0 {
                                                offset = CGSize(
                                                    width: lastOffset.width + value.translation.width,
                                                    height: lastOffset.height + value.translation.height
                                                )
                                            }
                                        }
                                        .onEnded { _ in
                                            lastOffset = offset
                                        }
                                )
                                .gesture(
                                    TapGesture(count: 2)
                                        .onEnded {
                                            withAnimation(.spring()) {
                                                if scale > 1.0 {
                                                    scale = 1.0
                                                    offset = .zero
                                                    lastOffset = .zero
                                                } else {
                                                    scale = 2.5
                                                }
                                            }
                                        }
                                )
                        case .failure(let error):
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                                Text("Error al cargar la imagen")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(error.localizedDescription)
                                    .foregroundColor(.white.opacity(0.7))
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Text("URL: \(imageURL.absoluteString)")
                                    .foregroundColor(.white.opacity(0.5))
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Indicador de zoom
                if scale > 1.0 {
                    Text(String(format: "%.1fx", scale))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                }
            }
        }
        .statusBar(hidden: true)
    }
}
