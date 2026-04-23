//
//  HomeView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Query private var users: [User]
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack{
            Text("Welcome \(users.first?.profile?.firstName.capitalized ?? "")")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            Spacer()
            
            VStack(spacing: 20) {
                
                Text("Calories aujourd'hui")
                    .font(.headline)
                
                Text("\(viewModel.todayCalories)")
                    .font(.largeTitle)
                    .bold()
                
                Text("Sport (min/semaine)")
                    .font(.headline)
                
                Text("\(viewModel.weeklySportMinutes)")
                    .font(.largeTitle)
                    .bold()
                
                Text("Poids actuel")
                    .font(.headline)
                
                Text("\(viewModel.currentWeight, specifier: "%.1f") kg")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            .onAppear {
                guard let user = users.first else { return }
                viewModel.load(user: user)
            }
            Spacer()
        }
    }
}
#Preview {
    HomeView()
}
