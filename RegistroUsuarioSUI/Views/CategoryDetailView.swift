//
//  CategoryDetailView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI

// MARK: - Models

enum IncidentCategory: CaseIterable, Identifiable {
    case phishing
    case fraudeFinanciero
    case estafasTelefonicas
    case malware
    case redesWiFiFalsas
    case estafasRedesSociales
    
    var id: Self{self}
}

enum DetailSection: CaseIterable {
    case senalesComunes
    case comoPrevenirlo
    case queHacerSiOcurre
    case ejemplosComunes
    
    var title: String {
        switch self {
        case .senalesComunes: return "Señales Comunes"
        case .comoPrevenirlo: return "Cómo Prevenirlo"
        case .queHacerSiOcurre: return "Qué Hacer Si Ocurre"
        case .ejemplosComunes: return "Ejemplos Comunes"
        }
    }
    
    var icon: String {
        switch self {
        case .senalesComunes: return "magnifyingglass"
        case .comoPrevenirlo: return "shield.fill"
        case .queHacerSiOcurre: return "exclamationmark.octagon.fill"
        case .ejemplosComunes: return "lightbulb.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .senalesComunes: return .blue
        case .comoPrevenirlo: return .green
        case .queHacerSiOcurre: return .red
        case .ejemplosComunes: return .yellow
        }
    }
}

// MARK: - Views

