//
//  SportActivity.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class SportActivity {
    var id: UUID
    var date: Date
    var type: SportType
    
    var duration: Double // secondes
    
    var calories: Double?
    var distance: Double?
    var notes: String?
    
    // Bonus
    var intensity: Int? // 1-5
    
    init(date: Date, type: SportType, duration: Double) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.duration = duration
    }
}
