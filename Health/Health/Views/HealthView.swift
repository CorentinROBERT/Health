//
//  HealthView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HealthView: View {
    @Query private var metrics: [HealthMetric]
    @Query private var records: [HealthRecord]
    @Environment(\.modelContext) private var context

    @StateObject private var viewModel = HealthViewModel()

    private var weightTrend: [Double] {
        viewModel.weightTrend(metrics)
    }

    private var recentMetrics: [HealthMetric] {
        viewModel.recentMetrics(metrics)
    }

    private var sortedRecords: [HealthRecord] {
        viewModel.sortedRecords(records)
    }

    private var visibleMetrics: [HealthMetric] {
        Array(recentMetrics.prefix(5))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(red: 0.96, green: 0.91, blue: 0.93)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                List {
                    Section {
                        headerView
                            .listRowInsets(EdgeInsets(top: 16, leading: 20, bottom: 12, trailing: 20))
                            .listRowBackground(Color.clear)

                        kpisGrid
                            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 12, trailing: 20))
                            .listRowBackground(Color.clear)

                        if !weightTrend.isEmpty {
                            trendCard
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                                .listRowBackground(Color.clear)
                        }
                    }

                    Section("Mesures recentes") {
                        if visibleMetrics.isEmpty {
                            emptyState(
                                title: "Aucune mesure",
                                message: "Ajoutez une metrique de sante pour commencer votre historique."
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                            .listRowBackground(Color.clear)
                        } else {
                            ForEach(visibleMetrics) { metric in
                                NavigationLink {
                                    HealthMetricDetailView(metric: metric)
                                } label: {
                                    metricCard(for: metric)
                                }
                                .buttonStyle(.plain)
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteMetrics)
                        }
                    }

                    Section("Dossiers medicaux") {
                        if sortedRecords.isEmpty {
                            emptyState(
                                title: "Aucun dossier",
                                message: "Ajoutez une consultation, un examen ou un traitement depuis le bouton plus."
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                            .listRowBackground(Color.clear)
                        } else {
                            ForEach(sortedRecords) { record in
                                NavigationLink {
                                    HealthRecordDetailView(record: record)
                                } label: {
                                    recordCard(for: record)
                                }
                                .buttonStyle(.plain)
                                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteRecords)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

                Button {
                    viewModel.isPresentingAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 58, height: 58)
                        .background(Color.red, in: Circle())
                        .shadow(color: .black.opacity(0.18), radius: 16, y: 10)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
            .navigationTitle("Sante")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.isPresentingAddSheet) {
                AddHealthEntryView(viewModel: viewModel)
            }
        }
    }
}

private extension HealthView {
    var deltaLabel: String {
        let delta = viewModel.weightDelta(metrics)
        let prefix = delta > 0 ? "+" : ""
        return "\(prefix)\(delta.formatted(.number.precision(.fractionLength(1)))) kg"
    }

    var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gardez votre sante sous controle")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text("Centralisez vos mesures et vos dossiers medicaux dans une vue plus lisible.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Label("Suivi personnel", systemImage: "heart.text.square.fill")
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

    var kpisGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 16
        ) {
            KPIHome(
                title: "Poids actuel",
                value: "\(viewModel.latestWeight(metrics).formatted(.number.precision(.fractionLength(1)))) kg",
                subtitle: "Derniere mesure",
                systemImage: "scalemass.fill",
                tint: .blue
            )

            KPIHome(
                title: "Evolution",
                value: deltaLabel,
                subtitle: "Depuis la premiere mesure",
                systemImage: "chart.line.uptrend.xyaxis",
                tint: .green
            )

            KPIHome(
                title: "Calories brulees",
                value: "\(Int(viewModel.latestMetricValue(for: .caloriesBurned, in: metrics))) kcal",
                subtitle: "Derniere valeur enregistree",
                systemImage: "flame.fill",
                tint: .orange
            )

            KPIHome(
                title: "Dossiers",
                value: "\(records.count)",
                subtitle: "Entrees medicales",
                systemImage: "cross.case.fill",
                tint: .pink
            )
        }
    }

    func metricCard(for metric: HealthMetric) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: metric.type.systemImage)
                .font(.title2)
                .foregroundStyle(metric.type.tintColor)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(metric.type.displayName)
                        .font(.headline)

                    Spacer()

                    Text(metric.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(metric.type.formattedValue(metric.value))
                    .font(.title3.bold())

                Text("Derniere mise a jour de votre suivi de sante.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    var trendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tendance du poids")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(Array(weightTrend.enumerated()), id: \.offset) { _, value in
                    Capsule()
                        .fill(Color.blue.opacity(0.22))
                        .frame(maxWidth: .infinity)
                        .frame(height: max(14, value))
                }
            }
            .frame(height: 90, alignment: .bottom)

            Text("Visualisation simplifiee de vos dernieres mesures.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    func recordCard(for record: HealthRecord) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(record.title)
                    .font(.headline)

                Spacer()

                Text(record.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(record.type.displayName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(record.details)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let doctorName = record.doctorName, !doctorName.isEmpty {
                Label(doctorName, systemImage: "stethoscope")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let location = record.location, !location.isEmpty {
                Label(location, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if !record.attachments.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(record.attachments) { attachment in
                        Label(attachment.fileName, systemImage: attachment.type.systemImage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    func emptyState(title: String, message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "cross.case")
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

    func deleteMetrics(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteMetric(visibleMetrics[index], context: context)
        }
    }

    func deleteRecords(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteRecord(sortedRecords[index], context: context)
        }
    }
}

#Preview {
    HealthView()
}
