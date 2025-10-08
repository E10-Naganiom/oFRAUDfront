//
//  IncidentCardView.swift
//  RegistroUsuarioSUI
//

import SwiftUI

struct IncidentCardView: View {
    let incident : IncidentFormResponse
    
    let categories: [CategoryFormResponse]
    
    @State private var estatus: String = "Cargando ..."
    

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header con icono y estatus
            HStack {
                Image(systemName: "exclamationmark.shield.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(incident.titulo)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(obtenerNombreCategoria(id: incident.id_categoria))
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
                    Label(incident.fecha_creacion, systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label("Últ. act: \(incident.fecha_actualizacion)", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("Creado por: \(incident.id_usuario)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Divider
            Divider()
                .padding(.vertical, 4)
            
            // Botón Ver más (NavigationLink)
            HStack {
                Spacer()
                NavigationLink(destination: IncidentDetailView(incidente: incident, categories: categories, estatus: estatus)) {
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
        .task {
            await fetchEstatus(id: incident.id_estatus)
        }
    }
    private func obtenerNombreCategoria(id: Int) -> String {
        for categoria in categories {
            if categoria.id == id {
                return categoria.titulo
            }
        }
        return "No especificada"
    }
    
    private func fetchEstatus(id: Int) async {
        let incidentsController = IncidentsController(incidensClient: IncidentsClient())
        do {
            estatus = try await incidentsController.getStatus(id: id)
        }
        catch {
            print("No se pudo obtener el estatus con id \(id)")
            estatus = "Desconocido"
        }
    }
}

//#Preview {
//    VStack(spacing: 12) {
//        IncidentCardView(
//            incident: IncidentFormResponse (
//                id: 1,
//                titulo: "Malware detectado",
//                id_categoria: 1,
//                nombre_atacante: "Barbie",
//                telefono: "123",
//                correo: "abc@tec.mx",
//                user_red: "barbie",
//                red_social: "TikTok",
//                descripcion: "Hola hola",
//                fecha_creacion: "Ayer",
//                fecha_actualizacion: "Hoy",
//                id_usuario: 1,
//                supervisor: 2,
//                id_estatus: 1,
//                es_anonimo: true
//        ))
//    }
//    .padding()
//}
