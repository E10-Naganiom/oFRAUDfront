import SwiftUI

struct CategoryCardView: View {
    let id: Int
    let icon: String
    let title: String
    let description: String
    let severity: Int
    let severityColor: Color
    let reports: Int
    let trending: Bool
    let onTapMore: () -> Void
    
    let riesgo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Encabezado con ícono, título y descripción
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 26))
                    .foregroundColor(.green)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    
                        Text(riesgo)
                            .font(.caption)
                            .bold()
                            .padding(6)
                            .background(severityColor.opacity(0.2))
                            .foregroundColor(severityColor)
                            .clipShape(Capsule())
                    
                    if trending {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Divider()
            
            // Pie de tarjeta con número de reportes y botón
            HStack {
                Text("\(reports) reportes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: onTapMore) {
                    Label("Ver más", systemImage: "arrow.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

//#Preview {
//    VStack(spacing: 16) {
//        CategoryCardView(
//            icon: "shield.fill",
//            title: "Phishing",
//            description: "Aprende a identificar correos y sitios falsos diseñados para robar tus credenciales.",
//            severity: "Alto",
//            severityColor: .orange,
//            reports: "12",
//            trending: true,
//            onTapMore: {}
//        )
//        
//        CategoryCardView(
//            icon: "lock.fill",
//            title: "Contraseñas débiles",
//            description: "Los riesgos de usar contraseñas predecibles o repetidas.",
//            severity: "Medio",
//            severityColor: .yellow,
//            reports: "5",
//            trending: false,
//            onTapMore: {}
//        )
//    }
//    .padding()
//    .background(Color(.systemGroupedBackground))
//}
