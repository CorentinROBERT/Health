//
//  AddSportView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct AddSportView: View {
    @ObservedObject var viewModel: SportViewModel

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var type: SportType = .running
    @State private var durationText = ""
    @State private var caloriesText = ""
    @State private var notes: String = ""

    private var isFormValid: Bool {
        Double(durationText.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activité") {
                    Picker("Type", selection: $type) {
                        ForEach(SportType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }

                    TextField("Ex. 45 min", text: $durationText)
                        .keyboardType(.decimalPad)
                }

                Section("Details") {
                    TextField("Ex. 320 calories", text: $caloriesText)
                        .keyboardType(.decimalPad)

                    TextField("Ajoutez un contexte sur votre seance", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Ajouter sport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        let duration = Double(durationText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        let calories = Double(caloriesText.replacingOccurrences(of: ",", with: "."))
                        viewModel.add(
                            type: type,
                            duration: duration * 60,
                            calories: (calories ?? 0) > 0 ? calories : nil,
                            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
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
    AddSportView(viewModel: SportViewModel())
}
