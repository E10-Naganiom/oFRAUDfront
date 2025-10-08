//
//  IncidentCardView.swift
//  RegistroUsuarioSUI
//

import SwiftUI

struct IncidentCardView: View {
    let titulo: String
    let estatus: String
    let categoria: String
    let fecha_creacion: String
    let fecha_update: String
    let usuario_alta: String
    
    @State private var categories: [CategoryFormResponse] = []
    

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header con icono y estatus
            HStack {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(titulo)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(categoria)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(estatus)
                    .font(.caption)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.green.opacity(0.15))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
            
            // Fechas y usuario
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Label(fecha_creacion, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label("Últ. act: \(fecha_update)", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("Creado por: \(usuario_alta)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Divider
            Divider()
                .padding(.vertical, 4)
            
            // Botón Ver más (NavigationLink)
            HStack {
                Spacer()
                NavigationLink(destination: IncidentDetailView(titulo: titulo, categoria: categoria, estatus: estatus, fechaCreacion: fecha_creacion, fechaActualizacion: fecha_update, descripcion: "descripcion", telefono: "telefono", email: "email", user: "user", red: "red")) {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                        Text("Ver más")
                    }
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.15))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 12) {
        IncidentCardView(
            titulo: "Phishing detectado",
            estatus: "Abierto",
            categoria: "Phishing",
            fecha_creacion: "2025-10-07",
            fecha_update: "2025-10-07",
            usuario_alta: "omar_llano"
        )
        IncidentCardView(
            titulo: "Malware detectado",
            estatus: "Cerrado",
            categoria: "Malware",
            fecha_creacion: "2025-09-25",
            fecha_update: "2025-09-28",
            usuario_alta: "usuario2"
        )
    }
    .padding()
}
