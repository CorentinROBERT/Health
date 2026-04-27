//
//  EditProfileView.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import SwiftUI
import SwiftData

struct EditProfileView: View {
    let user: User
    @ObservedObject var viewModel: ProfileViewModel

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String

    init(user: User, viewModel: ProfileViewModel) {
        self.user = user
        self.viewModel = viewModel
        _firstName = State(initialValue: user.profile?.firstName ?? "")
        _lastName = State(initialValue: user.profile?.lastName ?? "")
        _email = State(initialValue: user.profile?.email ?? "")
    }

    private var isFormValid: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Informations personnelles") {
                    TextField("Firstname", text: $firstName)
                        .textContentType(.givenName)

                    TextField("LastName", text: $lastName)
                        .textContentType(.familyName)

                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
            }
            .navigationTitle("Modifier profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        viewModel.updateProfile(
                            user: user,
                            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            context: context
                        )
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
}

#Preview {
    let user = User()
    user.profile = Profile(firstName: "Jon", lastName: "Doe", birthDate: .now, email: "mail@test.com")
    return EditProfileView(user: user, viewModel: ProfileViewModel())
}
