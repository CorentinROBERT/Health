//
//  Profile.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation
import SwiftData

@Model
final class Profile {
    var firstName: String
    var lastName: String
    var birthDate: Date
    var email: String
    
    var phone: String?
    var address: String?
    var socialSecurityNumber: String?
    
    // Photo
    var photoURL: String?
    
    init(firstName: String, lastName: String, birthDate: Date, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.email = email
    }
}
