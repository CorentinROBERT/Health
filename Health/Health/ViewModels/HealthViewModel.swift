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
    @Published var isPresentingAddSheet = false

    func addMetric(
        type: MetricType,
        value: Double,
        context: ModelContext
    ) {
        guard value > 0 else { return }

        let metric = HealthMetric(
            date: Date(),
            type: type,
            value: value
        )

        if let user = try? context.fetch(FetchDescriptor<User>()).first {
            user.metrics.append(metric)
        } else {
            context.insert(metric)
        }

        try? context.save()
        isPresentingAddSheet = false
    }

    func addRecord(
        type: HealthRecordType,
        title: String,
        details: String,
        doctorName: String?,
        location: String?,
        attachments: [Attachment],
        context: ModelContext
    ) {
        let record = HealthRecord(
            date: Date(),
            type: type,
            title: title,
            details: details
        )

        record.doctorName = doctorName
        record.location = location
        record.attachments = attachments

        if let user = try? context.fetch(FetchDescriptor<User>()).first {
            user.healthRecords.append(record)
        } else {
            context.insert(record)
        }

        try? context.save()
        isPresentingAddSheet = false
    }

    func deleteMetric(_ metric: HealthMetric, context: ModelContext) {
        context.delete(metric)
        try? context.save()
    }

    func deleteRecord(_ record: HealthRecord, context: ModelContext) {
        let attachments = record.attachments
        record.attachments.removeAll()
        attachments.forEach(context.delete)
        context.delete(record)
        try? context.save()
    }

    func latestWeight(_ metrics: [HealthMetric]) -> Double {
        metrics
            .filter { $0.type == .weight }
            .sorted { $0.date < $1.date }
            .last?
            .value ?? 0
    }

    func weightTrend(_ metrics: [HealthMetric]) -> [Double] {
        metrics
            .filter { $0.type == .weight }
            .sorted { $0.date < $1.date }
            .map { $0.value }
    }

    func latestMetricValue(for type: MetricType, in metrics: [HealthMetric]) -> Double {
        metrics
            .filter { $0.type == type }
            .sorted { $0.date < $1.date }
            .last?
            .value ?? 0
    }

    func weightDelta(_ metrics: [HealthMetric]) -> Double {
        let trend = weightTrend(metrics)
        guard let first = trend.first, let last = trend.last, trend.count > 1 else { return 0 }
        return last - first
    }

    func sortedRecords(_ records: [HealthRecord]) -> [HealthRecord] {
        records.sorted { $0.date > $1.date }
    }

    func recentMetrics(_ metrics: [HealthMetric]) -> [HealthMetric] {
        metrics.sorted { $0.date > $1.date }
    }
}
