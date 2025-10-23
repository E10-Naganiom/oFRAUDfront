//
//  ReportView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI
import PhotosUI
import UIKit
import AVFoundation

struct ReportView: View {
    
    var categoriesController : CategoriesController
    
    @State private var titulo = ""
    @State private var idCategoria = 0
    @State private var tipoIncidente = "Phishing"
    @State private var atacante = ""
    @State private var es_anonimo = false
    
    @State private var currentUserId: Int? = nil
    
    @State private var contactos: [MetodoContacto] = []
    @State private var descripcion = ""

    @State private var showSuccessAlert = false
    @State private var navigateToDashboard = false
    @State private var categories: [CategoryFormResponse] = []
    @State private var selectedCategoryId: Int? = nil
    @State private var isLoadingCategories = true
    
    @State private var selectedUIImage: UIImage?
    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var uploadStatus: String?
    @State private var archivosAdjuntos: [Data] = []
    
    init(){
        self.categoriesController = CategoriesController(categoriesClient: CategoriesClient())
    }
    
    let redesSociales = ["Twitter/X", "Facebook", "Instagram", "LinkedIn", "TikTok", "Otro"]
    
    var body: some View {
        Form {
            // Instrucciones
            Section {
                Text("Por favor completa la información del incidente de la forma más detallada posible. Esto nos ayudará a investigar y responder adecuadamente.")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            
            // Info básica
            Section(header: Text("Información Básica")) {
                TextField("Título del incidente", text: $titulo)
                if isLoadingCategories {
                    ProgressView("Cargando categorias ...")
                } else {
                    Picker("Categoria", selection: $selectedCategoryId){
                        ForEach(categories, id: \.id) { cat in
                            Text(cat.titulo).tag(Optional(cat.id))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                TextField("Empresa o individuo atacante", text: $atacante)
            }
            
            // Métodos de contacto
            Section(
                header: HStack {
                    Text("Métodos de contacto")
                    Spacer()
                    Button(action: {
                        if contactos.count < 5 {
                            contactos.append(MetodoContacto())
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            ) {
                if contactos.isEmpty {
                    Text("No se han agregado métodos de contacto.")
                        .foregroundColor(.gray)
                } else {
                    ForEach($contactos) { $contacto in
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Tipo", selection: $contacto.tipo) {
                                Text("Teléfono").tag("Teléfono")
                                Text("Correo").tag("Correo")
                                Text("Red Social").tag("Red Social")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if contacto.tipo == "Teléfono" {
                                TextField("Número de teléfono", text: $contacto.valor)
                                    .keyboardType(.phonePad)
                            } else if contacto.tipo == "Correo" {
                                TextField("Correo electrónico", text: $contacto.valor)
                                    .keyboardType(.emailAddress)
                            } else if contacto.tipo == "Red Social" {
                                Picker("Plataforma", selection: $contacto.redSocial) {
                                    ForEach(redesSociales, id: \.self) { red in
                                        Text(red)
                                    }
                                }
                                TextField("Usuario (@ejemplo)", text: $contacto.valor)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            // Descripción
            Section(header: Text("Descripción del incidente")) {
                TextEditor(text: $descripcion)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
            }
            
            // Archivos adjuntos
            Section(header: Text("Archivos adjuntos (máx. 5)")) {
                if archivosAdjuntos.isEmpty {
                    Text("No se han subido archivos.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(archivosAdjuntos.indices, id: \.self) { index in
                        if let uiImage = UIImage(data: archivosAdjuntos[index]) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Botones de cámara y carrete
            Section {
                HStack(spacing:12){
                    Button {
                        checkCameraPermission { granted in
                            if granted {
                                showCamera = true
                            } else {
                                // Alerta simple si el usuario deniega la cámara
                                print("Permiso de cámara denegado")
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Cámara")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                    
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        Label("Rollo", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: photoPickerItem) { newItem in
                        Task{
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if archivosAdjuntos.count < 5 {
                                    archivosAdjuntos.append(data)
                                }
                            }
                        }
                    }
                }
            }
            
            // Toggle de anonimato
            Section{
                HStack{
                    Text("Desea que su reporte sea anonimo?")
                    Spacer()
                    Toggle("", isOn: $es_anonimo)
                }
            }
            
            // Nota importante
            Section {
                Text("Importante: No compartas información personal o sensible en este formulario. Solo incluye detalles relevantes del incidente.")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            // Botón enviar
            Section {
                Button(action: {
                    Task{
                        await enviarReporte()
                    }
                }) {
                    Text("Enviar reporte")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .alert("Reporte enviado", isPresented: $showSuccessAlert){
                Button("OK") {
                    navigateToDashboard = true
                }
            } message: {
                Text("Tu reporte se envio exitosamente, Seras redirigido a la pantalla principal")
            }
            .navigationDestination(isPresented: $navigateToDashboard){
                DashboardView()
            }
        }
        .navigationTitle("Levantar Reporte")
        .fullScreenCover(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image in
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    if archivosAdjuntos.count < 5 {
                        archivosAdjuntos.append(imageData)
                    }
                }
            }
        }
        .task {
            do {
                categories = try await categoriesController.getAllCategories()
                isLoadingCategories = false
                
                let profileController = ProfileController(profileClient: ProfileClient())
                let profile = try await profileController.getProfile()
                currentUserId = profile.id
                print("Usuario autenticado con ID: ", profile.id)
                
            } catch {
                print("Error cargando datos iniciales: ", error)
                isLoadingCategories = false
            }
        }
    }
    
    // MARK: - Envío del reporte
    func enviarReporte() async {
        do {
            guard let currentUserId = currentUserId else {
                print("No hay usuario autenticado")
                return
            }
            
            let incidentsController = IncidentsController(incidentsClient: IncidentsClient())

            let response = try await incidentsController.createIncident(
                titulo: titulo,
                id_categoria: selectedCategoryId ?? 0,
                nombre_atacante: atacante.isEmpty ? nil : atacante,
                telefono: contactos.first(where: { $0.tipo == "Teléfono"})?.valor,
                correo: contactos.first(where: { $0.tipo == "Correo"})?.valor,
                user: contactos.first(where: { $0.tipo == "Red Social"})?.valor,
                red_social: contactos.first(where: { $0.tipo == "Red Social"})?.redSocial,
                descripcion: descripcion,
                id_usuario: currentUserId,
                supervisor: nil,
                es_anonimo: es_anonimo,
                evidences: archivosAdjuntos
            )

            print("Respuesta completa:", response)
            await MainActor.run {
                showSuccessAlert = true
            }

        } catch {
            print("Error completo:", error)
            print("Descripción:", error.localizedDescription)
        }
    }
    
    // MARK: - Función de permisos de cámara
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
}

// MARK: - Modelo de método de contacto
struct MetodoContacto: Identifiable {
    let id = UUID()
    var tipo: String = "Teléfono"
    var valor: String = ""
    var redSocial: String = "Twitter/X"
}

// MARK: - ImagePicker para UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        ReportView()
    }
}
