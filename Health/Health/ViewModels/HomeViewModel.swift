//
//  HomeViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var todayCalories: Int = 0
    @Published var weeklySportMinutes: Int = 0
    @Published var currentWeight: Double = 0
    
    func load(user: User) {
        
        todayCalories = user.nutritionLogs
            .filter { Calendar.current.isDateInToday($0.date) }
            .reduce(0) { $0 + $1.calories }
        
        weeklySportMinutes = user.sportActivities
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
            .reduce(0) { $0 + Int($1.duration / 60) }
        
        currentWeight = user.metrics
            .filter { $0.type == .weight }
            .last?
            .value ?? 0
    }
}
