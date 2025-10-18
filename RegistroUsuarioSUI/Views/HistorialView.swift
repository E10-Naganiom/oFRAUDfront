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
    @State private var datosResumen: SummaryResponse = SummaryResponse(total_incidentes: 0, total_aprobados: 0, total_pendientes: 0, total_rechazados: 0)
    
    let statusOptions = ["Todos los estatus", "Aprobados", "Pendientes", "Rechazados"]
    
    init(){
        self.categoriesController = CategoriesController(categoriesClient: CategoriesClient())
    }
    
    // ✨ NUEVA: Función auxiliar para filtrar por estatus
    private func filtrarPorEstatus(_ incidents: [IncidentFormResponse]) -> [IncidentFormResponse] {
        switch selectedStatus {
        case "Aprobados":
            return incidents.filter { $0.id_estatus == 2 }
        case "Pendientes":
            return incidents.filter { $0.id_estatus == 1 }
        case "Rechazados":
            return incidents.filter { $0.id_estatus == 3 }
        default: // "Todos los estatus"
            return incidents
        }
    }
    
    // ✨ NUEVA: Propiedad computada para filtrar incidentes en tiempo real
    var filteredIncidents: [IncidentFormResponse] {
        var result = incidents
        
        // Filtro por estatus
        result = filtrarPorEstatus(result)
        
        // Filtro por texto de búsqueda
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)
        if !trimmedSearch.isEmpty {
            result = result.filter { incident in
                let searchLower = trimmedSearch.lowercased()
                let categoriaNombre = obtenerNombreCategoria(id: incident.id_categoria).lowercased()
                
                return String(incident.id).contains(searchLower) ||
                       incident.titulo.lowercased().contains(searchLower) ||
                       categoriaNombre.contains(searchLower) ||
                       incident.descripcion.lowercased().contains(searchLower)
            }
        }
        
        return result
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Header - Fixed alignment
                VStack(alignment: .leading, spacing: 8) {
                    Text("Historial de reportes")
                        .font(.title.bold())
                    Text("Consulta el estado de tus reportes de incidentes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // ✨ MODIFICADO: TextField con botón para limpiar
                HStack {
                    TextField("Buscar reportes por ID, categoria o titulo", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .autocorrectionDisabled() // ✨ Desactivar autocorrección
                    
                    // ✨ NUEVO: Botón para limpiar búsqueda
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal)
                
                // ✨ MODIFICADO: Solo Picker, sin botón "Buscar"
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .padding(.leading)
                    
                    Picker("Filtrar por estatus", selection: $selectedStatus){
                        ForEach(statusOptions, id: \.self){ status in
                            Text(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // ✨ ELIMINADO: NavigationLink con botón "Buscar"
                    // El filtrado ahora es automático
                }
                
                // ✨ NUEVO: Contador de resultados
                if !searchText.isEmpty || selectedStatus != "Todos los estatus" {
                    Text("\(filteredIncidents.count) resultado(s) encontrado(s)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                // ✨ MODIFICADO: Usa filteredIncidents en lugar de incidents
                LazyVStack(spacing: 12) {
                    if isLoading {
                        VStack {
                            ProgressView("Cargando reportes...")
                                .padding()
                        }
                    } else if incidents.isEmpty {
                        // ✨ MODIFICADO: Mensaje cuando no hay datos del backend
                        VStack(spacing: 8) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No tienes reportes aún")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Tus reportes aparecerán aquí")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else if filteredIncidents.isEmpty {
                        // ✨ NUEVO: Mensaje cuando hay datos pero no coinciden con la búsqueda
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No se encontraron coincidencias")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Intenta con otros términos de búsqueda o filtros")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        // ✨ MODIFICADO: Usa filteredIncidents en lugar de incidents
                        ForEach(filteredIncidents) { incident in
                            IncidentCardView(incident: incident, categories: categories)
                                .padding(.horizontal)
                        }
                    }
                }
                
                // Sección de resumen (sin cambios)
                VStack(alignment: .leading, spacing: 5){
                    Text("Resumen").font(.headline)
                    Text("Total de reportes: \(datosResumen.total_incidentes)")
                    Text("Aprobados: \(datosResumen.total_aprobados)")
                    Text("Pendientes: \(datosResumen.total_pendientes)")
                    Text("Rechazados: \(datosResumen.total_rechazados)")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .background(Color(.green))
                .cornerRadius(10)
                .padding()
            }
        }
        .task {
            await cargarMiHistorial()
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
            print("categorias cargadas")
            
            datosResumen = try await incidentesController.getSummaryUser(id: profile.id)
            print("datos resumen cargados")

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
