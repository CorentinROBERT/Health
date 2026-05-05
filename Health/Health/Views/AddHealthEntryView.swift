//
//  AddHealthEntryView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct AddHealthEntryView: View {
    @ObservedObject var viewModel: HealthViewModel

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var entryKind: EntryKind = .metric
    @State private var metricType: MetricType = .weight
    @State private var metricValueText = ""

    @State private var recordType: HealthRecordType = .consultation
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var doctorName: String = ""
    @State private var location: String = ""
    @State private var attachments: [Attachment] = []
    @State private var isImportingFiles = false

    private var isFormValid: Bool {
        switch entryKind {
        case .metric:
            return Double(metricValueText.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0
        case .record:
            return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Picker("Type d'entrée", selection: $entryKind) {
                    ForEach(EntryKind.allCases, id: \.self) { kind in
                        Text(kind == .metric ? "Métrique" : "Dossier")
                    }
                }
                .pickerStyle(.segmented)

                if entryKind == .metric {
                    Section("Métrique") {
                        Picker("Catégorie", selection: $metricType) {
                            ForEach(MetricType.allCases, id: \.self) { type in
                                Text(type.displayName)
                            }
                        }

                        TextField("Ex. 72.4", text: $metricValueText)
                            .keyboardType(.decimalPad)
                    }
                } else {
                    Section("Dossier médical") {
                        Picker("Catégorie", selection: $recordType) {
                            ForEach(HealthRecordType.allCases, id: \.self) { type in
                                Text(type.displayName)
                            }
                        }

                        TextField("Ex. Consultation generale", text: $title)

                        TextField("Decrivez le dossier ou le resultat medical", text: $details, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                    }

                    Section("Complement") {
                        TextField("Nom du docteur ou spécialiste", text: $doctorName)
                        TextField("Nom de l'hopital ou de la clinique", text: $location)
                    }

                    Section("Pièces jointes") {
                        Button("Ajouter un PDF ou une image") {
                            isImportingFiles = true
                        }

                        if attachments.isEmpty {
                            Text("Aucune pièce jointe")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(attachments) { attachment in
                                HStack {
                                    Image(systemName: attachment.type.systemImage)
                                        .foregroundStyle(.secondary)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(attachment.fileName)
                                            .lineLimit(1)

                                        Text(attachment.type.rawValue.uppercased())
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .onDelete(perform: removeAttachments)
                        }
                    }
                }
            }
            .navigationTitle("Ajouter santé")
            .navigationBarTitleDisplayMode(.inline)
            .fileImporter(
                isPresented: $isImportingFiles,
                allowedContentTypes: [.pdf, .image],
                allowsMultipleSelection: true,
                onCompletion: handleFileImport
            )
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter") {
                        submit()
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func submit() {
        switch entryKind {
        case .metric:
            viewModel.addMetric(
                type: metricType,
                value: Double(metricValueText.replacingOccurrences(of: ",", with: ".")) ?? 0,
                context: context
            )
        case .record:
            viewModel.addRecord(
                type: recordType,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                details: details.trimmingCharacters(in: .whitespacesAndNewlines),
                doctorName: doctorName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : doctorName,
                location: location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : location,
                attachments: attachments,
                context: context
            )
        }
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result else { return }

        for url in urls {
            if let attachment = makeAttachment(from: url) {
                attachments.append(attachment)
            }
        }
    }

    private func makeAttachment(from sourceURL: URL) -> Attachment? {
        let hasAccess = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if hasAccess {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let attachmentsDirectory = documentsDirectory.appendingPathComponent("HealthAttachments", isDirectory: true)
        do {
            try fileManager.createDirectory(at: attachmentsDirectory, withIntermediateDirectories: true)
        } catch {
            return nil
        }

        let destinationURL = attachmentsDirectory.appendingPathComponent("\(UUID().uuidString)-\(sourceURL.lastPathComponent)")

        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
        } catch {
            return nil
        }

        return Attachment(
            fileName: sourceURL.lastPathComponent,
            fileURL: destinationURL.path,
            type: attachmentType(for: sourceURL)
        )
    }

    private func attachmentType(for url: URL) -> AttachmentType {
        if let type = UTType(filenameExtension: url.pathExtension.lowercased()) {
            if type.conforms(to: .pdf) {
                return .pdf
            }
            if type.conforms(to: .image) {
                return .image
            }
        }

        return .document
    }

    private func removeAttachments(at offsets: IndexSet) {
        attachments.remove(atOffsets: offsets)
    }
}

#Preview {
    AddHealthEntryView(viewModel: HealthViewModel())
}
