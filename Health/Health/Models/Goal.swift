//
//  Goal.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    
    var type: GoalType
    var targetValue: Double
    
    var startDate: Date
    var endDate: Date?
    
    var isActive: Bool
    
    init(type: GoalType, targetValue: Double, startDate: Date) {
        self.id = UUID()
        self.type = type
        self.targetValue = targetValue
        self.startDate = startDate
        self.isActive = true
    }
}
