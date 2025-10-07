//
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI

struct CategoryCardView: View {
    let icon: String
    let title: String
    let description: String
    let severity: String?
    let severityColor: Color
    let reports: String
    let trending: Bool
    let onTapMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.headline)
                        Spacer()
                        Text(severity!)
                            .font(.caption.bold())
                            .foregroundColor(severityColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(severityColor.opacity(0.2))
                            .cornerRadius(8)
                    }
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            HStack {
                Text("\(reports) reportes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if trending {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right")
                            .font(.caption2)
                        Text("Tendencia")
                            .font(.caption2)
                    }
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button("Ver más") {
                    onTapMore()
                }
                .font(.caption.bold())
                .foregroundColor(.green)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

#Preview {
    CategoryCardView(
        icon: "envelope.fill",
        title: "Phishing por Email",
        description: "Emails fraudulentos que intentan robar información personal o financiera",
        severity: "Alto",
        severityColor: .orange,
        reports: "1245",
        trending: true,
        onTapMore: {
            print("Ver más tapped")
        }
    )
}
