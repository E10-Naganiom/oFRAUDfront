//
//  OrganizationView.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 23/09/25.
//

import SwiftUI
import MapKit

struct OrganizationView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 19.2840617, longitude: -99.1361044),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var showPrivacyPolicy: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 80, height: 80)
                        Image(systemName: "shield.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                    }
                    
                    Text("Red por la Ciberseguridad")
                        .font(.title2.bold())
                    
                    Text("Comprometidos con la Seguridad Cibernética de Hoy y del Futuro")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(16)
                
                // Misión y Visión
                VStack(alignment: .leading, spacing: 16) {
                    Text("Nuestra Misión")
                        .font(.headline)
                    
                    Text("Garantizar que todas las personas, especialmente las mujeres y niñas, puedan ejercer plenamente su capacidad humana derechos mediante el uso de la tecnología.")
                        .foregroundColor(.secondary)
                    
                    Text("Nuestra Visión")
                        .font(.headline)
                        .padding(.top)
                    
                    Text("Garantizar que todas las personas, especialmente las mujeres y niñas, puedan ejercer plenamente su capacidad humana derechos mediante el uso de la tecnología.")
                        .foregroundColor(.secondary)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Canales de contacto
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "phone.circle.fill")
                            .foregroundColor(.green)
                        Text("Canales de Contacto")
                            .font(.headline)
                    }
                    
                    Text("Múltiples formas de contactarnos según tu necesidad")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Métodos de contacto
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Teléfono")
                                    .font(.subheadline.bold())
                                Text("(656) 4990493")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button("Llamar") {
                                if let url = URL(string: "tel:6564990493") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.caption.bold())
                            .foregroundColor(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Correo Electrónico")
                                    .font(.subheadline.bold())
                                Text("contacto@redporlaciberseguridad.org")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            Spacer()
                            Button("Enviar Email") {
                                if let url = URL(string: "mailto:contacto@redporlaciberseguridad.org") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.caption.bold())
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Página Web")
                                    .font(.subheadline.bold())
                                Text("redporlaciberseguridad.org")
                                    .font(.caption)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            Spacer()
                            Button("Visitar Sitio") {
                                if let url = URL(string: "https://redporlaciberseguridad.org") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.caption.bold())
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Iniciativas
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.green)
                        Text("Nuestras iniciativas")
                            .font(.headline)
                    }
                    
                    VStack(spacing: 12) {
                        HStack(alignment: .top) {
                            Image(systemName: "graduationcap.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("LikeInteligente")
                                    .font(.subheadline.bold())
                                Text("Programa enfocado en educar a los niños y sus padres sobre cómo utilizar la tecnología de forma responsable y segura.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("MorrasTIC")
                                    .font(.subheadline.bold())
                                Text("Iniciativa liderada por mujeres que abren clubes en escuelas para apoyar y motivar a las mujeres en áreas TIC + Ciberseguridad")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "briefcase.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Operación Aleph")
                                    .font(.subheadline.bold())
                                Text("Se necesitan profesionales en ciberseguridad en México para 2030.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "shield.lefthalf.filled")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Centro de Derechos Digitales y Ciberseguridad")
                                    .font(.subheadline.bold())
                                Text("Primera línea de respuesta en materia de Ciberseguridad emergencias de personas y pequeñas y medianas empresas.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(16)
                
                // Información Legal
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.green)
                        Text("Información Legal")
                            .font(.headline)
                    }
                    
                    Button("Política de Privacidad, Términos y Condiciones") {
                        showPrivacyPolicy = true
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                Text("Red por la Ciberseguridad © 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .padding()
        }
        .navigationTitle("Sobre Nosotros")
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView(isPresented: $showPrivacyPolicy)
                .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    NavigationStack {
        OrganizationView()
    }
}
