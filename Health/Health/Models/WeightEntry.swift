//
//  WeightEntry.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var date: Date
    var weight: Double
    
    init(date: Date, weight: Double) {
        self.id = UUID()
        self.date = date
        self.weight = weight
    }
}
