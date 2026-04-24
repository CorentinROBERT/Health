//
//  NutritionViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class NutritionViewModel: ObservableObject {
    @Published var isPresentingAddSheet = false

    func add(
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        dietType: DietType,
        context: ModelContext
    ) {
        guard calories > 0 else { return }

        let log = NutritionLog(
            date: Date(),
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            dietType: dietType
        )

        if let user = try? context.fetch(FetchDescriptor<User>()).first {
            user.nutritionLogs.append(log)
        } else {
            context.insert(log)
        }

        try? context.save()
        isPresentingAddSheet = false
    }

    func dailyMacros(_ logs: [NutritionLog]) -> (protein: Double, carbs: Double, fat: Double) {
        let protein = logs.reduce(0) { $0 + $1.protein }
        let carbs = logs.reduce(0) { $0 + $1.carbs }
        let fat = logs.reduce(0) { $0 + $1.fat }

        return (protein, carbs, fat)
    }

    func totalCalories(_ logs: [NutritionLog]) -> Int {
        logs.reduce(0) { $0 + $1.calories }
    }

    func todayLogs(_ logs: [NutritionLog]) -> [NutritionLog] {
        logs
            .filter { Calendar.current.isDateInToday($0.date) }
            .sorted { $0.date > $1.date }
    }

    func averageCalories(_ logs: [NutritionLog]) -> Int {
        guard !logs.isEmpty else { return 0 }
        return totalCalories(logs) / logs.count
    }

    func delete(_ log: NutritionLog, context: ModelContext) {
        context.delete(log)
        try? context.save()
    }
}
