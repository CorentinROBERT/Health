//
//  ProfileViewModel.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//


import Foundation
import SwiftData

final class ProfileViewModel {
    
    // MARK: - UPDATE PROFILE
    func updateProfile(
        user: User,
        firstName: String,
        lastName: String,
        email: String
    ) {
        user.profile?.firstName = firstName
        user.profile?.lastName = lastName
        user.profile?.email = email
    }
    
    // MARK: - BIRTHDATE FORMAT (UI helper)
    func formattedBirthDate(_ user: User) -> String {
        guard let date = user.profile?.birthDate else { return "-" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    // MARK: - AGE CALCULATION
    func age(_ user: User) -> Int {
        guard let birthDate = user.profile?.birthDate else { return 0 }
        
        return Calendar.current.dateComponents([.year],
                                               from: birthDate,
                                               to: Date()).year ?? 0
    }
    
    // MARK: - DEVICES
    func connectedDevicesCount(_ user: User) -> Int {
        user.devices.count
    }
    
    // MARK: - RGPD / DELETE REQUEST (MVP simulation)
    func requestAccountDeletion(user: User) {
        print("RGPD: deletion requested for user \(user.id)")
        // futur backend call
    }
}
