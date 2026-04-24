import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var todayCalories: Int = 0
    @Published var weeklySportMinutes: Int = 0
    @Published var currentWeight: Double = 0
    
    func load(user: User) {
        loadCalories(user)
        loadSport(user)
        loadWeight(user)
    }
    
    private func loadCalories(_ user: User) {
        let today = user.nutritionLogs
            .filter { Calendar.current.isDateInToday($0.date) }
        
        todayCalories = today.reduce(0) { $0 + $1.calories }
        
    }
    
    private func loadSport(_ user: User) {
        let weekActivities = user.sportActivities
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
        
        weeklySportMinutes = weekActivities.reduce(0) {
            $0 + Int($1.duration / 60)
        }
    }
    
    private func loadWeight(_ user: User) {
        currentWeight = user.metrics
            .filter { $0.type == .weight }
            .sorted { $0.date < $1.date }
            .last?
            .value ?? 0
    }
}
