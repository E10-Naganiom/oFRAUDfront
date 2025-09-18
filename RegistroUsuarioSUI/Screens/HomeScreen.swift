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
                        Text("Pagina de estadisticas y de incidencias")
                    }
                }label:{
                    Label("Inicio", systemImage:"house.and.flag")
                }
                Tab{
                    NavigationStack{
                        Text("Pagina historial")
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
                        Text("Pagina perfil del usuario")
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
