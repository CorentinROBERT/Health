//
//  HealthViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class HealthViewModel: ObservableObject {
    
    func addMetric(
        type: MetricType,
        value: Double,
        context: ModelContext
    ) {
        let metric = HealthMetric(
            date: Date(),
            type: type,
            value: value
        )
        
        context.insert(metric)
    }
    
    func latestWeight(_ metrics: [HealthMetric]) -> Double {
        metrics
            .filter { $0.type == .weight }
            .last?
            .value ?? 0
    }
    
    func weightTrend(_ metrics: [HealthMetric]) -> [Double] {
        metrics
            .filter { $0.type == .weight }
            .sorted { $0.date < $1.date }
            .map { $0.value }
    }
}
