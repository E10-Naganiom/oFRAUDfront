//
//  HomeScreen.swift
//  RegistroUsuarioSUI
//
//  Created by Usuario on 15/09/25.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        TabView{
            Tab{
                NavigationStack{
                    DashboardView()
                }
            }label:{
                Label("Inicio", systemImage:"house.and.flag")
            }
            
            Tab{
                NavigationStack{
                    HistorialView()
                }
            }label:{
                Label("Historial", systemImage: "clock.arrow.circlepath")
            }
            
            Tab{
                NavigationStack{
                    GuidesView()
                }
            }label:{
                Label("Guias", systemImage: "book")
            }
            
            Tab{
                NavigationStack{
                    StatisticsView()
                }
            }label:{
                Label("Estadísticas", systemImage: "chart.bar.fill")
            }
            
            Tab{
                NavigationStack{
                    ProfileView()
                }
            }label: {
                Label("Perfil", systemImage: "person.crop.circle")
            }
        }.tint(.green)
    }
}

#Preview {
    HomeScreen()
}
