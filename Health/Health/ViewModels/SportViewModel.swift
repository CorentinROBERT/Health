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
final class SportViewModel: ObservableObject {
    @Published var isPresentingAddSheet = false

    func add(
        type: SportType,
        duration: Double,
        calories: Double?,
        notes: String?,
        context: ModelContext
    ) {
        guard duration > 0 else { return }

        let activity = SportActivity(
            date: Date(),
            type: type,
            duration: duration
        )

        activity.calories = calories
        activity.notes = notes

        if let user = try? context.fetch(FetchDescriptor<User>()).first {
            user.sportActivities.append(activity)
        } else {
            context.insert(activity)
        }

        try? context.save()
        isPresentingAddSheet = false
    }

    func delete(_ activity: SportActivity, context: ModelContext) {
        context.delete(activity)
        try? context.save()
    }

    func sorted(_ activities: [SportActivity]) -> [SportActivity] {
        activities.sorted { $0.date > $1.date }
    }

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

    func sessionsThisWeek(_ activities: [SportActivity]) -> Int {
        activities.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
        }.count
    }

    func averageDuration(_ activities: [SportActivity]) -> Int {
        guard !activities.isEmpty else { return 0 }

        let totalMinutes = activities.reduce(0.0) { $0 + ($1.duration / 60) }
        return Int(totalMinutes / Double(activities.count))
    }
}
