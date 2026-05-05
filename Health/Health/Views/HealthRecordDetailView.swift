//
//  HealthRecordDetailView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData
import QuickLook
import UIKit

struct HealthRecordDetailView: View {
    let record: HealthRecord
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAttachment: Attachment?
    @State private var isShowingDeleteConfirmation = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                headerCard

                detailSection(title: "Type", value: record.type.displayName)
                detailSection(title: "Date", value: record.date.formatted(date: .complete, time: .omitted))
                detailSection(title: "Détails", value: record.details)

                if let doctorName = record.doctorName, !doctorName.isEmpty {
                    detailSection(title: "Médecin", value: doctorName)
                }

                if let location = record.location, !location.isEmpty {
                    detailSection(title: "Lieu", value: location)
                }

                if !record.attachments.isEmpty {
                    attachmentsSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Détail dossier")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    isShowingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog(
                    "Supprimer ce dossier",
                    isPresented: $isShowingDeleteConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Supprimer", role: .destructive) {
                        let attachments = record.attachments
                        record.attachments.removeAll()
                        attachments.forEach(context.delete)
                        context.delete(record)
                        try? context.save()
                        dismiss()
                    }

                    Button("Annuler", role: .cancel) {
                    }
                } message: {
                    Text("Ce dossier médical et ses pièces jointes seront supprimés.")
                }
            }
        }
        .sheet(item: $selectedAttachment) { attachment in
            AttachmentPreviewView(attachment: attachment)
        }
    }
}

private extension HealthRecordDetailView {
    var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(record.type.displayName, systemImage: "cross.case.fill")
                .font(.headline)
                .foregroundStyle(.pink)

            Text(record.title)
                .font(.system(.title, design: .rounded, weight: .bold))

            Text("Consultez les informations détaillees de ce dossier médical.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.regularMaterial)
        )
    }

    var attachmentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pièces jointes")
                .font(.headline)

            ForEach(record.attachments) { attachment in
                Button {
                    selectedAttachment = attachment
                } label: {
                    HStack(spacing: 12) {
                        attachmentThumbnail(for: attachment)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(attachment.fileName)
                                .lineLimit(1)

                            Text(attachment.type.rawValue.uppercased())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "arrow.up.right.square")
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                )
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    @ViewBuilder
    func attachmentThumbnail(for attachment: Attachment) -> some View {
        if attachment.type == .image,
           let uiImage = UIImage(contentsOfFile: attachment.fileURL) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        } else {
            Image(systemName: attachment.type.systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 44, height: 44)
                .background(Color(.quaternarySystemFill), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    func detailSection(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
        .padding(.vertical, 14)
        .padding(.leading,20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.red.withAlphaComponent(0.15)))
        )
    }

}

#Preview {
    let record = HealthRecord(date: .now, type: .consultation, title: "Consultation générale", details: "Contrôle annuel et suivi général.")
    record.doctorName = "Dr Martin"
    record.location = "Paris"
    return HealthRecordDetailView(record: record)
}

private struct AttachmentPreviewView: View {
    let attachment: Attachment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                switch attachment.type {
                case .image:
                    if let image = previewImage {
                        ZoomableImageView(image: image)
                            .background(Color.black.opacity(0.96))
                    } else {
                        unavailableView
                    }
                case .pdf, .document:
                    if let fileURL {
                        QuickLookPreview(url: fileURL)
                    } else {
                        unavailableView
                    }
                }
            }
            .navigationTitle(attachment.fileName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private extension AttachmentPreviewView {
    var fileURL: URL? {
        let url = URL(fileURLWithPath: attachment.fileURL)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    var previewImage: UIImage? {
        guard let fileURL else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    var unavailableView: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("Fichier indisponible")
                .font(.headline)

            Text("Cette piece jointe ne peut pas etre affichee pour le moment.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }
}

private struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        context.coordinator.url = url
        uiViewController.reloadData()
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        var url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            url as NSURL
        }
    }
}

private struct ZoomableImageView: View {
    let image: UIImage

    var body: some View {
        GeometryReader { proxy in
            ScrollView([.horizontal, .vertical]) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        minWidth: proxy.size.width,
                        minHeight: proxy.size.height
                    )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
