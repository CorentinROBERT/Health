//
//  AddNutritionView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct AddNutritionView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var calories: Int = 500
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0
    @State private var dietType: DietType = .normal
    
    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Calories", value: $calories, format: .number)
                    .keyboardType(.numberPad)
                
                TextField("Protéines", value: $protein, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Glucides", value: $carbs, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Lipides", value: $fat, format: .number)
                    .keyboardType(.decimalPad)
                
                Picker("Régime", selection: $dietType) {
                    ForEach(DietType.allCases, id: \.self) { diet in
                        Text(diet.rawValue.capitalized)
                    }
                }
            }
            .navigationTitle("Ajouter repas")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let log = NutritionLog(
                            date: Date(),
                            calories: calories,
                            protein: protein,
                            carbs: carbs,
                            fat: fat,
                            dietType: dietType
                        )
                        
                        context.insert(log)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddNutritionView()
}
