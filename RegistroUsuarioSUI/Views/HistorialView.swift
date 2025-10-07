//
//  HistorialView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import SwiftUI


struct HistorialView: View {
    var categoriesController: CategoriesController
    
    @State private var currentUserId: Int? = nil
    @State private var incidents: [IncidentFormResponse] = []
    @State private var selectedIncident: IncidentFormResponse? = nil
    @State private var isLoading = true
    @State private var searchText: String = ""
    @State private var selectedStatus: String = "Todos los estatus"
    @State private var categories: [CategoryFormResponse] = []
    
    let statusOptions = ["Todos los estatus", "Aprobados", "Pendientes"]
    
    init(){
        self.categoriesController = CategoriesController(categoriesClient: CategoriesClient())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    Image(systemName:"document.fill")
                    Text("Historial de reportes").font(.title2) .bold()
                    Spacer()
                }.padding()
                Text("Consulta el estado de tus reportes de incidentes").font(.subheadline).foregroundColor(.gray).padding(.horizontal)
                TextField("Buscar reportes por ID, categoria o titulo", text: $searchText)
                    .padding(10).background(Color(.systemGray6)).cornerRadius(8).padding(.top, 5).padding(.horizontal)
                HStack {
                    Picker("Filtrar por estatus", selection: $selectedStatus){
                        ForEach(statusOptions, id: \.self){
                            status in Text(status)
                        }
                    }.pickerStyle(MenuPickerStyle()).padding(.horizontal)
                    NavigationLink(destination: HistorialView()){
                        Text("Buscar")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                    }
                }
                
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    if isLoading {
                        VStack {
                            ProgressView("Cargando reportes...")
                                .padding()
                        }
                    } else if incidents.isEmpty {
                        Text("No tienes reportes aún")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(incidents) { incident in
                            IncidentCardView(titulo:incident.titulo, estatus:"incident.id_estatus.", categoria:obtenerNombreCategoria(id:incident.id_categoria), fecha_creacion: incident.fecha_creacion,fecha_update: incident.fecha_actualizacion,usuario_alta: "incident.id_usuario")
                                .padding(.horizontal)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 5){
                    Text("Resumen").font(.headline)
                    Text("Total de reportes: 123")
                    Text("Aprobados: 2")
                }
                .padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.green)).cornerRadius(10).padding()
            }
            .navigationTitle("Mi Historial")
            .task {
                await cargarMiHistorial()
            }
        }
    }
    
    private func cargarMiHistorial() async {
        isLoading = true
        defer { isLoading = false }
        
        let profileController = ProfileController(profileClient: ProfileClient())
        let incidentesController = IncidentsController(incidensClient: IncidentsClient())
        
        do {
            let profile = try await profileController.getProfile()
            currentUserId = profile.id
            print("Accediendo al historial del usuario ", profile.id)
            
            incidents = try await incidentesController.loadHistorial(id: profile.id)
            print("Cargado el historial del usuario")
            
            categories = try await categoriesController.getAllCategories()
        }
        catch {
            print("No se pudo acceder al historial del usuario: ", error)
            incidents = []
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

}




#Preview {
    HistorialView()
}
