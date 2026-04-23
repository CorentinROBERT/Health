//
//  NutritionView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct NutritionView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \NutritionLog.date, order: .reverse) var logs: [NutritionLog]
    
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(logs) { log in
                    HStack {
                        Text("\(log.calories) kcal")
                        Spacer()
                        Text(log.date, style: .date)
                            .font(.caption)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { context.delete(logs[$0]) }
                }
            }
            .navigationTitle("Nutrition")
            .toolbar {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddNutritionView()
            }
        }
    }
}

#Preview {
    NutritionView()
}
