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
                        Text("Estado:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                            Text(estatus)
                                .font(.subheadline.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(12)
                    }
                    
                    HStack {
                        Text("Creacion:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(incidente.fecha_creacion)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Última actualización:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(incidente.fecha_actualizacion)
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading){
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
                
                //if !incident.attachments.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Archivos adjuntos")
                            .font(.headline)
                        //ForEach(incident.attachments, id: \.self) { file in
                            HStack {
                                Image(systemName: "paperclip")
                                    .foregroundColor(.blue)
                                Text("Archivo")
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.blue)
                            }
                            .padding(8)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                        //}
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                //}
                

                VStack(alignment: .leading, spacing: 8) {
                    Text("Medios de contacto")
                        .font(.headline)
                    //ForEach(incident.attachments, id: \.self) { file in
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.blue)
                            Text("Telefono")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Text("E-mail")
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    HStack {
                        Image(systemName: "at")
                            .foregroundColor(.blue)
                        Text("Red social")
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    //}
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
