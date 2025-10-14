//
//  ReportView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//


import SwiftUI
import PhotosUI
import UIKit




struct ReportView: View {
    
    var categoriesController : CategoriesController
    
    @State private var titulo = ""
    @State private var idCategoria = 0
    @State private var tipoIncidente = "Phishing"
    @State private var atacante = ""
//    @State private var fechaIncidente = Date()
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
//                TextField("Id categoria", value: $idCategoria, format: .number)
                
//                Picker("Tipo de incidente", selection: $tipoIncidente) {
//                    ForEach(categorias, id: \.self) { cat in
//                        Text(cat)
//                    }
//                }
                
                TextField("Empresa o individuo atacante", text: $atacante)
                
//                DatePicker(
//                    "Fecha del incidente",
//                    selection: $fechaIncidente,
//                    in: ...Date(),
//                    displayedComponents: [.date]
//                )
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
            
            Section {
                HStack(spacing:12){
                    Button {
                        showCamera = true
                    } label: {
                        Label("Usar Camara", systemImage: "camera.fill").frame(maxWidth: .infinity)
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
            
            Section{
                HStack{
                    Text("Desea que su reporte sea anonimo?")
                    Spacer()
                    Toggle("", isOn: $es_anonimo)
                }
            }
            // Nota importante
            Section {
                Text("⚠️ Importante: No compartas información personal o sensible en este formulario. Solo incluye detalles relevantes del incidente.")
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
                print("❌ No hay usuario autenticado")
                return
            }
            
            let incidentsController = IncidentsController(incidensClient: IncidentsClient())

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

            print("✅ Respuesta completa:", response)
            await MainActor.run {
                showSuccessAlert = true
            }

        } catch {
            print("⚠️ Error completo:", error)
            print("⚠️ Descripción:", error.localizedDescription)
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




#Preview {
    NavigationStack {
        ReportView()
    }
}



