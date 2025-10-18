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
        let controller = IncidentsController(incidensClient: IncidentsClient())
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
    
    private var searchSection: some View {
        VStack {
            HStack {
                TextField("Buscar incidentes por ID, tipo de incidente", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 8)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                Text("Filtrar por categoría")
                
//                Picker("Filtrar por tipo", selection: $selectedFilter) {
//                    ForEach(filtros, id: \.self) { tipo in
//                        Text(tipo)
//                    }
//                }
                
                if loadingFeed {
                    ProgressView("Cargando categorias ...")
                } else {
                    Picker("Categoria", selection: $selectedFilter){
                        ForEach(categories, id: \.id) { cat in
                            Text(cat.titulo).tag(Optional(cat.id))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: ResultsView()) {
                    Text("Buscar")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical)
    }
    
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
                    Text("No hay feed reciente")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                } else {
                    ForEach(latestIncidents) { incident in
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
