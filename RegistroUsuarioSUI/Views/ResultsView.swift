//
//  ResultsView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 25/09/25.
//

import SwiftUI


struct ResultsView: View {
    @State private var incidents: [Incident] = []
    @State private var isLoading = true
    @State private var searchText: String = ""
    @State private var selectedStatus: String = "Todos los estatus"
    
    let statusOptions = ["Todos los estatus", "Aprobados", "Pendientes", "Rechazados"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                
                HStack {
                    Image(systemName:"magnifyingglass")
                    Text("Resultados de reportes").font(.title2) .bold()
                    Spacer()
                }.padding()
                Text("Consulta diversos reportes de incidentes").font(.subheadline).foregroundColor(.gray).padding(.horizontal)
                TextField("Buscar reportes por ID, categoria o titulo", text: $searchText)
                    .padding(10).background(Color(.systemGray6)).cornerRadius(8).padding(.top, 5).padding(.horizontal)
                HStack {
                    Picker("Filtrar por estatus", selection: $selectedStatus){
                        ForEach(statusOptions, id: \.self){
                            status in Text(status)
                        }
                    }.pickerStyle(MenuPickerStyle()).padding(.horizontal)
                    NavigationLink(destination: ResultsView()){
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
                    Text("Incidentes encontrados:")
                        .font(.headline).padding(.horizontal).padding(.top).bold(true)
                    if isLoading {
                        ProgressView("Cargando reportes...")
                            .padding()
//                        IncidentCardView().padding(.horizontal)
//                        IncidentCardView().padding(.horizontal)
//                        IncidentCardView().padding(.horizontal)
                    } else if incidents.isEmpty {
                        Text("No tienes reportes aún")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(incidents) { incident in
                            //IncidentCardView()
                               // .padding(.horizontal)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 5){
                    Text("Resumen").font(.headline)
                    Text("Reportes que coinciden con tu busqueda: 3").font(.subheadline)
                }
                .padding().frame(maxWidth: .infinity, alignment: .leading).background(Color(.green)).cornerRadius(10).padding()
            }
            .navigationTitle("Busqueda de Reportes")
            .task {
                //await fetchIncidents()
            }
        }
    }

}




#Preview {
    ResultsView()
}
