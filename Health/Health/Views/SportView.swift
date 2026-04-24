//
//  SportView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct SportView: View {
    @Query private var activities: [SportActivity]
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = SportViewModel()

    private var sortedActivities: [SportActivity] {
        viewModel.sorted(activities)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(red: 0.90, green: 0.96, blue: 0.94)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        headerView

                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            KPIHome(
                                title: "Cette semaine",
                                value: "\(viewModel.weeklyMinutes(activities)) min",
                                subtitle: "Temps d'activite cumule",
                                systemImage: "figure.run",
                                tint: .green
                            )

                            KPIHome(
                                title: "Calories",
                                value: "\(Int(viewModel.totalCalories(activities))) kcal",
                                subtitle: "Brulees au total",
                                systemImage: "flame.fill",
                                tint: .orange
                            )

                            KPIHome(
                                title: "Sessions",
                                value: "\(viewModel.sessionsThisWeek(activities))",
                                subtitle: "Enregistrees cette semaine",
                                systemImage: "calendar.badge.clock",
                                tint: .blue
                            )

                            KPIHome(
                                title: "Moyenne",
                                value: "\(viewModel.averageDuration(activities)) min",
                                subtitle: "Par seance",
                                systemImage: "gauge.with.dots.needle.50percent",
                                tint: .pink
                            )
                        }

                        activitySection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }

                Button {
                    viewModel.isPresentingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(Color.green, in: Circle())
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 10)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Sport")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.isPresentingAddSheet) {
                AddSportView(viewModel: viewModel)
            }
        }
    }
}

private extension SportView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Bougez avec regularite")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text("Retrouvez vos sessions recentes et ajoutez rapidement une nouvelle activite.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label("Suivi hebdomadaire", systemImage: "heart.text.square.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.95), Color.white.opacity(0.74)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.55), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 20, y: 10)
    }

    var activitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dernieres sessions")
                .font(.title3.bold())

            if sortedActivities.isEmpty {
                emptyState(
                    title: "Aucune activite",
                    message: "Ajoutez votre premiere seance pour commencer le suivi."
                )
            } else {
                ForEach(sortedActivities) { activity in
                    activityCard(for: activity)
                }
            }
        }
    }

    func activityCard(for activity: SportActivity) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "figure.run.circle.fill")
                .font(.title2)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(activity.type.rawValue.capitalized)
                        .font(.headline)

                    Spacer()

                    Text(activity.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    Label("\(Int(activity.duration / 60)) min", systemImage: "timer")
                    Label("\(Int(activity.calories ?? 0)) kcal", systemImage: "flame")
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)

                if let notes = activity.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.delete(activity, context: context)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }

    func emptyState(title: String, message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    SportView()
}
