//
//  IncidentCardView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import SwiftUI


struct IncidentCardView: View {
    let incident: Incident


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(incident.id.description)
                    .font(.headline)
                Spacer()
                Text(incident.status)
                    .font(.caption)
                    .padding(6)
                    .background(incident.status == "Aprobado" ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .foregroundColor(incident.status == "Aprobado" ? .green : .orange)
                    .cornerRadius(8)
            }


            Text(incident.title)
                .font(.subheadline)
                .foregroundColor(.primary)


            HStack {
                Label(incident.createdAt.formatted(date: .abbreviated, time: .omitted), systemImage: "Calendar")
                Spacer()
                Text("\(incident.attachments) archivo\(incident.attachments > 1 ? "s" : "")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }


            Text("Última actualización: \(incident.lastUpdated.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

//#Preview {
//    IncidentCardView()
//}
