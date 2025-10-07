import SwiftUI

struct GuidesView: View {
    @State private var categories: [CategoryFormResponse] = []
    @State private var selectedCategory: CategoryFormResponse?
    @State private var isLoading = true
    
    // Diccionario para íconos fijos por categoría
    @State private var categoryIcons: [Int: String] = [:]
    
    // Lista de íconos posibles
    private let icons = [
        "lock.fill", "shield.fill", "exclamationmark.triangle.fill",
        "globe", "key.fill", "network", "person.crop.circle.badge.exclam",
        "bolt.fill", "flame.fill", "eye.trianglebadge.exclamationmark"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Header
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.green)
                        Text("Categorías de Incidentes")
                            .font(.headline)
                    }
                    Text("Aprende sobre diferentes tipos de amenazas cibernéticas")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Lista dinámica
                VStack(spacing: 12) {
                    if isLoading {
                        ProgressView("Cargando categorías...")
                    } else {
                        ForEach(categories, id: \.id) { category in
                            CategoryCardView(
                                icon: categoryIcons[category.id] ?? randomIcon(for: category),
                                title: category.titulo,
                                description: category.descripcion,
                                severity: mapRiskToSeverity(category.id_riesgo),
                                severityColor: mapRiskToColor(category.id_riesgo),
                                reports: "0",
                                trending: false,
                                onTapMore: {
                                    selectedCategory = category
                                }
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Guías")
        .sheet(item: $selectedCategory) { category in
            CategoryDetailView(category: category)
        }
        .task {
            await loadCategories()
        }
    }
    
    private func loadCategories() async {
        let controller = CategoriesController(categoriesClient: CategoriesClient())
        do {
            categories = try await controller.getAllCategories()
            
            // Asignar íconos solo si no existen
            for category in categories {
                if categoryIcons[category.id] == nil {
                    categoryIcons[category.id] = icons.randomElement() ?? "shield.fill"
                }
            }
        } catch {
            print("Error cargando categorías:", error)
        }
        isLoading = false
    }
    
    private func randomIcon(for category: CategoryFormResponse) -> String {
        let newIcon = icons.randomElement() ?? "shield.fill"
        categoryIcons[category.id] = newIcon
        return newIcon
    }
    
    private func mapRiskToSeverity(_ id_riesgo: Int) -> String {
        switch id_riesgo {
        case 1: return "Bajo"
        case 2: return "Medio"
        case 3: return "Alto"
        case 4: return "Crítico"
        default: return "Desconocido"
        }
    }
    
    private func mapRiskToColor(_ id_riesgo: Int) -> Color {
        switch id_riesgo {
        case 1: return .green
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        default: return .gray
        }
    }
}
