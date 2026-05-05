import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var todayCalories: Int = 0
    @Published var weeklySportMinutes: Int = 0
    @Published var currentWeight: Double = 0
    @Published var analysisSummary: HealthAnalysisSummary?
    @Published var isAnalyzing = false

    private var analysisTask: Task<Void, Never>?

    deinit {
        analysisTask?.cancel()
    }

    func load(user: User) {
        loadCalories(user)
        loadSport(user)
        loadWeight(user)
        analyzeHealthData(for: user)
    }

    private func loadCalories(_ user: User) {
        let today = user.nutritionLogs
            .filter { Calendar.current.isDateInToday($0.date) }

        todayCalories = today.reduce(0) { $0 + $1.calories }
    }

    private func loadSport(_ user: User) {
        let weekActivities = user.sportActivities
            .filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }

        weeklySportMinutes = weekActivities.reduce(0) {
            $0 + Int($1.duration / 60)
        }
    }

    private func loadWeight(_ user: User) {
        currentWeight = user.metrics
            .filter { $0.type == .weight }
            .sorted { $0.date < $1.date }
            .last?
            .value ?? 0
    }

    private func analyzeHealthData(for user: User) {
        analysisTask?.cancel()
        analysisSummary = nil
        isAnalyzing = true

        let snapshot = UserHealthSnapshot(user: user)
        analysisTask = Task { [snapshot] in
            let summary = await Task.detached(priority: .userInitiated) {
                await HealthAnalysisEngine.shared.analyze(snapshot)
            }.value

            guard !Task.isCancelled else { return }
            analysisSummary = summary
            isAnalyzing = false
        }
    }

    static func preview() -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.todayCalories = 2_140
        viewModel.weeklySportMinutes = 186
        viewModel.currentWeight = 76.4
        viewModel.isAnalyzing = false
        viewModel.analysisSummary = HealthAnalysisSummary(
            averageDailyCalories: 2_085,
            healthScore: 84,
            weightTrend: WeightTrend(direction: .down, delta: 0.6),
            activityStatus: ActivityStatus(
                dropDetected: false,
                recentWeeklyMinutes: 186,
                baselineWeeklyMinutes: 170
            ),
            insight: "Bonne dynamique: poids en baisse legere, activite stable et score sante de 84/100."
        )
        return viewModel
    }
}
