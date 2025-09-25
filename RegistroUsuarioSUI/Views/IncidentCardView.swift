//
//  IncidentCardView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import SwiftUI


struct IncidentCardView: View {


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Titulo/ID del incidente")
                    .font(.headline)
                Spacer()
                
                NavigationLink(destination: IncidentDetailView()){
                    Image(systemName: "eye")
                        .foregroundColor(.green).padding(6).background(Color(.systemGray5)).clipShape(Circle())
                }.buttonStyle(PlainButtonStyle())
                Text("Estatus del incidente")
                    .font(.caption)
                    .padding(6)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
            }


            Text("Categoria")
                .font(.subheadline)
                .foregroundColor(.primary)


            HStack {
                Label("Fecha del incidente", systemImage: "calendar")
                Spacer()
                Image(systemName: "paperclip")
                Text(" X Archivos adjuntos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }


            Text("Última actualización:")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("Reportado por:")
                .font(.caption2)
                .foregroundColor(.secondary)

        }
        .padding()
        .background(Color(.green).opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    IncidentCardView()
}
