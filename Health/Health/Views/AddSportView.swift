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
    @State private var duration: Double = 30
    @State private var calories: Double = 200
    @State private var notes: String = ""

    private var isFormValid: Bool {
        duration > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activite") {
                    Picker("Type", selection: $type) {
                        ForEach(SportType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized)
                        }
                    }

                    TextField("Duree (min)", value: $duration, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section("Details") {
                    TextField("Calories", value: $calories, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Ajouter sport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        viewModel.add(
                            type: type,
                            duration: duration * 60,
                            calories: calories > 0 ? calories : nil,
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
