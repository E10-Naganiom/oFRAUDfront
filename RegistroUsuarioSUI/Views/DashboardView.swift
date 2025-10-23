import SwiftUI

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Todas"
    @State private var loadingFeed = true
    
    @State private var latestIncidents: [IncidentFormResponse] = []
    @State private var categories: [CategoryFormResponse] = []
    
    let filtros = ["Todas", "Phishing", "Malware", "Ransomware", "Fraude"]
    
    // Datos hardcodeados para fuentes de tráfico
    let trafficSources = [
        ("Phishing", 1250, 42.5, Color.yellow),
        ("Malware", 850, 28.9, Color.blue),
        ("Ransomware", 520, 17.7, Color.red),
        ("Llamadas", 320, 10.9, Color.green)
    ]
    
    // Datos hardcodeados para visitas
    let visitData = [
        ("Mes anterior", 3250),
        ("Mes Actual", 4180)
    ]
    
    // Array de consejos de seguridad
    let securityTips = [
        "Nunca hagas clic en enlaces sospechosos recibidos por correo electrónico.",
        "Usa contraseñas únicas y cámbialas regularmente.",
        "Evita conectarte a redes Wi-Fi públicas sin una VPN.",
        "Verifica siempre la dirección del remitente antes de abrir un correo.",
        "Mantén tu software y antivirus actualizados.",
        "No compartas información personal en redes sociales.",
        "Activa la autenticación de dos factores siempre que sea posible.",
        "Revisa las URLs antes de iniciar sesión, especialmente si llegaron desde un enlace.",
        "No compartas códigos de verificación o contraseñas, ni siquiera con supuestos agentes de soporte.",
        "Configura alertas en tus cuentas bancarias para detectar movimientos sospechosos rápidamente."
    ]
    
    @State private var currentTip = ""
    
    var totalSessions: Int {
        trafficSources.reduce(0) { $0 + $1.1 }
    }
    
    var currentVisits: Int { 4180 }
    var previousVisits: Int { 3250 }
    
    // ✨ NUEVA: Propiedad computada para filtrar incidentes en tiempo real
    var filteredIncidents: [IncidentFormResponse] {
        var result = latestIncidents
        
        // Filtro por texto de búsqueda
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespaces)
        if !trimmedSearch.isEmpty {
            result = result.filter { incident in
                let searchLower = trimmedSearch.lowercased()
                return String(incident.id).contains(searchLower) ||
                       incident.titulo.lowercased().contains(searchLower) ||
                       incident.descripcion.lowercased().contains(searchLower)
            }
        }
        
        // Filtro por categoría seleccionada
        if selectedFilter != "Todas" {
            // Buscar el ID de la categoría seleccionada
            if let selectedCategory = categories.first(where: { $0.titulo == selectedFilter }) {
                result = result.filter { $0.id_categoria == selectedCategory.id }
            }
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            // Fondo adaptable al modo oscuro/claro
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    searchSection
                    recentActivitySection
                    securityTipSection
                    organizationSection
                }
                .padding()
            }
            
            floatingActionButton
        }
        .onAppear {
            // Selecciona un consejo aleatorio al aparecer la vista
            if let randomTip = securityTips.randomElement() {
                currentTip = randomTip
            }
        }
        .task {
            await getFeed()
        }
    }
    
    private func getFeed() async {
        loadingFeed = true
        defer { loadingFeed = false }
        let controller = IncidentsController(incidentsClient: IncidentsClient())
        let categoriesController = CategoriesController(categoriesClient: CategoriesClient())
        do {
            categories = try await categoriesController.getAllCategories()
            latestIncidents = try await controller.getFeed()
        }
        catch {
            print("No se pudo obtener el feed ni categorias de los incidentes: \(error)")
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bienvenid@ a oFraud")
                .font(.title.bold())
            
            Text("Mantente protegido con las últimas actualizaciones de seguridad")
                .font(.subheadline).foregroundColor(.gray)
        }
    }
    
    // ✨ MODIFICADA: Sección de búsqueda sin botón "Buscar"
    private var searchSection: some View {
        VStack {
            HStack {
                TextField("Buscar incidentes por título o descripción", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled() // ✨ Desactivar autocorrección
                    .padding(.bottom, 8)
                
                // ✨ NUEVO: Botón para limpiar búsqueda
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)
                }
            }
            
            HStack {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Filtrar por categoría")
                
                if loadingFeed {
                    ProgressView("Cargando categorias ...")
                } else {
                    Picker("Categoria", selection: $selectedFilter){
                        Text("Todas").tag("Todas")
                        ForEach(categories, id: \.id) { cat in
                            Text(cat.titulo).tag(cat.titulo)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                
                // ✨ ELIMINADO: NavigationLink con botón "Buscar"
                // El filtrado ahora es automático
            }
            
            // ✨ NUEVO: Contador de resultados
            if !searchText.isEmpty || selectedFilter != "Todas" {
                Text("\(filteredIncidents.count) resultado(s) encontrado(s)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical)
    }
    
    // ✨ MODIFICADA: Ahora usa filteredIncidents en lugar de latestIncidents
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Actividad reciente")
                    .font(.title2.bold())
                Spacer()
                NavigationLink(destination: ResultsView()) {
                    Text("Ver todo")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            VStack(spacing: 16) {
                if loadingFeed {
                    ProgressView("Cargando feed")
                        .padding()
                        .frame(maxWidth: .infinity)
                } else if latestIncidents.isEmpty {
                    // ✨ MODIFICADO: Mensaje cuando no hay datos del backend
                    Text("No hay incidentes registrados")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else if filteredIncidents.isEmpty {
                    // ✨ NUEVO: Mensaje cuando hay datos pero no coinciden con la búsqueda
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No se encontraron coincidencias")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Intenta con otros términos de búsqueda")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                } else {
                    // ✨ MODIFICADO: Usa filteredIncidents en lugar de latestIncidents
                    ForEach(filteredIncidents) { incident in
                        IncidentCardView(incident: incident, categories: categories)
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }.frame(maxWidth: .infinity)
    }
    
    private var securityTipSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb.min.fill")
                Text("Consejo de seguridad")
                    .font(.title3.bold())
            }
            Text(currentTip)
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.green.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var organizationSection: some View {
        NavigationLink(destination: OrganizationView()) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 60, height: 60)
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Conocer Nuestra Organización")
                        .font(.headline)
                    Text("Información sobre Red por la Ciberseguridad")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: ReportView()) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                }
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
