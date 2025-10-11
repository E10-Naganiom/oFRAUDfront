//
//  IncidentDetailView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 18/09/25.
//

import SwiftUI


struct IncidentDetailView: View {
    
    let incidente : IncidentFormResponse
    let categories: [CategoryFormResponse]
    
    let estatus: String
    let nombreCompleto: String
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                

                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                    Text("Detalle del Incidente")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 8)
                

                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        Text("Titulo:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(incidente.titulo)
                            .font(.subheadline.bold())
                    }
                    
                    HStack {
                        Text("Categoria:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(obtenerNombreCategoria(id: incidente.id_categoria))
                            .font(.subheadline.bold())
                    }
                    
                    HStack {
                        Text("Usuario:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        if(!incidente.es_anonimo){
                            Text(nombreCompleto)
                                .font(.subheadline.bold())
                        }
                        else {
                            Text("Anonimo")
                                .font(.subheadline.bold())
                        }
                    }
                    
                    HStack {
                        Text("Estado:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                            Text(estatus)
                                .font(.subheadline.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(getColorStatus(incidente.id_estatus).opacity(0.15))
                                .foregroundColor(getColorStatus(incidente.id_estatus))
                                .cornerRadius(12)
                    }
                    
                    HStack {
                        Text("Creacion:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatISODate(incidente.fecha_creacion))
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Última actualización:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(formatISODate(incidente.fecha_actualizacion))
                            .font(.subheadline)
                    }
                    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 12){
                    Text("Descripcion del incidente").font(.headline)
                    Spacer()
                    HStack {
                        Text (incidente.descripcion)
                    }
    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                

                VStack(alignment: .leading, spacing: 12) {
                    Text("Medios de contacto")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    // Atacante
                    HStack(spacing: 12) {
                        Image(systemName: "person.badge.shield.exclamationmark.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Atacante")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text((incidente.nombre_atacante ?? "").isEmpty ? "No proporcionado" : incidente.nombre_atacante!)
                                .font(.subheadline.bold())
                        }
                        Spacer()
                    }
                    
                    // Teléfono
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Teléfono")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text((incidente.telefono ?? "").isEmpty ? "No proporcionado" : incidente.telefono!)
                                .font(.subheadline.bold())
                        }
                        Spacer()
                    }
                    
                    // Correo
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Correo electrónico")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text((incidente.correo ?? "").isEmpty ? "No proporcionado" : incidente.correo!)
                                .font(.subheadline.bold())
                        }
                        Spacer()
                    }
                    
                    // Red social
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
                            .foregroundColor(.blue)
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Usuario en red social")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text((incidente.user_red ?? "").isEmpty ? "No proporcionado" : incidente.user_red!)
                                .font(.subheadline.bold())
                            Text((incidente.red_social ?? "").isEmpty ? "No proporcionado" : incidente.red_social!)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                
                if let evidencias = incidente.files, !evidencias.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Evidencias")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 10)], spacing: 10) {
                            ForEach(evidencias) { evidencia in
                                if let url = URL(string: evidencia.url),
                                   evidencia.url.lowercased().hasSuffix(".jpg") ||
                                   evidencia.url.lowercased().hasSuffix(".jpeg") ||
                                   evidencia.url.lowercased().hasSuffix(".png") {
                                    
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 120, height: 120)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipped()
                                                .cornerRadius(12)
                                                .shadow(radius: 2)
                                        case .failure:
                                            Image(systemName: "xmark.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                                .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "doc.text.fill")
                                            .resizable()
                                            .frame(width: 40, height: 50)
                                            .foregroundColor(.gray)
                                        Text("Documento")
                                            .font(.caption2)
                                    }
                                    .frame(width: 120, height: 120)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                } else {
                    Text("No hay evidencias registradas.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }

            }
            .padding()
        }
        .navigationTitle("Incidente")
        .navigationBarTitleDisplayMode(.inline)
    }
    private func obtenerNombreCategoria(id: Int) -> String {
        for categoria in categories {
            if categoria.id == id {
                return categoria.titulo
            }
        }
        return "No especificada"
    }
    
}






//#Preview {
//    IncidentDetailView(
//        incidente: IncidentFormResponse (
//            id: 1,
//            titulo: "Malware detectado",
//            id_categoria: 1,
//            nombre_atacante: "Barbie",
//            telefono: "123",
//            correo: "abc@tec.mx",
//            user_red: "barbie",
//            red_social: "TikTok",
//            descripcion: "Hola hola",
//            fecha_creacion: "Ayer",
//            fecha_actualizacion: "Hoy",
//            id_usuario: 1,
//            supervisor: 2,
//            id_estatus: 1,
//            es_anonimo: true
//    )
//    )
//}
