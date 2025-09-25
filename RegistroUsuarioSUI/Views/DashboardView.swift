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
    
    // Datos hardcodeados para fuentes de tráfico
    let trafficSources = [
        ("Phishing", 1250, 42.5, Color.yellow),
        ("Malware", 850, 28.9, Color.blue),
        ("Ransomware", 520, 17.7, Color.red),
        ("Llamadas", 320, 10.9, Color.green)
    ]
    
    // Datos hardcodeados para visitas
    let visitData = [
        ("Mes anterior", 3250),
        ("Mes Actual", 4180)
    ]
    
    var totalSessions: Int {
        trafficSources.reduce(0) { $0 + $1.1 }
    }
    
    var currentVisits: Int { 4180 }
    var previousVisits: Int { 3250 }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Bienvenid@ a oFraud")
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
                        
                        // GRÁFICO PIE CHART - Fuentes de Tráfico
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "network")
                                    .foregroundColor(.orange)
                                Text("Incidentes más comunes")
                                    .font(.title2.bold())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(totalSessions.formatted())")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                                
                                Text("Total de sesiones • Por fuente")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 20) {
                                // Pie Chart
                                Chart(trafficSources, id: \.0) { source in
                                    SectorMark(
                                        angle: .value("Count", source.1),
                                        innerRadius: .ratio(0.5),
                                        angularInset: 2
                                    )
                                    .foregroundStyle(source.3)
                                }
                                .frame(width: 120, height: 120)
                                
                                // Legend
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Array(trafficSources.enumerated()), id: \.offset) { index, source in
                                        HStack {
                                            Circle()
                                                .fill(source.3)
                                                .frame(width: 8, height: 8)
                                            
                                            Text(source.0)
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .trailing, spacing: 0) {
                                                Text("\(source.1.formatted())")
                                                    .font(.caption.bold())
                                                    .foregroundColor(.primary)
                                                
                                                Text("\(source.2, specifier: "%.1f")%")
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                                    .padding(.horizontal, 4)
                                                    .padding(.vertical, 1)
                                                    .background(.gray.opacity(0.1))
                                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .background(.gray.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // GRÁFICO DE BARRAS - Visitas del Sitio
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "eye")
                                    .foregroundColor(.orange)
                                Text("Número de Reportes")
                                    .font(.title2.bold())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(currentVisits.formatted())")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                                
                                Text("Visitas totales • Tendencia")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Bar Chart
                            Chart(visitData, id: \.0) { data in
                                BarMark(
                                    x: .value("Period", data.0),
                                    y: .value("Visits", data.1)
                                )
                                .foregroundStyle(data.0 == "Actual" ? Color.green : Color.blue)
                                .cornerRadius(4)
                            }
                            .frame(height: 150)
                            .chartXAxis {
                                AxisMarks { _ in
                                    // Hide X axis labels
                                }
                            }
                            .chartYAxis(.hidden)
                            
                            // Stats Grid
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Período Anterior")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(previousVisits.formatted())")
                                        .font(.headline.bold())
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Rectangle()
                                    .fill(.gray.opacity(0.3))
                                    .frame(width: 1, height: 30)
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Período Actual")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(currentVisits.formatted())")
                                        .font(.headline.bold())
                                        .foregroundColor(.primary)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(.gray.opacity(0.05))
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
                    
                    // Organization section
                    NavigationLink(destination: OrganizationView()) {
                        HStack(spacing: 15) {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Conocer Nuestra Organización")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Información sobre Red por la Ciberseguridad")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                    .buttonStyle(PlainButtonStyle())
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
