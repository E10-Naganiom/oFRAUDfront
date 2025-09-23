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
        NavigationStack {
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
                        Text("Pagina categorias")
                    }
                }label:{
                    Label("Guias", systemImage: "book")
                }
                Tab{
                    NavigationStack{
                        ProfileView()
                    }
                }label: {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
