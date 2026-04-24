//
//  ProfileViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//


import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @AppStorage("hasOnboarded") var hasOnboarded = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @Published var isPresentingEditSheet = false

    func updateProfile(
        user: User,
        firstName: String,
        lastName: String,
        email: String,
        context: ModelContext
    ) {
        user.profile?.firstName = firstName
        user.profile?.lastName = lastName
        user.profile?.email = email
        try? context.save()
        isPresentingEditSheet = false
    }

    func formattedBirthDate(_ user: User) -> String {
        guard let date = user.profile?.birthDate else { return "-" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    func age(_ user: User) -> Int {
        guard let birthDate = user.profile?.birthDate else { return 0 }

        return Calendar.current.dateComponents([.year],
                                               from: birthDate,
                                               to: Date()).year ?? 0
    }

    func connectedDevicesCount(_ user: User) -> Int {
        user.devices.count
    }

    func fullName(_ user: User) -> String {
        let firstName = user.profile?.firstName ?? ""
        let lastName = user.profile?.lastName ?? ""
        let value = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        return value.isEmpty ? "Utilisateur" : value
    }

    func requestAccountDeletion(user: User) {
        print("RGPD: deletion requested for user \(user.id)")
    }

    func deleteHealthData(user: User, context: ModelContext) {
        let records = user.healthRecords
        let attachments = records.flatMap(\.attachments)
        let activities = user.sportActivities
        let logs = user.nutritionLogs
        let metrics = user.metrics
        let goals = user.goals

        user.healthRecords.removeAll()
        user.sportActivities.removeAll()
        user.nutritionLogs.removeAll()
        user.metrics.removeAll()
        user.goals.removeAll()

        attachments.forEach(context.delete)
        records.forEach(context.delete)
        activities.forEach(context.delete)
        logs.forEach(context.delete)
        metrics.forEach(context.delete)
        goals.forEach(context.delete)

        try? context.save()
    }

    func disconnect() {
        hasOnboarded = false
        isLoggedIn = false
    }
}
