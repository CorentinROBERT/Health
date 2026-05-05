import Foundation

struct HealthAnalysisSummary: Sendable {
    let averageDailyCalories: Int
    let healthScore: Int
    let weightTrend: WeightTrend
    let activityStatus: ActivityStatus
    let insight: String
}

struct WeightTrend: Sendable {
    let direction: WeightTrendDirection
    let delta: Double
}

enum WeightTrendDirection: Sendable {
    case up
    case down
    case stable
}

struct ActivityStatus: Sendable {
    let dropDetected: Bool
    let recentWeeklyMinutes: Int
    let baselineWeeklyMinutes: Int
}

struct UserHealthSnapshot: Sendable {
    let referenceDate: Date
    let nutritionLogs: [NutritionLogSnapshot]
    let activities: [SportActivitySnapshot]
    let weights: [WeightSnapshot]

    init(user: User, referenceDate: Date = Date()) {
        self.referenceDate = referenceDate
        self.nutritionLogs = user.nutritionLogs.map {
            NutritionLogSnapshot(date: $0.date, calories: $0.calories)
        }
        self.activities = user.sportActivities.map {
            SportActivitySnapshot(
                date: $0.date,
                duration: $0.duration,
                calories: $0.calories,
                intensity: $0.intensity
            )
        }
        self.weights = user.metrics
            .filter { $0.type == .weight }
            .map { WeightSnapshot(date: $0.date, value: $0.value) }
    }
}

struct NutritionLogSnapshot: Sendable {
    let date: Date
    let calories: Int
}

struct SportActivitySnapshot: Sendable {
    let date: Date
    let duration: TimeInterval
    let calories: Double?
    let intensity: Int?
}

struct WeightSnapshot: Sendable {
    let date: Date
    let value: Double
}
