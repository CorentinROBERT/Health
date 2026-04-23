//
//  AddSportView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct AddSportView: View {
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State private var type: SportType = .running
    @State private var duration: Double = 30
    @State private var calories: Double = 200
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                
                Picker("Type", selection: $type) {
                    ForEach(SportType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                
                TextField("Durée (min)", value: $duration, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Calories", value: $calories, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Notes", text: $notes)
            }
            .navigationTitle("Ajouter sport")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let activity = SportActivity(
                            date: Date(),
                            type: type,
                            duration: duration * 60
                        )
                        
                        activity.calories = calories
                        activity.distance = nil
                        activity.notes = notes.isEmpty ? nil : notes
                        activity.intensity = nil
                        
                        context.insert(activity)
                        dismiss()
                    } label: {
                        Text("Ajouter")
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
    AddSportView()
}
