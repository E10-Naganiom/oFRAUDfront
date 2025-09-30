//
//  ReportView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI


struct ReportView: View {
    
    @State private var titulo = ""
    @State private var idCategoria = 0
    @State private var tipoIncidente = "Phishing"
    @State private var atacante = ""
//    @State private var fechaIncidente = Date()
    @State private var es_anonimo = false
    
    @State private var contactos: [MetodoContacto] = []
    @State private var descripcion = ""
    @State private var archivosAdjuntos: [String] = []
    
    let categorias = ["Phishing", "Malware", "Ransomware", "Fraude", "Otro"]
    let redesSociales = ["Twitter/X", "Facebook", "Instagram", "LinkedIn", "Otro"]
    
    var body: some View {
        Form {
            // Instrucciones
            Section {
                Text("Por favor completa la información del incidente de la forma más detallada posible. Esto nos ayudará a investigar y responder adecuadamente.")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
            
            // Info básica
            Section(header: Text("Información Básica")) {
                TextField("Título del incidente", text: $titulo)
                TextField("Id categoria", value: $idCategoria, format: .number)
                
//                Picker("Tipo de incidente", selection: $tipoIncidente) {
//                    ForEach(categorias, id: \.self) { cat in
//                        Text(cat)
//                    }
//                }
                
                TextField("Empresa o individuo atacante", text: $atacante)
                
//                DatePicker(
//                    "Fecha del incidente",
//                    selection: $fechaIncidente,
//                    in: ...Date(),
//                    displayedComponents: [.date]
//                )
            }
            
            // Métodos de contacto
            Section(
                header: HStack {
                    Text("Métodos de contacto")
                    Spacer()
                    Button(action: {
                        if contactos.count < 5 {
                            contactos.append(MetodoContacto())
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            ) {
                if contactos.isEmpty {
                    Text("No se han agregado métodos de contacto.")
                        .foregroundColor(.gray)
                } else {
                    ForEach($contactos) { $contacto in
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Tipo", selection: $contacto.tipo) {
                                Text("Teléfono").tag("Teléfono")
                                Text("Correo").tag("Correo")
                                Text("Red Social").tag("Red Social")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if contacto.tipo == "Teléfono" {
                                TextField("Número de teléfono", text: $contacto.valor)
                                    .keyboardType(.phonePad)
                            } else if contacto.tipo == "Correo" {
                                TextField("Correo electrónico", text: $contacto.valor)
                                    .keyboardType(.emailAddress)
                            } else if contacto.tipo == "Red Social" {
                                Picker("Plataforma", selection: $contacto.redSocial) {
                                    ForEach(redesSociales, id: \.self) { red in
                                        Text(red)
                                    }
                                }
                                TextField("Usuario (@ejemplo)", text: $contacto.valor)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            // Descripción
            Section(header: Text("Descripción del incidente")) {
                TextEditor(text: $descripcion)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3))
                    )
            }
            
            // Archivos adjuntos
            Section(
                header: HStack {
                    Text("Archivos adjuntos (máx. 5)")
                    Spacer()
                    Button(action: {
                        if archivosAdjuntos.count < 5 {
                            archivosAdjuntos.append("archivo\(archivosAdjuntos.count+1).pdf")
                        }
                    }) {
                        Image(systemName: "paperclip.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            ) {
                if archivosAdjuntos.isEmpty {
                    Text("No se han subido archivos.")
                        .foregroundColor(.gray)
                } else {
                    ForEach(archivosAdjuntos, id: \.self) { archivo in
                        Text("📎 \(archivo)")
                    }
                }
            }
            
            Section{
                HStack{
                    Text("Desea que su reporte sea anonimo?")
                    Spacer()
                    Toggle("", isOn: $es_anonimo)
                }
            }
            // Nota importante
            Section {
                Text("⚠️ Importante: No compartas información personal o sensible en este formulario. Solo incluye detalles relevantes del incidente.")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
            
            // Botón enviar
            Section {
                Button(action: {
                    Task{
                        do{
                            let controller = IncidentsController(incidensClient: IncidentsClient())
                            let response = try await controller.createIncident(
                                titulo: titulo,
                                id_categoria: idCategoria,
                                nombre_atacante: atacante.isEmpty ? nil : atacante,
                                telefono: contactos.first(where: { $0.tipo == "Teléfono"})?.valor,
                                correo: contactos.first(where: { $0.tipo == "Correo"})?.valor,
                                user: contactos.first(where: { $0.tipo == "Red Social"})?.valor,
                                red_social: contactos.first(where: { $0.tipo == "Red Social"})?.redSocial,
                                descripcion: descripcion,
                                id_usuario: 1,
                                supervisor: nil,
                                es_anonimo: es_anonimo
                            )
                            print("Incidente creado con exito", response)
                        } catch {
                            print("Error al crear incidente", error)
                        }
                    }
                }) {
                    Text("Enviar reporte")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Levantar Reporte")
    }
}


// MARK: - Modelo de método de contacto
struct MetodoContacto: Identifiable {
    let id = UUID()
    var tipo: String = "Teléfono"
    var valor: String = ""
    var redSocial: String = "Twitter/X"
}


#Preview {
    NavigationStack {
        ReportView()
    }
}
