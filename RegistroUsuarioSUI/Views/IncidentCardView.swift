//
//  IncidentCardView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 17/09/25.
//

import SwiftUI


struct IncidentCardView: View {
    
    let titulo: String
    let estatus: String
    let categoria: String
    let fecha_creacion: String
    let fecha_update: String
    let usuario_alta: String
    

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.headline)
                Spacer()
                
                NavigationLink(destination: IncidentDetailView()){
                    Image(systemName: "eye")
                        .foregroundColor(.green).padding(6).background(Color(.systemGray5)).clipShape(Circle())
                }.buttonStyle(PlainButtonStyle())
                Text(estatus)
                    .font(.caption)
                    .padding(6)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.orange)
                    .cornerRadius(8)
            }


            Text(categoria)
                .font(.subheadline)
                .foregroundColor(.primary)


            HStack {
                Label(fecha_creacion, systemImage: "calendar")
                Spacer()
                Image(systemName: "paperclip")
                Text(" X Archivos adjuntos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }


            Text("Última actualización:" + fecha_update)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("Creado por: " + usuario_alta)
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
    IncidentCardView(
        titulo: "TITULO", estatus: "ESTATUS", categoria: "CATEGORIA", fecha_creacion: "FECHA", fecha_update: "FECHA2", usuario_alta: "USUARIO"
    )
}
