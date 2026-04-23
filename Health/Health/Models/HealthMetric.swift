//
//  HealthMetric.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class HealthMetric {
    var id: UUID
    var date: Date
    
    var type: MetricType
    var value: Double
    
    init(date: Date, type: MetricType, value: Double) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.value = value
    }
}
