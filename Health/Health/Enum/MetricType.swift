//
//  MetricType.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftUI

enum MetricType: String, Codable, CaseIterable {
    case weight
    case caloriesConsumed
    case caloriesBurned
    case sportDuration
}

extension MetricType {
    var displayName: String {
        switch self {
        case .weight:
            return "Poids"
        case .caloriesConsumed:
            return "Calories consommees"
        case .caloriesBurned:
            return "Calories brulees"
        case .sportDuration:
            return "Duree sportive"
        }
    }

    var systemImage: String {
        switch self {
        case .weight:
            return "scalemass.fill"
        case .caloriesConsumed:
            return "fork.knife.circle.fill"
        case .caloriesBurned:
            return "flame.fill"
        case .sportDuration:
            return "figure.run.circle.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .weight:
            return .blue
        case .caloriesConsumed:
            return .orange
        case .caloriesBurned:
            return .red
        case .sportDuration:
            return .green
        }
    }

    func formattedValue(_ value: Double) -> String {
        switch self {
        case .weight:
            return "\(value.formatted(.number.precision(.fractionLength(1)))) kg"
        case .caloriesConsumed, .caloriesBurned:
            return "\(Int(value)) kcal"
        case .sportDuration:
            return "\(Int(value)) min"
        }
    }
}
