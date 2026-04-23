//
//  DietType.swift
//  Health
//
//  Created by Corentin Robert on 23/04/2026.
//

import Foundation

enum DietType: String, Codable, CaseIterable {
    case normal
    case lowSalt
    case lowSugar
    case highProtein
    case vegetarian
    case vegan
}
