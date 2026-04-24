//
//  HealthMetricDetailView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct HealthMetricDetailView: View {
    let metric: HealthMetric
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDeleteConfirmation = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 5) {
                headerCard

                detailSection(title: "Categorie", value: metric.type.displayName)
                detailSection(title: "Valeur", value: metric.type.formattedValue(metric.value))
                detailSection(
                    title: "Date",
                    value: metric.date.formatted(date: .complete, time: .shortened)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detail mesure")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog(
                    "Supprimer cette mesure",
                    isPresented: $isShowingDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Supprimer", role: .destructive) {
                        context.delete(metric)
                        try? context.save()
                        dismiss()
                    }

                    Button("Annuler", role: .cancel) {
                    }
                } message: {
                    Text("Cette mesure sera retiree de votre suivi de sante.")
                }
            }
        }
    }
}

private extension HealthMetricDetailView {
    var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(metric.type.displayName, systemImage: metric.type.systemImage)
                .font(.headline)
                .foregroundStyle(metric.type.tintColor)

            Text(metric.type.formattedValue(metric.value))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))

            Text("Historique de votre suivi de sante.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    func detailSection(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

}

#Preview {
    HealthMetricDetailView(metric: HealthMetric(date: .now, type: .weight, value: 72.4))
}
