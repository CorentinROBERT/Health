//
//  NutritionView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct NutritionView: View {
    
    @Query private var logs: [NutritionLog]
    @Environment(\.modelContext) private var context
    
    @StateObject private var viewModel = NutritionViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Calories") {
                    Text("\(viewModel.totalCalories(logs)) kcal")
                }
                
                Section("Logs") {
                    ForEach(logs) { log in
                        VStack(alignment: .leading) {
                            Text("\(log.calories) kcal")
                            Text(log.date.formatted())
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Nutrition")
        }
    }
}

#Preview {
    NutritionView()
}
