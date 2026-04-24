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

    @State private var calories: Int = 500
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0
    @State private var dietType: DietType = .normal

    private var isFormValid: Bool {
        calories > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Apport") {
                    TextField("Calories", value: $calories, format: .number)
                        .keyboardType(.numberPad)
                }

                Section("Macros") {
                    TextField("Proteines", value: $protein, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Glucides", value: $carbs, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Lipides", value: $fat, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section("Regime") {
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
                        viewModel.add(
                            calories: calories,
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
