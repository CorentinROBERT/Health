//
//  AddNutritionView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct AddNutritionView: View {
    @ObservedObject var viewModel: NutritionViewModel

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var caloriesText = ""
    @State private var proteinText = ""
    @State private var carbsText = ""
    @State private var fatText = ""
    @State private var dietType: DietType = .normal

    private var isFormValid: Bool {
        Int(caloriesText) ?? 0 > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Apport") {
                    TextField("Calories (Ex. 550 Kcal)", text: $caloriesText)
                        .keyboardType(.numberPad)
                }

                Section("Macros") {
                    TextField("Protéines (Ex. 30g)", text: $proteinText)
                        .keyboardType(.decimalPad)

                    TextField("Glucides (Ex. 60g)", text: $carbsText)
                        .keyboardType(.decimalPad)

                    TextField("Lipides (Ex. 20g)", text: $fatText)
                        .keyboardType(.decimalPad)
                }

                Section("Régime") {
                    Picker("Type", selection: $dietType) {
                        ForEach(DietType.allCases, id: \.self) { diet in
                            Text(diet.rawValue.capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Ajouter repas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let protein = Double(proteinText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let carbs = Double(carbsText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let fat = Double(fatText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        viewModel.add(
                            calories: Int(caloriesText) ?? 0,
                            protein: protein,
                            carbs: carbs,
                            fat: fat,
                            dietType: dietType,
                            context: context
                        )
                        dismiss()
                    }
                    .disabled(!isFormValid)
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
    AddNutritionView(viewModel: NutritionViewModel())
}
