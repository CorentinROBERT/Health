//
//  NutritionView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct NutritionView: View {
    @Query private var logs: [NutritionLog]
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = NutritionViewModel()

    private var todayLogs: [NutritionLog] {
        viewModel.todayLogs(logs)
    }

    private var macros: (protein: Double, carbs: Double, fat: Double) {
        viewModel.dailyMacros(todayLogs)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(red: 0.95, green: 0.97, blue: 0.90)
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
                                title: "Aujourd'hui",
                                value: "\(viewModel.totalCalories(todayLogs)) kcal",
                                subtitle: "Calories consommees",
                                systemImage: "fork.knife.circle.fill",
                                tint: .orange
                            )

                            KPIHome(
                                title: "Proteines",
                                value: "\(Int(macros.protein)) g",
                                subtitle: "Total journalier",
                                systemImage: "bolt.heart.fill",
                                tint: .red
                            )

                            KPIHome(
                                title: "Glucides",
                                value: "\(Int(macros.carbs)) g",
                                subtitle: "Apport du jour",
                                systemImage: "leaf.fill",
                                tint: .green
                            )

                            KPIHome(
                                title: "Moyenne",
                                value: "\(viewModel.averageCalories(logs)) kcal",
                                subtitle: "Par entree",
                                systemImage: "chart.bar.fill",
                                tint: .blue
                            )
                        }

                        nutritionSection
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
                        .background(Color.orange, in: Circle())
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 10)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.isPresentingAddSheet) {
                AddNutritionView(viewModel: viewModel)
            }
        }
    }
}

private extension NutritionView {
    var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mangez avec clarté")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text("Suivez vos apports du jour et gardez un oeil sur vos macros essentielles.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label("Journal nutritionnel", systemImage: "takeoutbag.and.cup.and.straw.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: colorScheme == .dark
                            ? [Color.white.opacity(0.12), Color.white.opacity(0.04)]
                            : [Color.white.opacity(0.95), Color.white.opacity(0.74)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(
                    colorScheme == .dark ? Color.white.opacity(0.12) : Color.white.opacity(0.55),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.18 : 0.06), radius: 20, y: 10)
    }

    var nutritionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Entrees du jour")
                .font(.title3.bold())

            if todayLogs.isEmpty {
                emptyState(
                    title: "Aucune entree aujourd'hui",
                    message: "Ajoutez un repas depuis le bouton plus pour alimenter votre suivi."
                )
            } else {
                ForEach(todayLogs) { log in
                    nutritionCard(for: log)
                }
            }
        }
    }

    func nutritionCard(for log: NutritionLog) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(log.dietType?.rawValue.capitalized ?? "Repas")
                    .font(.headline)

                Spacer()

                Text(log.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("\(log.calories) kcal")
                .font(.title3.bold())

            HStack(spacing: 12) {
                macroPill(title: "P", value: Int(log.protein), tint: .red)
                macroPill(title: "G", value: Int(log.carbs), tint: .green)
                macroPill(title: "L", value: Int(log.fat), tint: .orange)
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
                viewModel.delete(log, context: context)
            } label: {
                Label("Supprimer", systemImage: "trash")
            }
        }
    }

    func macroPill(title: String, value: Int, tint: Color) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(tint)
                .frame(width: 8, height: 8)

            Text("\(title) \(value) g")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(tint.opacity(0.10), in: Capsule())
    }

    func emptyState(title: String, message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "fork.knife")
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
                .fill(Color(.orange.opacity(0.12)))
        )
    }
}

#Preview {
    NutritionView()
}
