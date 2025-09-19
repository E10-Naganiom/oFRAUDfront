//
//  HistorialView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import SwiftUI


struct HistorialView: View {
    @State private var incidents: [Incident] = []
    @State private var isLoading = true
    @State private var searchText: String = ""
    @State private var selectedStatus: String = "Todos los estatus"
    
    let statusOptions = ["Todos los estatus", "Aprobados", "Pendientes"]
    
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
                Picker("Filtrar por estatus", selection: $selectedStatus){
                    ForEach(statusOptions, id: \.self){
                        status in Text(status)
                    }
                }.pickerStyle(MenuPickerStyle()).padding(.horizontal)
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    if isLoading {
                        ProgressView("Cargando reportes...")
                            .padding()
                        IncidentCardView().padding(.horizontal)
                        IncidentCardView().padding(.horizontal)
                        IncidentCardView().padding(.horizontal)
                    } else if incidents.isEmpty {
                        Text("No tienes reportes aún")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(incidents) { incident in
                            IncidentCardView()
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
                //await fetchIncidents()
            }
        }
    }


//    private func fetchIncidents() async {
//        do {
//            let token = TokenStorage.get(identifier: "accessToken")
//            let fetched = try await IncidentClient().getUserIncidents(token: token!)
//            await MainActor.run {
//                incidents = fetched
//                isLoading = false
//            }
//        } catch {
//            print("Error al obtener incidentes:", error)
//            await MainActor.run {
//                isLoading = false
//            }
//        }
//    }
}




#Preview {
    HistorialView()
}
