import SwiftUI
import Charts // para las gráficas

struct DashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "Todas"
    
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
                    statisticsSection
                    recentActivitySection
                    securityTipSection
                    organizationSection
                }
                .padding()
            }
            
            floatingActionButton
        }
        .navigationTitle("Dashboard")
        .onAppear {
            // Selecciona un consejo aleatorio al aparecer la vista
            if let randomTip = securityTips.randomElement() {
                currentTip = randomTip
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bienvenid@ a oFraud")
                .font(.title.bold())
                .padding(.top)
            
            Text("Mantente protegido con las últimas actualizaciones de seguridad")
                .font(.headline)
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
                
                Picker("Filtrar por tipo", selection: $selectedFilter) {
                    ForEach(filtros, id: \.self) { tipo in
                        Text(tipo)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
                
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
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            pieChartSection
            barChartSection
        }
    }
    
    private var pieChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "network")
                    .foregroundColor(.orange)
                Text("Incidentes más comunes")
                    .font(.title2.bold())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(totalSessions.formatted())")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                
                Text("Total de sesiones • Por fuente")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 20) {
                Chart(trafficSources, id: \.0) { source in
                    SectorMark(
                        angle: .value("Count", source.1),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(source.3)
                }
                .frame(width: 120, height: 120)
                
                pieChartLegend
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var pieChartLegend: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(trafficSources.enumerated()), id: \.offset) { index, source in
                HStack {
                    Circle()
                        .fill(source.3)
                        .frame(width: 8, height: 8)
                    
                    Text(source.0)
                        .font(.caption)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("\(source.1.formatted())")
                            .font(.caption.bold())
                            .foregroundColor(.primary)
                        
                        Text("\(source.2, specifier: "%.1f")%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color(.quaternarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var barChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "eye")
                    .foregroundColor(.orange)
                Text("Número de Reportes")
                    .font(.title2.bold())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(currentVisits.formatted())")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                
                Text("Visitas totales • Tendencia")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Chart(visitData, id: \.0) { data in
                BarMark(
                    x: .value("Periodo", data.0),
                    y: .value("Visitas", data.1)
                )
                .foregroundStyle(data.0 == "Mes Actual" ? Color.green : Color.blue)
                .cornerRadius(4)
            }
            .frame(height: 150)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            barChartStats
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var barChartStats: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Período Anterior")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("\(previousVisits.formatted())")
                    .font(.headline.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Rectangle()
                .fill(.gray.opacity(0.3))
                .frame(width: 1, height: 30)
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Período Actual")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text("\(currentVisits.formatted())")
                    .font(.headline.bold())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.top, 8)
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Actividad reciente")
                    .font(.title2.bold())
                    .padding(.top)
                
                Spacer()
                
                NavigationLink(destination: ResultsView()) {
                    Text("Ver todo")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
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
