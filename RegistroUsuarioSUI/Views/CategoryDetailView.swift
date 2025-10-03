import SwiftUI


struct CategoryDetailView: View {
    let category: CategoryFormResponse
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header con info de backend
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(category.titulo)
                                    .font(.title2.bold())
                                Text(category.descripcion)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Text("Riesgo: \(category.id_riesgo)")
                                .font(.caption.bold())
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    // Secciones dinámicas desde backend
                    if let senales = category.senales {
                        ExpandableTextSection(title: "Señales Comunes", content: senales)
                    }
                    if let prevencion = category.prevencion {
                        ExpandableTextSection(title: "Cómo Prevenirlo", content: prevencion)
                    }
                    if let acciones = category.acciones {
                        ExpandableTextSection(title: "Qué Hacer Si Ocurre", content: acciones)
                    }
                    if let ejemplos = category.ejemplos {
                        ExpandableTextSection(title: "Ejemplos Comunes", content: ejemplos)
                    }
                }
                .padding()
            }
            .navigationTitle(category.titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }
}


struct ExpandableTextSection: View {
    let title: String
    let content: String
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { expanded.toggle() }) {
                HStack {
                    Text(title).font(.headline)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            if expanded {
                Text(content)
                    .font(.subheadline)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
            }
        }
    }
}





