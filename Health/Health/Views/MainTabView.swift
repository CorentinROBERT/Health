//
//  MainTabView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SportView()
                .tabItem {
                    Label("Sport", systemImage: "figure.run")
                }
            
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "leaf")
                }
            
            HealthView()
                .tabItem {
                    Label("Santé", systemImage: "heart")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainTabView()
}
