import Foundation

actor HealthAnalysisEngine {
    static let shared = HealthAnalysisEngine()

    func analyze(_ snapshot: UserHealthSnapshot) async -> HealthAnalysisSummary {
        async let averageCalories = computeAverageCalories(from: snapshot.nutritionLogs, referenceDate: snapshot.referenceDate)
        async let weightTrend = computeWeightTrend(from: snapshot.weights)
        async let activityStatus = detectActivityDrop(from: snapshot.activities, referenceDate: snapshot.referenceDate)

        let (calories, trend, activity) = await (averageCalories, weightTrend, activityStatus)
        let score = computeHealthScore(
            averageCalories: calories,
            weightTrend: trend,
            activityStatus: activity
        )

        return HealthAnalysisSummary(
            averageDailyCalories: calories,
            healthScore: score,
            weightTrend: trend,
            activityStatus: activity,
            insight: buildInsight(
                averageCalories: calories,
                weightTrend: trend,
                activityStatus: activity,
                healthScore: score
            )
        )
    }

    private func computeAverageCalories(
        from logs: [NutritionLogSnapshot],
        referenceDate: Date
    ) -> Int {
        let recentLogs = logs.filter { log in
            guard let days = Calendar.current.dateComponents([.day], from: log.date, to: referenceDate).day else {
                return false
            }

            return days >= 0 && days < 7
        }

        let source = recentLogs.isEmpty ? logs : recentLogs
        guard !source.isEmpty else { return 0 }

        let total = source.reduce(0) { $0 + $1.calories }
        return total / source.count
    }

    private func computeWeightTrend(from weights: [WeightSnapshot]) -> WeightTrend {
        let sortedWeights = weights.sorted { $0.date < $1.date }
        guard sortedWeights.count >= 2 else {
            return WeightTrend(direction: .stable, delta: 0)
        }

        let latestSamples = Array(sortedWeights.suffix(3))
        let previousSamples = Array(sortedWeights.dropLast(latestSamples.count).suffix(3))
        let latestAverage = latestSamples.map(\.value).reduce(0, +) / Double(latestSamples.count)
        let previousAverage: Double

        if previousSamples.isEmpty {
            previousAverage = sortedWeights.first?.value ?? latestAverage
        } else {
            previousAverage = previousSamples.map(\.value).reduce(0, +) / Double(previousSamples.count)
        }

        let delta = latestAverage - previousAverage

        if delta > 0.4 {
            return WeightTrend(direction: .up, delta: delta)
        }

        if delta < -0.4 {
            return WeightTrend(direction: .down, delta: abs(delta))
        }

        return WeightTrend(direction: .stable, delta: abs(delta))
    }

    private func detectActivityDrop(
        from activities: [SportActivitySnapshot],
        referenceDate: Date
    ) -> ActivityStatus {
        let recentWeeklyMinutes = totalMinutes(
            for: activities,
            withinDayRange: 0..<7,
            referenceDate: referenceDate
        )
        let baselineWeeklyMinutes = totalMinutes(
            for: activities,
            withinDayRange: 7..<14,
            referenceDate: referenceDate
        )

        let dropDetected = baselineWeeklyMinutes >= 60 && recentWeeklyMinutes < Int(Double(baselineWeeklyMinutes) * 0.6)

        return ActivityStatus(
            dropDetected: dropDetected,
            recentWeeklyMinutes: recentWeeklyMinutes,
            baselineWeeklyMinutes: baselineWeeklyMinutes
        )
    }

    private func totalMinutes(
        for activities: [SportActivitySnapshot],
        withinDayRange range: Range<Int>,
        referenceDate: Date
    ) -> Int {
        activities.reduce(into: 0) { total, activity in
            guard let days = Calendar.current.dateComponents([.day], from: activity.date, to: referenceDate).day else {
                return
            }

            guard range.contains(days) else { return }
            total += Int(activity.duration / 60)
        }
    }

    private func computeHealthScore(
        averageCalories: Int,
        weightTrend: WeightTrend,
        activityStatus: ActivityStatus
    ) -> Int {
        var score = 40

        switch averageCalories {
        case 1_800...2_400:
            score += 20
        case 1_500...2_700:
            score += 10
        default:
            break
        }

        score += min(activityStatus.recentWeeklyMinutes / 10, 20)

        switch weightTrend.direction {
        case .stable:
            score += 15
        case .down, .up:
            if weightTrend.delta < 1.0 {
                score += 8
            }
        }

        if !activityStatus.dropDetected {
            score += 15
        }

        return min(max(score, 0), 100)
    }

    private func buildInsight(
        averageCalories: Int,
        weightTrend: WeightTrend,
        activityStatus: ActivityStatus,
        healthScore: Int
    ) -> String {
        if activityStatus.dropDetected {
            return "Baisse d'activite detectee: \(activityStatus.recentWeeklyMinutes) min cette semaine contre \(activityStatus.baselineWeeklyMinutes) min la semaine precedente."
        }

        switch weightTrend.direction {
        case .up:
            return "Le poids est en hausse de \(weightTrend.delta.formatted(.number.precision(.fractionLength(1)))) kg sur les dernieres mesures. Score global: \(healthScore)/100."
        case .down:
            return "Le poids est en baisse de \(weightTrend.delta.formatted(.number.precision(.fractionLength(1)))) kg. Apport moyen: \(averageCalories) kcal/jour."
        case .stable:
            return "Les indicateurs sont stables. Apport moyen: \(averageCalories) kcal/jour et score sante de \(healthScore)/100."
        }
    }
}
