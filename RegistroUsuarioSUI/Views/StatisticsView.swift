//
//  StatisticsView.swift
//  RegistroUsuarioSUI
//
//  Created by Omar Llano on 17/10/25.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @State private var loadingStats = true
    @State private var datosGraficas: StatsResponse = StatsResponse(
        total_incidentes: 0,
        total_categorias: 0,
        por_estatus: [],
        por_categoria: [],
        metodos_contacto: [],
        redes_sociales: []
    )
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Estadísticas")
                        .font(.title.bold())
                    Text("Análisis de incidentes reportados")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                if loadingStats {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Cargando estadísticas...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 60)
                } else {
                    VStack(spacing: 20) {
                        incidentesPorEstatusSection
                        incidentesPorCategoriaSection
                        incidentesPorMetodoSection
                        incidentesPorRedesSection
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Estadísticas")
        .task {
            await getNumsGraficas()
        }
    }
    
    private func getNumsGraficas() async {
        loadingStats = true
        defer { loadingStats = false }
        let controller = IncidentsController(incidensClient: IncidentsClient())
        do {
            datosGraficas = try await controller.getEstadisticas()
            print("Datos para graficas cargados exitosamente")
        } catch {
            print("No se pudieron obtener las estadisticas: \(error)")
        }
    }
    
    // MARK: - Secciones de gráficas
    
    private var incidentesPorEstatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(.green)
                    .font(.title2)
                Text("Incidentes por estatus")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(datosGraficas.total_incidentes)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.green)
                
                Text("Incidentes reportados")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Chart(datosGraficas.por_estatus, id: \.estatus) { e in
                SectorMark(
                    angle: .value("Porcentaje", e.porcentaje),
                    innerRadius: .ratio(0.6)
                )
                .foregroundStyle(by: .value("Estatus", e.estatus))
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var incidentesPorCategoriaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Incidentes por categoría")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(datosGraficas.total_categorias)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("Categorías registradas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Chart(datosGraficas.por_categoria, id: \.titulo) { c in
                BarMark(
                    x: .value("Categoria", c.titulo),
                    y: .value("Porcentaje", Double(c.porcentaje) ?? 0)
                )
                .foregroundStyle(.blue.gradient)
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var incidentesPorMetodoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Métodos de contacto")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Distribución por método")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Chart(datosGraficas.metodos_contacto, id: \.metodo) { m in
                BarMark(
                    x: .value("Porcentaje", Double(m.porcentaje) ?? 0),
                    y: .value("Metodo", m.metodo)
                )
                .foregroundStyle(.orange.gradient)
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var incidentesPorRedesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "network")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Redes sociales involucradas")
                    .font(.title2.bold())
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Distribución por red social")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Chart(datosGraficas.redes_sociales, id: \.nombre) { red in
                SectorMark(
                    angle: .value("Porcentaje", Double(red.porcentaje) ?? 0),
                    innerRadius: .ratio(0.5),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Red Social", red.nombre))
            }
            .frame(height: 250)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        StatisticsView()
    }
}
