import Foundation
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var todayCalories: Int = 0
    @Published var weeklySportMinutes: Int = 0
    @Published var currentWeight: Double = 0
    
    @Published var averageCaloriesWeek: Int = 0
    @Published var sportSessionsCount: Int = 0
    
    func load(user: User) {
        loadCalories(user)
        loadSport(user)
        loadWeight(user)
        loadExtras(user)
    }
    
    private func loadCalories(_ user: User) {
        let today = user.nutritionLogs
            .filter { Calendar.current.isDateInToday($0.date) }
        
        todayCalories = today.reduce(0) { $0 + $1.calories }
        
        let week = user.nutritionLogs
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
        
        averageCaloriesWeek = week.isEmpty ? 0 :
            week.reduce(0) { $0 + $1.calories } / week.count
    }
    
    private func loadSport(_ user: User) {
        let weekActivities = user.sportActivities
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
        
        weeklySportMinutes = weekActivities.reduce(0) {
            $0 + Int($1.duration / 60)
        }
        
        sportSessionsCount = weekActivities.count
    }
    
    private func loadWeight(_ user: User) {
        currentWeight = user.metrics
            .filter { $0.type == .weight }
            .last?
            .value ?? 0
    }
    
    private func loadExtras(_ user: User) {
        // futur : health score, trends, etc
    }
}