struct CategoryDetailView: View {
    let category: IncidentCategory
    @Environment(\.dismiss) private var dismiss
    @State private var expandedSections: Set<DetailSection> = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: category.icon)
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(category.title)
                                    .font(.title2.bold())
                                Text(category.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Text(category.severity)
                                .font(.caption.bold())
                                .foregroundColor(category.severityColor)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(category.severityColor.opacity(0.2))
                                .cornerRadius(8)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text("\(category.reports) reportes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Image(systemName: "arrow.up.right")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                    
                    // Expandable sections
                    VStack(spacing: 0) {
                        ForEach(DetailSection.allCases, id: \.self) { section in
                            ExpandableSection(
                                section: section,
                                category: category,
                                isExpanded: expandedSections.contains(section)
                            ) {
                                if expandedSections.contains(section) {
                                    expandedSections.remove(section)
                                } else {
                                    expandedSections.insert(section)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExpandableSection: View {
    let section: DetailSection
    let category: IncidentCategory
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Image(systemName: section.icon)
                        .foregroundColor(section.color)
                        .frame(width: 24)
                    Text(section.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(getContentForSection(), id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundColor(section.color)
                            Text(item)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray5))
            }
        }
        .cornerRadius(12)
        .padding(.bottom, 8)
    }
    
    private func getContentForSection() -> [String] {
        switch (category, section) {
        // Phishing
        case (.phishing, .senalesComunes):
            return [
                "Emails de remitentes desconocidos o sospechosos",
                "Enlaces que no coinciden con el sitio oficial",
                "Solicitudes urgentes de información personal",
                "Errores ortográficos y gramaticales",
                "Amenazas de cierre de cuenta"
            ]
        case (.phishing, .comoPrevenirlo):
            return [
                "Verifica siempre la dirección del remitente",
                "No hagas clic en enlaces sospechosos",
                "Accede directamente al sitio web oficial",
                "Usa autenticación de dos factores",
                "Mantén actualizado tu software de seguridad"
            ]
        case (.phishing, .queHacerSiOcurre):
            return [
                "No proporciones información personal",
                "Reporta el email como spam",
                "Cambia tus contraseñas inmediatamente",
                "Contacta a tu banco o institución",
                "Reporta el incidente a las autoridades"
            ]
        case (.phishing, .ejemplosComunes):
            return [
                "Falsos emails de bancos pidiendo verificación",
                "Notificaciones falsas de redes sociales",
                "Ofertas demasiado buenas para ser verdad",
                "Emails de soporte técnico falsos",
                "Notificaciones de premios no solicitados"
            ]
            
        // Fraude Financiero
        case (.fraudeFinanciero, .senalesComunes):
            return [
                "Transacciones no autorizadas en cuentas",
                "Solicitudes de información bancaria por teléfono",
                "Ofertas de inversión con rendimientos garantizados",
                "Presión para actuar inmediatamente",
                "Solicitudes de transferencias de dinero"
            ]
        case (.fraudeFinanciero, .comoPrevenirlo):
            return [
                "Revisa regularmente tus estados de cuenta",
                "Usa tarjetas con chip y contactless",
                "No compartas tu PIN con nadie",
                "Compra solo en sitios seguros (HTTPS)",
                "Configura alertas bancarias"
            ]
        case (.fraudeFinanciero, .queHacerSiOcurre):
            return [
                "Contacta inmediatamente a tu banco",
                "Bloquea tus tarjetas afectadas",
                "Presenta una denuncia formal",
                "Documenta todas las transacciones fraudulentas",
                "Cambia tus contraseñas bancarias"
            ]
        case (.fraudeFinanciero, .ejemplosComunes):
            return [
                "Clonación de tarjetas en cajeros automáticos",
                "Esquemas Ponzi y pirámides financieras",
                "Fraude con tarjetas de crédito en línea",
                "Falsos asesores de inversión",
                "Estafas de préstamos rápidos"
            ]
            
        default:
            return [
                "Contenido en desarrollo",
                "Más información próximamente"
            ]
        }
    }
}

// MARK: - Extensions

extension IncidentCategory {
    var title: String {
        switch self {
        case .phishing: return "Phishing por Email"
        case .fraudeFinanciero: return "Fraude Financiero"
        case .estafasTelefonicas: return "Estafas Telefónicas"
        case .malware: return "Malware/Virus"
        case .redesWiFiFalsas: return "Redes WiFi Falsas"
        case .estafasRedesSociales: return "Estafas en Redes Sociales"
        }
    }
    
    var description: String {
        switch self {
        case .phishing: return "Emails fraudulentos que intentan robar información personal o financiera"
        case .fraudeFinanciero: return "Estafas relacionadas con transacciones bancarias y tarjetas de crédito"
        case .estafasTelefonicas: return "Llamadas fraudulentas que buscan obtener información o dinero"
        case .malware: return "Software malicioso que puede dañar tu dispositivo o robar información"
        case .redesWiFiFalsas: return "Puntos de acceso WiFi creados para interceptar datos"
        case .estafasRedesSociales: return "Fraudes que ocurren a través de plataformas de redes sociales"
        }
    }
    
    var icon: String {
        switch self {
        case .phishing: return "envelope.fill"
        case .fraudeFinanciero: return "creditcard.fill"
        case .estafasTelefonicas: return "phone.fill"
        case .malware: return "exclamationmark.triangle.fill"
        case .redesWiFiFalsas: return "wifi"
        case .estafasRedesSociales: return "message.fill"
        }
    }
    
    var severity: String {
        switch self {
        case .phishing: return "Alto"
        case .fraudeFinanciero: return "Crítico"
        case .estafasTelefonicas: return "Alto"
        case .malware: return "Alto"
        case .redesWiFiFalsas: return "Medio"
        case .estafasRedesSociales: return "Medio"
        }
    }
    
    var severityColor: Color {
        switch self {
        case .phishing: return .orange
        case .fraudeFinanciero: return .red
        case .estafasTelefonicas: return .orange
        case .malware: return .orange
        case .redesWiFiFalsas: return .yellow
        case .estafasRedesSociales: return .yellow
        }
    }
    
    var reports: String {
        switch self {
        case .phishing: return "1245"
        case .fraudeFinanciero: return "856"
        case .estafasTelefonicas: return "692"
        case .malware: return "423"
        case .redesWiFiFalsas: return "234"
        case .estafasRedesSociales: return "367"
        }
    }
}

#Preview {
    CategoryDetailView(category: .phishing)
}
