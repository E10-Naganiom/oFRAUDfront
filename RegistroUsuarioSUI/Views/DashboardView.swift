//
//  DashboardView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI
import Charts // para las gráficas


struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Todas"
    
    let filtros = ["Todas", "Phishing", "Malware", "Ransomware", "Fraude"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("👋 Bienvenid@ a oFraud")
                        .font(.title.bold())
                        .padding(.top)
                    
                    Text("Mantente protegido con las ultimas actualizaciones de seguridad")
                        .font(.headline)
                        
                    
                    VStack {
                        TextField("Buscar incidentes por ID, tipo de incidente", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 4)
                        HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Filtrar por categoria")
                            
                            Picker("Filtrar por tipo", selection: $selectedFilter){
                                ForEach(filtros, id: \.self){
                                    tipo in Text(tipo)
                                }
                            }.pickerStyle(MenuPickerStyle()).padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    
                    // Estadísticas
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "cellularbars")
                            Text("Estadísticas")
                                .font(.title2.bold())
                        }
                        
                        // Casos activos (line chart)
//                        Chart {
//                            ForEach(1..<7) { mes in
//                                LineMark(
//                                    x: .value("Mes", mes),
//                                    y: .value("Casos", Int.random(in: 20...100))
//                                )
//                            }
//                        }
//                        .frame(height: 200)
//                        .padding()
//                        .background(.gray.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Casos resueltos (bar chart)
//                        Chart {
//                            ForEach(1..<5) { categoria in
//                                BarMark(
//                                    x: .value("Categoría", "Cat\(categoria)"),
//                                    y: .value("Resueltos", Int.random(in: 10...50))
//                                )
//                            }
//                        }
//                        .frame(height: 200)
//                        .padding()
//                        .background(.gray.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Usuarios protegidos (pie chart simulado)
                        HStack {
                            VStack {
                                HStack {
                                    Image(systemName: "person.2.circle.fill")
                                    Text("Usuarios protegidos")
                                        .font(.headline)
                                }
                                ProgressView(value: 0.75)
                                    .progressViewStyle(.linear)
                                Text("75%")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Estado de seguridad (progress circular)
                        VStack {
                            HStack {
                                Image(systemName: "light.beacon.max.fill")
                                Text("Estado general de seguridad")
                                    .font(.headline)
                            }
                            ProgressView(value: 0.6)
                                .progressViewStyle(.linear)
                                .scaleEffect(1.5)
                            Text("60%")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.min.fill")
                            Text("Consejo de seguridad")
                                .font(.title3.bold())
                        }
                        Text("Nunca hagas clic en enlaces sospechosos recibidos por correo electrónico.")
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(.green.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: ReportView()) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 6)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Dashboard")
    }
}


#Preview {
    NavigationStack {
        DashboardView()
    }
}




