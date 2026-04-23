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
    
    func add(
        calories: Int,
        protein: Double,
        carbs: Double,
        fat: Double,
        dietType: DietType,
        context: ModelContext
    ) {
        let log = NutritionLog(
            date: Date(),
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            dietType: dietType
        )
        
        context.insert(log)
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
}
