//
//  HomeView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var users: [User]

    var body: some View {
        HomeContentView(user: users.first)
    }
}

private struct HomeContentView: View {
    let user: User?
    let loadsDataOnAppear: Bool

    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: HomeViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var firstName: String {
        user?.profile?.firstName.capitalized ?? ""
    }

    @MainActor
    init(user: User?, loadsDataOnAppear: Bool = true) {
        self.user = user
        self.loadsDataOnAppear = loadsDataOnAppear
        _viewModel = StateObject(wrappedValue: HomeViewModel())
    }

    @MainActor
    init(user: User?, loadsDataOnAppear: Bool, viewModel: HomeViewModel) {
        self.user = user
        self.loadsDataOnAppear = loadsDataOnAppear
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemGroupedBackground),
                    Color(red: 0.91, green: 0.96, blue: 0.93)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerView

                    LazyVGrid(columns: columns, spacing: 16) {
                        KPIHome(
                            title: "Calories",
                            value: "\(viewModel.todayCalories) kcal",
                            subtitle: "Consommees aujourd'hui",
                            systemImage: "flame.fill",
                            tint: .orange
                        )

                        KPIHome(
                            title: "Activite",
                            value: "\(viewModel.weeklySportMinutes) min",
                            subtitle: "Cumul cette semaine",
                            systemImage: "figure.run",
                            tint: .green
                        )

                        KPIHome(
                            title: "Poids",
                            value: "\(viewModel.currentWeight.formatted(.number.precision(.fractionLength(1)))) kg",
                            subtitle: "Derniere mesure",
                            systemImage: "scalemass.fill",
                            tint: .blue
                        )

                        KPIHome(
                            title: "Objectif",
                            value: progressStatus,
                            subtitle: "Restez constant aujourd'hui",
                            systemImage: "target",
                            tint: .pink
                        )
                    }

                    insightCard
                    analysisCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .task(id: user?.id) {
            guard loadsDataOnAppear else { return }
            guard let user else { return }
            viewModel.load(user: user)
        }
    }
}

