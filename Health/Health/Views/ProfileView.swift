//
//  ProfileView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var users: [User]
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isShowingDisconnectConfirmation = false
    @State private var isShowingHealthDataDeletionConfirmation = false
    @State private var isShowingDeletionInfo = false
    @State private var isShowingHealthDataDeletedInfo = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(.systemGroupedBackground),
                        Color(red: 0.92, green: 0.93, blue: 0.98)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        if let user = users.first {
                            profileHeader(for: user)
                            identitySection(for: user)
                            actionsSection(for: user)
                        } else {
                            emptyState
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $viewModel.isPresentingEditSheet) {
                if let user = users.first {
                    EditProfileView(user: user, viewModel: viewModel)
                }
            }
            .alert("Demande envoyee", isPresented: $isShowingDeletionInfo) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text("Votre demande de suppression de compte a bien ete prise en compte. Nous reviendrons vers vous prochainement.")
            }
            .alert("Donnees supprimees", isPresented: $isShowingHealthDataDeletedInfo) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text("Vos donnees de sante ont ete supprimees de l'application.")
            }
        }
    }
}

private extension ProfileView {
    func profileHeader(for user: User) -> some View {
        HStack(spacing: 18) {
            Circle()
                .fill(Color.white.opacity(0.75))
                .frame(width: 82, height: 82)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.fullName(user))
                    .font(.system(.title, design: .rounded, weight: .bold))

                Text("\(viewModel.age(user)) ans")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(viewModel.formattedBirthDate(user))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Modifier") {
                viewModel.isPresentingEditSheet = true
            }
            .font(.subheadline.weight(.semibold))
            .buttonStyle(.borderedProminent)
            .tint(.blue)
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

    func identitySection(for user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informations")
                .font(.title3.bold())

            VStack(spacing: 14) {
                ProfileRow(title: "Email", value: user.profile?.email ?? "-")
                ProfileRow(title: "Appareils connectes", value: "\(viewModel.connectedDevicesCount(user))")
                ProfileRow(title: "Date de naissance", value: viewModel.formattedBirthDate(user))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.regularMaterial)
            )
        }
    }

    func actionsSection(for user: User) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actions")
                .font(.title3.bold())

            Button {
                isShowingDisconnectConfirmation = true
            } label: {
                Text("Deconnexion")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .foregroundStyle(.primary)
            .confirmationDialog(
                "Confirmer la deconnexion",
                isPresented: $isShowingDisconnectConfirmation,
                titleVisibility: .visible
            ) {
                Button("Se deconnecter", role: .destructive) {
                    viewModel.disconnect()
                }

                Button("Annuler", role: .cancel) {
                }
            } message: {
                Text("Vous devrez vous reconnecter pour acceder de nouveau a votre espace.")
            }

            Button {
                isShowingHealthDataDeletionConfirmation = true
            } label: {
                Text("Supprimer mes donnees de sante")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .foregroundStyle(.orange)
            .confirmationDialog(
                "Supprimer les donnees de sante",
                isPresented: $isShowingHealthDataDeletionConfirmation,
                titleVisibility: .visible
            ) {
                Button("Supprimer", role: .destructive) {
                    viewModel.deleteHealthData(user: user, context: context)
                    isShowingHealthDataDeletedInfo = true
                }

                Button("Annuler", role: .cancel) {
                }
            } message: {
                Text("Cette action supprimera vos mesures, dossiers medicaux, activites, logs nutritionnels et objectifs enregistres dans l'application.")
            }

            Button {
                viewModel.requestAccountDeletion(user: user)
                isShowingDeletionInfo = true
            } label: {
                Text("Supprimer mon compte")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .foregroundStyle(.red)
        }
    }

    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("Profil indisponible")
                .font(.headline)

            Text("Aucun utilisateur n'a ete trouve dans la base locale.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ProfileView()
}
