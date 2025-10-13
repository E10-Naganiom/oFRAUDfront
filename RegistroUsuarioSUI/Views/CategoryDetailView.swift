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
                                .foregroundColor(.green)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
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
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            .navigationTitle(category.titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") { dismiss() }.foregroundColor(.green)
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
        VStack(spacing: 0) {
            // Botón header
            Button(action: { expanded.toggle() }) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.green)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
            }
            
            // Contenido expandible (pegado al header)
            if expanded {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(getBulletPoints(), id: \.self) { point in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.subheadline)
                                .foregroundColor(.green)
                            Text(point)
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray5))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func getBulletPoints() -> [String] {
        let sentences = content
            .components(separatedBy: ". ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        return sentences
    }
}
