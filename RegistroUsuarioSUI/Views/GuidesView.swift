import SwiftUI


struct GuidesView: View {
    @State private var categories: [CategoryFormResponse] = []
    @State private var selectedCategory: CategoryFormResponse?
    @State private var isLoading = true
    
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
                                icon: "shield.fill",
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
        } catch {
            print("Error cargando categorías:", error)
        }
        isLoading = false
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



