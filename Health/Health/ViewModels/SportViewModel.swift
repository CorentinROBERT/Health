//
//  SportViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class SportViewModel : ObservableObject{
    
    // MARK: - CREATE
    func add(
        type: SportType,
        duration: Double,
        calories: Double?,
        notes: String?,
        context: ModelContext
    ) {
        let activity = SportActivity(
            date: Date(),
            type: type,
            duration: duration
        )
        
        activity.calories = calories
        activity.notes = notes
        
        context.insert(activity)
    }
    
    // MARK: - DELETE
    func delete(_ activity: SportActivity, context: ModelContext) {
        context.delete(activity)
    }
    
    // MARK: - SORT (UX list propre)
    func sorted(_ activities: [SportActivity]) -> [SportActivity] {
        activities.sorted { $0.date > $1.date }
    }
    
    // MARK: - STATS (très utile pour Home)
    func weeklyMinutes(_ activities: [SportActivity]) -> Int {
        activities
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
            .reduce(0) { $0 + Int($1.duration / 60) }
    }
    
    func totalCalories(_ activities: [SportActivity]) -> Double {
        activities.reduce(0) { $0 + ($1.calories ?? 0) }
    }
}
