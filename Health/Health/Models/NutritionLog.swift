//
//  NutritionLog.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class NutritionLog {
    var id: UUID
    var date: Date
    
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var dietType: DietType?
    
    init(date: Date, calories: Int, protein: Double, carbs: Double, fat: Double, dietType: DietType?) {
        self.id = UUID()
        self.date = date
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.dietType = dietType
    }
}
