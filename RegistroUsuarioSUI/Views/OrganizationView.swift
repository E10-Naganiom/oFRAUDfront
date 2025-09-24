//
//  AboutUsView.swift
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
                                Text("Disponible Lu-Vi 09-21 hrs")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("(+52) 55 1234 6789")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button("Llamar") {
                                // llamar
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
                                Text("Respuesta menor a 24 horas")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("contacto@oFraud.org")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button("Enviar Email") {
                                // email
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
                            Image(systemName: "message.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Chat en Vivo")
                                    .font(.subheadline.bold())
                                Text("Lunes a Viernes, 9:00 AM - 6:00 PM")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("chat.cyberseguridad.org")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button("Abrir Chat") {
                                // abrir chat
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
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            VStack(alignment: .leading) {
                                Text("Página Web")
                                    .font(.subheadline.bold())
                                Text("Para más recursos")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("https://oFraud.org/")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button("Visitar Sitio") {
                                // visitar sitio
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
                
                // Ubicación
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.green)
                        Text("Ubicación")
                            .font(.headline)
                    }
                    HStack{
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tec de Monterrey")
                                .font(.subheadline)
                            Text("Campus Ciudad de México")
                                .font(.subheadline)
                            Button("Ver en Mapa") {
                                let coordinate = CLLocationCoordinate2D(latitude: 19.2840617, longitude: -99.1361044)
                                let placemark = MKPlacemark(coordinate: coordinate)
                                let mapItem = MKMapItem(placemark: placemark)
                                mapItem.name = "Tec de Monterrey - Campus Ciudad de México"
                                mapItem.openInMaps()
                            }
                            .foregroundColor(.green)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Map(position: $position) {
                            Marker("Tec de Monterrey", coordinate: CLLocationCoordinate2D(latitude: 19.2426, longitude: -99.1375))
                                .tint(.green)
                        }
                        .disabled(true)
                        .frame(height: 120)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Equipo
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.green)
                        Text("Nuestro Equipo")
                            .font(.headline)
                    }
                    
                    Text("Expertos dedicados a tu seguridad digital")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Dr. Santiago Niño")
                                    .font(.subheadline.bold())
                                Text("Presidente")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Text("Análisis de Amenazas")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("15 años")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Initiatives
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
                
                // Legal info
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.green)
                        Text("Información Legal")
                            .font(.headline)
                    }
                    
                    Button("Política de Privacidad") {
                        // politicas
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(8)
                    
                    Button("Términos y Condiciones") {
                        // terminos
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
    }
}

#Preview {
    NavigationStack {
        OrganizationView()
    }
}
