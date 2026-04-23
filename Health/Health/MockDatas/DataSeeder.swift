//
//  DataSeeder.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

struct DataSeeder {
    
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<User>()
        
        if let count = try? context.fetchCount(descriptor), count > 0 {
            return
        }
        
        seed(context: context)
    }
    
    static func seed(context: ModelContext) {
        
        let user = User()
        
        // MARK: - Profile
        let profile = Profile(
            firstName: "Corentin",
            lastName: "Robert",
            birthDate: Calendar.current.date(from: DateComponents(
                year: 1996,
                month: 2,
                day: 6
            ))!,
            email: "corentin.robert@email.com"
        )
        
        user.profile = profile
        
        let calendar = Calendar.current
        
        // MARK: - SPORT (7 jours)
        let sportTypes: [SportType] = [.running, .gym, .running, .stretching, .gym, .running, .cycling]
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            
            let activity = SportActivity(
                date: date,
                type: sportTypes[i],
                duration: Double(Int.random(in: 1500...4200))
            )
            
            activity.calories = Double(Int.random(in: 250...700))
            activity.intensity = Int.random(in: 2...5)
            activity.notes = "Session \(sportTypes[i].rawValue)"
            
            user.sportActivities.append(activity)
        }
        
        // MARK: - NUTRITION (7 jours)
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            
            let calories = Int.random(in: 1800...2600)
            
            let log = NutritionLog(
                date: date,
                calories: calories,
                protein: Double(Int.random(in: 80...140)),
                carbs: Double(Int.random(in: 150...300)),
                fat: Double(Int.random(in: 50...90)),
                dietType: .normal
            )
            
            user.nutritionLogs.append(log)
        }
        
        // MARK: - WEIGHT PROGRESSION
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            
            let baseWeight = 76.0
            let variation = Double.random(in: -0.5...0.3)
            
            let metric = HealthMetric(
                date: date,
                type: .weight,
                value: baseWeight + Double(i) * variation
            )
            
            user.metrics.append(metric)
        }
        
        // MARK: - EXTRA METRICS
        user.metrics.append(
            HealthMetric(
                date: Date(),
                type: .caloriesBurned,
                value: Double(Int.random(in: 400...800))
            )
        )
        
        // MARK: - INSERT
        context.insert(user)
    }
}
