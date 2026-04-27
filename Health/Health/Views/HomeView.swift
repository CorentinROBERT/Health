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
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = HomeViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    private var firstName: String {
        users.first?.profile?.firstName.capitalized ?? ""
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
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            guard let user = users.first else { return }
            viewModel.load(user: user)
        }
    }
}

private extension HomeView {
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
        if viewModel.weeklySportMinutes >= 150 {
            return "Votre objectif hebdomadaire d'activite est atteint. Maintenez ce rythme."
        }

        if viewModel.todayCalories > 0 {
            return "Vous avez deja enregistre \(viewModel.todayCalories) kcal aujourd'hui. Encore \(max(150 - viewModel.weeklySportMinutes, 0)) min d'activite pour atteindre le repere hebdomadaire."
        }

        return "Commencez votre suivi du jour en ajoutant votre nutrition ou une activite sportive."
    }
}

#Preview {
    HomeView()
}
