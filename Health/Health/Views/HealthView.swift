//
//  HealthView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HealthView: View {
    
    @Query private var metrics: [HealthMetric]
    @StateObject private var viewModel = HealthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Poids actuel")
                    .font(.headline)
                
                Text("\(viewModel.latestWeight(metrics), specifier: "%.1f") kg")
                    .font(.largeTitle)
                    .bold()
                
                Text("Historique")
                    .font(.headline)
                
                ForEach(viewModel.weightTrend(metrics), id: \.self) { value in
                    Text("\(value, specifier: "%.1f") kg")
                }
            }
            .padding()
            .navigationTitle("Santé")
        }
    }
}

#Preview {
    HealthView()
}
