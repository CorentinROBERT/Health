import SwiftData
import Foundation

@Model
final class User {
    @Attribute(.unique) var id: UUID
    
    var createdAt: Date
    
    // Relations
    var profile: Profile?
    var healthRecords: [HealthRecord] = []
    var sportActivities: [SportActivity] = []
    var nutritionLogs: [NutritionLog] = []
    var metrics: [HealthMetric] = []
    var goals: [Goal] = []
    @Relationship(deleteRule: .cascade)
    var devices: [ConnectedDevice] = []
    
    init() {
        self.id = UUID()
        self.createdAt = Date()
    }
}
