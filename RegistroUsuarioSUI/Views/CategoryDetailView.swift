//
//  CategoryDetailView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI

struct CategoryDetailView: View {
    let category: CategoryFormResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "shield.lefthalf.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 36))
                    Text(category.titulo)
                        .font(.title2)
                        .bold()
                }
                
                Text(category.descripcion)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nivel de riesgo:")
                        .font(.headline)
                    Text(riskLabel(for: category.id_riesgo))
                        .foregroundColor(riskColor(for: category.id_riesgo))
                        .bold()
                }
            }
            .padding()
        }
        .navigationTitle("Detalles")
    }
    
    private func riskLabel(for id_riesgo: Int) -> String {
        switch id_riesgo {
        case 1: return "Bajo"
        case 2: return "Medio"
        case 3: return "Alto"
        case 4: return "Crítico"
        default: return "Desconocido"
        }
    }
    
    private func riskColor(for id_riesgo: Int) -> Color {
        switch id_riesgo {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        default: return .gray
        }
    }
}