private extension HomeContentView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bonjour \(firstName)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.primary)

            Text("Voici votre recapitulatif bien-etre pour aujourd'hui.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                Label("Journalier", systemImage: "sun.max.fill")
                Label("Mise a jour live", systemImage: "waveform.path.ecg")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.12), Color.white.opacity(0.04)]
                            : [Color.white.opacity(0.96), Color.white.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ? Color.white.opacity(0.12) : Color.white.opacity(0.5),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.18 : 0.06), radius: 20, y: 10)
    }

    var insightCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tendance")
                .font(.headline)

            Text(insightMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(value: progressValue)
                .tint(.green)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    var analysisCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Analyse intelligente")
                        .font(.headline)

                    Text("Calculee en arriere-plan a partir de vos donnees recentes.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if viewModel.isAnalyzing {
                    ProgressView()
                        .controlSize(.small)
                }
            }

            if let summary = viewModel.analysisSummary {
                HStack(alignment: .top, spacing: 12) {
                    analysisMetric(
                        title: "Score sante",
                        value: "\(summary.healthScore)/100",
                        systemImage: "heart.text.square.fill",
                        tint: .red
                    )

                    analysisMetric(
                        title: "Moyenne kcal",
                        value: "\(summary.averageDailyCalories)",
                        systemImage: "fork.knife.circle.fill",
                        tint: .orange
                    )
                }

                HStack(alignment: .top, spacing: 12) {
                    analysisMetric(
                        title: "Poids",
                        value: weightTrendLabel(summary.weightTrend),
                        systemImage: weightTrendIcon(summary.weightTrend),
                        tint: weightTrendTint(summary.weightTrend)
                    )

                    analysisMetric(
                        title: "Activite",
                        value: summary.activityStatus.dropDetected ? "Anomalie" : "Stable",
                        systemImage: summary.activityStatus.dropDetected ? "exclamationmark.triangle.fill" : "figure.walk.motion",
                        tint: summary.activityStatus.dropDetected ? .yellow : .green
                    )
                }

                Text(summary.insight)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Text("L'analyse des tendances de poids, calories et activite est en cours.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    func analysisMetric(title: String, value: String, systemImage: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)
                .frame(width: 40, height: 40)
                .background(tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    var progressValue: Double {
        min(Double(viewModel.weeklySportMinutes) / 150.0, 1.0)
    }

    var progressStatus: String {
        if viewModel.weeklySportMinutes >= 150 {
            return "Atteint"
        }

        return "\(max(150 - viewModel.weeklySportMinutes, 0)) min"
    }

    var insightMessage: String {
        if let summary = viewModel.analysisSummary {
            return summary.insight
        }

        if viewModel.isAnalyzing {
            return "Analyse des tendances en cours. Les calculs sont executes en arriere-plan pour preserver la fluidite de l'interface."
        }

        if viewModel.weeklySportMinutes >= 150 {
            return "Votre objectif hebdomadaire d'activite est atteint. Maintenez ce rythme."
        }

        if viewModel.todayCalories > 0 {
            return "Vous avez deja enregistre \(viewModel.todayCalories) kcal aujourd'hui. Encore \(max(150 - viewModel.weeklySportMinutes, 0)) min d'activite pour atteindre le repere hebdomadaire."
        }

        return "Commencez votre suivi du jour en ajoutant votre nutrition ou une activite sportive."
    }

    func weightTrendLabel(_ trend: WeightTrend) -> String {
        switch trend.direction {
        case .up:
            return "+\(trend.delta.formatted(.number.precision(.fractionLength(1)))) kg"
        case .down:
            return "-\(trend.delta.formatted(.number.precision(.fractionLength(1)))) kg"
        case .stable:
            return "Stable"
        }
    }

    func weightTrendIcon(_ trend: WeightTrend) -> String {
        switch trend.direction {
        case .up:
            return "arrow.up.right.circle.fill"
        case .down:
            return "arrow.down.right.circle.fill"
        case .stable:
            return "equal.circle.fill"
        }
    }

    func weightTrendTint(_ trend: WeightTrend) -> Color {
        switch trend.direction {
        case .up:
            return .orange
        case .down:
            return .blue
        case .stable:
            return .green
        }
    }
}

#Preview {
    HomeContentView(
        user: homePreviewUser(),
        loadsDataOnAppear: false,
        viewModel: .preview()
    )
}

private func homePreviewUser() -> User {
    let user = User()
    user.profile = Profile(
        firstName: "Corentin",
        lastName: "Robert",
        birthDate: Calendar.current.date(from: DateComponents(year: 1996, month: 2, day: 6)) ?? Date(),
        email: "corentin.robert@email.com"
    )

    let calendar = Calendar.current
    let sportTypes: [SportType] = [.running, .gym, .running, .stretching, .gym, .running, .cycling]

    for index in 0..<7 {
        let date = calendar.date(byAdding: .day, value: -index, to: Date()) ?? Date()
        let activity = SportActivity(
            date: date,
            type: sportTypes[index],
            duration: Double(2_100 + index * 180)
        )
        activity.calories = Double(320 + index * 35)
        activity.intensity = min(5, 3 + index % 3)
        user.sportActivities.append(activity)
    }

    for index in 0..<7 {
        let date = calendar.date(byAdding: .day, value: -index, to: Date()) ?? Date()
        let log = NutritionLog(
            date: date,
            calories: 1_950 + index * 70,
            protein: 110,
            carbs: 220,
            fat: 65,
            dietType: .normal
        )
        user.nutritionLogs.append(log)
    }

    for index in 0..<7 {
        let date = calendar.date(byAdding: .day, value: -index, to: Date()) ?? Date()
        let metric = HealthMetric(
            date: date,
            type: .weight,
            value: 76.4 - Double(index) * 0.2
        )
        user.metrics.append(metric)
    }

    user.metrics.append(
        HealthMetric(
            date: Date(),
            type: .caloriesBurned,
            value: 540
        )
    )

    return user
}
