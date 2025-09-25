//
//  GuidesView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI

struct GuidesView: View {
    @State private var selectedCategory: IncidentCategory?
    @State private var showCategoryDetail = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.green)
                        Text("Categorías de Incidentes")
                            .font(.headline)
                    }
                    
                    Text("Aprende sobre diferentes tipos de amenazas cibernéticas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Incident Categories
                VStack(spacing: 12) {
                    
                    // Phishing por Email
                    CategoryCardView(
                        icon: "envelope.fill",
                        title: "Phishing por Email",
                        description: "Emails fraudulentos que intentan robar información personal o financiera",
                        severity: "Alto",
                        severityColor: .orange,
                        reports: "1245",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .phishing
                            showCategoryDetail = true
                        }
                    )
                    
                    // Fraude Financiero
                    CategoryCardView(
                        icon: "creditcard.fill",
                        title: "Fraude Financiero",
                        description: "Estafas relacionadas con transacciones bancarias y tarjetas de crédito",
                        severity: "Crítico",
                        severityColor: .red,
                        reports: "856",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .fraudeFinanciero
                            showCategoryDetail = true
                        }
                    )
                    
                    // Estafas Telefónicas
                    CategoryCardView(
                        icon: "phone.fill",
                        title: "Estafas Telefónicas",
                        description: "Llamadas fraudulentas que buscan obtener información o dinero",
                        severity: "Alto",
                        severityColor: .orange,
                        reports: "692",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .estafasTelefonicas
                            showCategoryDetail = true
                        }
                    )
                    
                    // Malware/Virus
                    CategoryCardView(
                        icon: "exclamationmark.triangle.fill",
                        title: "Malware/Virus",
                        description: "Software malicioso que puede dañar tu dispositivo o robar información",
                        severity: "Alto",
                        severityColor: .orange,
                        reports: "423",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .malware
                            showCategoryDetail = true
                        }
                    )
                    
                    // Redes WiFi Falsas
                    CategoryCardView(
                        icon: "wifi",
                        title: "Redes WiFi Falsas",
                        description: "Puntos de acceso WiFi creados para interceptar datos",
                        severity: "Medio",
                        severityColor: .yellow,
                        reports: "234",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .redesWiFiFalsas
                            showCategoryDetail = true
                        }
                    )
                    
                    // Estafas en Redes Sociales
                    CategoryCardView(
                        icon: "message.fill",
                        title: "Estafas en Redes Sociales",
                        description: "Fraudes que ocurren a través de plataformas de redes sociales",
                        severity: "Medio",
                        severityColor: .yellow,
                        reports: "367",
                        trending: true,
                        onTapMore: {
                            selectedCategory = .estafasRedesSociales
                            showCategoryDetail = true
                        }
                    )
                }
                
                // Security Tips Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                            .foregroundColor(.green)
                        Text("Consejos Generales de Seguridad")
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        SecurityTipRow(tip: "Mantén siempre tus dispositivos y software actualizados")
                        SecurityTipRow(tip: "Usa contraseñas fuertes y únicas para cada cuenta")
                        SecurityTipRow(tip: "Sé escéptico con ofertas demasiado buenas para ser verdad")
                        SecurityTipRow(tip: "Cuando tengas dudas, consulta con expertos o reporta el incidente")
                    }
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(16)
            }
            .padding()
        }
        .navigationTitle("Guías")
        .sheet(item: $selectedCategory) { category in
            CategoryDetailView(category: category)
        }
    }
}

// MARK: - Supporting Views

struct SecurityTipRow: View {
    let tip: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.headline)
                .foregroundColor(.green)
            Text(tip)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        GuidesView()
    }
}
